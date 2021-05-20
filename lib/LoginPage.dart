import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Register.dart';
import 'main.dart';
import 'Customer.dart';
import 'package:provider/provider.dart';
import 'AuthenticationServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
final Dbs d = new Dbs();
//final globalScaffoldKey = GlobalKey<ScaffoldState>();
class Login extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: globalScaffoldKey,
      appBar: AppBar(
        backgroundColor: color,
        title: Text("Login"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: TextField(controller: email,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "Enter your email..."),
              ),
            ),
            Container(
              child: TextField(controller: password,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "Enter your password..."),
              ),
            ),
            Container(
              child: ElevatedButton(style: ElevatedButton.styleFrom(primary: color),onPressed: () async {
                if(email.text != "" && password.text != "") {
                  String result = await context.read<AuthenticationServices>().signIn(
                    email: email.text.trim(),
                    password: password.text.trim(),
                  );
                  if(result == "Signed in") {
                    Customer customerLog = await d.findCustomer(email.text);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomeSend(customerLog, null)));
                  }
                  else
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wrong email or password.")));
                }
                else
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter all fields.")));
              },
                child: Text("Login"),),
            ),Container(
              width: 200,height: 20,
              child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.black),onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword()));
              },
                child: Text("Forgot My Password"),),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 100,
        child: FloatingActionButton(onPressed: () async{
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Register()));
        },
          backgroundColor: color,
          isExtended: true,
          child: Text("Register", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final firebaseUser = context.watch<User>();
    if(firebaseUser!=null)
      return FutureBuilder(
        future: d.findCustomer(firebaseUser.email),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            Customer prevCustomer = snapshot.data;
            return WelcomeSend(prevCustomer, null);
          }
          else
            return CircularProgressIndicator(backgroundColor: color,);
        },
      );
    else
      return Login();
  }
}