Return-Path: <linux-kernel-owner+w=401wt.eu-S935644AbZLQNjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935644AbZLQNjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935378AbZLQNjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:39:13 -0500
Received: from web82008.mail.mud.yahoo.com ([66.163.178.252]:39869 "HELO
	web82008.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935373AbZLQNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:39:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=dwM+LC3faRv1RPZURrRh7/M38fxxGH424jbpKvf66HDZt/BhyIRb3jcLyBhK4q3bfrT7Q2AS8iOIP6rjHYeT6bkiAnMMza3LF5LLy57ov2RxxojT4pgxc8/plEMVPe4Urw3FVxoyRtbbUcwYBBwQWO/mL8NcVFMP71NxAazOZ0s=;
Message-ID: <839889.78434.qm@web82008.mail.mud.yahoo.com>
X-YMail-OSG: mqpwjD0VM1kIsbm2qbbzBBfa9R._rMjssy.MxqdvJgQ_5ozY1cvc6kLpzUHINnxLrLXb.Dloc2M4KhAV548B0HMqGUSkyATuUpPchcqUSnbQ2GIaqj9I1VPIwiU6MlU2Rzv8qx0w.zjcQahyKa1AaLaTNcEugEYxhsjJjgt8BY2I0wzAs7TN0qw5.SBFeVaaxQlHaf_N6z7hvGICB5pc.tCveiS55pDdzmBJUqVGD7.vSbgidQPil2VjQp.unPswHpl1CMzQUmaaitQKrawE1f_GbZNIbfOMYNSBfXvPPfoAieakH8_7lbXR2O1qTuCO0N_EcCOCLyt2TN1sIEV6XiVUdD.WGWMy5JSTA1nnclD.5OzcNitVY7EvWsyaPgXVn_mehHgfym8MaQ3t5AxEN8DvvPH3UEs7UfLsoqkH4YKic8IpFX5bBW9xrJZjFN2JRokEH_3kDVLrY1I3dmfZcMYVAM0kmEKfN5XlheO4eU5eah22W1xVXhFgo7bkgmg2iz1Oq4pbh_Qvhh89Cpr1ljnHtXyLaIEKScyY5.aOItlHqZabGlAaCeCVUqdykQ62AEaCePydczxWWkfqEK7yX1dTapwKu1rswhsDG_jG24GCRtogBI3QYcotzEXWT0vizSTCcoPnpPELOLPN0E.7uqzIRmEg6ENBv7ard3O88UXmIAkXhLxVQFjhJlYQJfbgylAFJF7SNeO8umgs8DrR3xTtgZAYVJekXmEs1XkzN4qVrVOGrxX7km4QQlGxwWLMZiotymfVDOkli.BE9YPpscoyNo0wS.O2lA8BSdACRX8dVP8c4c4iWN4k1RRtDHtWrjZlHIUcpvmAqSo.6SG8MHH0hwO0Q5X97c.y8_jUXnbeZDxnPBuV_dG7zVrgKG4ZqvWq9mXGEl9cM.PtRiCIuMjof6vD6MAPeVYQ80HyEfMOkAHv.zqfp_upXJFE2wl9Xoq7f5ebRsbplzJuWtWj9HJ.VqRVu83g6uPsrF1lgUA5tRKf2QXPJEvdGQOrpN58M2JWh_QVygDQPABzrHh.9qXt0xPeE9ukC8H.suBlhqwDwgtPMCJK4PqBEL4Ai83.4IyrESywz3XbJ0zpaAGyAZk63OpkYCRLCymjCyxDeAbfzSrJprQooYJul68A8lWaquSBMECQTzChBcpO5QxQ2HYqwClRqwJSqiAaMivZbbmG3z_56oInHqDVj21WiZbnfUsGjQ7gN81iBJCf5opY3tIkWo6NfXXYuBflgevkh0XvyLt1MjGYA97O0zIVO7tIbqKX0ezTOct2ATU5Eq5l5q6OSSyogL4d6kgDcRcALXu2gHMK8xmrltEmk7UQG8oDl9QyIKyy9fReTpyD1RrTnPgGJFJ1DS9i4FEas7hGLoU1F_iguy0Ifq6eoQz0QJjf1mbxsYerPN0qyC6Plo4agDRxZ8001HrM1sT7Ehmi9bj6ilvHjN8Ns1cfbEE8TRi8ZH3xuRzR2brarO6siJ7k5nDp4iR2RDnwctzUDgFIRaPMUZMB_WC4hlmngHkNrmWHxXqNsInu8cevACp1tz3vxL_OaASlQxvBGBJFH3bwwjh0.REdwvFaMYkUtHOQyR33plsCOOYi48IgU9f5whm1YPr4BAuKEPAHXpEeZzepyrzOMbTxsaw6jEhIzf5yMC_h0P.3q4CBKjCNX9N_XIhR1riUBXKL8HLWeMM.vBfENVSar_cXUjc78YY2DWDJy2TCHzmoGus0eGpqLaUc8EyrAm5ZeXVULRHPT0OdAAh88g5R1xTarKZo3.nRC2uKcROSAjajFKlEiq5_rbSAjotEvfIXIdI.8_qRn40LQyeBegB8DnpNb18l0e28Fy_G9NPG1WfB6mtGmXAP.RbqNdLRWm65xVekJU0jzSndB3_GCehH5vJac1boSzg23Q--
X-Mailer: YahooMailClassic/9.0.19 YahooMailWebService/0.8.100.260964
Date: Thu, 17 Dec 2009 05:39:10 -0800 (PST)
From: Toyota Xmas Promo <charlott-carter@sbcglobal.net>
Reply-To: toyota2@onfruit.cn
Subject: re
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


750,000.00 GBP was awarded to your email in the Toyota Xmas Promo get back with:
Names
Address
Sex
