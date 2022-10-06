//
//  File.swift
//  
//
//  Created by Dan Moore on 10/6/22.
//

import SwiftUI

struct Login: Codable {
    let loginId: String
    let password: String
}

@available(macOS 11.0, *)
@available(iOS 15, *)
struct LoginForm: View {
    @State var username: String = ""
    @State var password: String = ""
    

    var body: some View {
    
        NavigationView {
                    Form {
                        TextField("Username", text: $username)
                        TextField("Password", text: $password)
                        Section {
                                            Button(action: {
                                                myTestSPMFunction()

                                                let order = Login(loginId: username,          password: password)
                                                guard let uploadData = try? JSONEncoder().encode(order) else {
                                                    return
                                                }
                                                let url = URL(string: "http://localhost:9011/api/login")!
                                                var request = URLRequest(url: url)
                                                
                                                request.httpMethod = "POST"
                                                
                                                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                                
                                                request.setValue("SkTDcD21Qqz-i4UuUpOgKmMCpkV9X50i8yZetRWgxTHOaGtYi_yH0qUb", forHTTPHeaderField: "Authorization")
                                                
                                           
                                                let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
                                                    if let error = error {
                                                        print ("error: \(error)")
                                                        return
                                                    }
                                                    guard let response = response as? HTTPURLResponse,
                                                        (200...299).contains(response.statusCode) else {
                                                        print ("server error: ",(response as? HTTPURLResponse)?.statusCode)
                                                        return
                                                    }
                                                    if let mimeType = response.mimeType,
                                                        mimeType == "application/json",
                                                        let data = data,
                                                        let dataString = String(data: data, encoding: .utf8) {
                                                        print ("got data: \(dataString)")
                                                    }
                                                }
                                                task.resume()
                                            }) {
                                                Text("Log in")
                                            }
                                        }
                    }
                    .navigationTitle("Settings")
                }
    }
}
