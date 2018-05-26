//
//  ViewController.Swift
//  StripPaymentGatewayDemo
//
//  Created by Ming-En Liu on 21/05/18.
//  Copyright © 2018 Ming-En Liu. All rights reserved.
//

import UIKit
import Stripe
import Alamofire


class ViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var payButton: UIButton!
    var paymentTextField: STPPaymentCardTextField!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var completePaymentLabel: UILabel!
    var appThemeColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
    
    override func viewDidLoad() {
        // add stripe built-in text field to fill card information in the middle of the view
        super.viewDidLoad()
        completePaymentLabel.backgroundColor  = appThemeColor
        
        // Payment View Corner radious
        paymentView.layer.cornerRadius = 4
        paymentView.layer.masksToBounds = true
        
        // Creating Card payment  TextField
        let frame1 = CGRect(x: 0, y: completePaymentLabel.frame.origin.y+completePaymentLabel.frame.size.height+10, width:paymentView.frame.size.width, height: 40)
        paymentTextField = STPPaymentCardTextField(frame: frame1)
        paymentTextField.borderColor = UIColor.clear
        paymentTextField.delegate = self
      
        
        //disable payButton if there is no card information
        payButton.isEnabled = false
        payButton.backgroundColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          paymentView.addSubview(paymentTextField)
    }
  
    
    @IBAction func payButtonTapped(sender: AnyObject) {
        let card = paymentTextField.cardParams
      //  SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
      //  SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        //send card information to stripe to get back a token
        getStripeToken(card: card)
    }
    
    
    func getStripeToken(card:STPCardParams) {
        // get stripe token for current card
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                print(token)
             //   SVProgressHUD.showSuccessWithStatus("Stripe token successfully received: \(token)")
                self.postStripeToken(token: token)
            } else {
                print(error?.localizedDescription ?? "")
            
            }
        }
    }
    
    // charge money from backend
    func postStripeToken(token: STPToken) {
        //Set up these params as your backend require
        let _: [String: NSObject] = ["stripeToken": token.tokenId as NSObject, "amount": 10 as NSObject]
        
        //TODO: Send params to your backend to process payment
        
    }
    
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        if textField.isValid{
            payButton.isEnabled = true
            payButton.backgroundColor = appThemeColor
        }
        else
        {
            payButton.backgroundColor = UIColor.lightGray
            payButton.isEnabled = false
        }
    }

}
