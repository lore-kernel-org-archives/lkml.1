Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZLSN6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZLSN6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 08:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZLSN6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 08:58:37 -0500
Received: from web50603.mail.re2.yahoo.com ([206.190.38.90]:37821 "HELO
	web50603.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751732AbZLSN6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 08:58:36 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Dec 2009 08:58:36 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-RocketYMMF:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=YNKnVsey4TF+T2f988uBGa3npZir1Wy4d5ztQbjtuEOUozCpE2ZQIAw/UREN0Ei3OisIYNkEkRj9h9fU3cYE91CFnVT5wtGEFJbA/ogdN6F3W1W4nSzv33WzPSfBjhMMEtppi2NU7YOTk0zdeQWpfJiVPY1NfaojAo7WdgoUDYg=;
Message-ID: <620087.5860.qm@web50603.mail.re2.yahoo.com>
X-YMail-OSG: sFuFWBQVM1mStCH245J22Q6F8H4V5ToVC.1V9SHpUYsx5JXXpeGZH6.9FK4Bcc1b2Jzx0vXJdVnAkwaGPPmCi1YXr6bqFOAvWFzCiIvIVgDbe5YJvsg6q4TkrPhPieX_G6IIS70te7.7WEY5kLGVl4snmEKosM2NtXOLIEt8JE.JQBN5ID6FZuN.ZZbdk.OBqZpAdQHgvBQqsIeGiviAUU.8MI.n_8uWoN6JBGNXzm50DdwhM3PpVJNTQVC2BA538gJ.DXIF_GENu4h9xImvDFsJvmyY.defv5n4RIlF63ZetpncdxLqmKCirx0xEaXQojG7ntS51VqZjmYtBRQLhTEdTyCEgt4bZ66hxc1Buf9Rb4NXBenKrXo8q4Cw_y2AFLenSB8jXjw0IEdzV69D51y.LsVrffkjrqj8rZEh2P9KOAAuqkQR1FDzUYyzRt_Z4H__Ck0c9HzjUM8xcin3vookPN0qEU48S6n.bbVi1Q8E6F.7vx1eVp_X3y96eMlLMGZEC0TM706WY4oTYtRo5bzyUobv33zzA9EJuwMEsTYRfnUz1kA_GrE9dFNKNlK85SfXWFU5p8EqzChyYzNXnW93c7JJZuTpkD6PdKWYXxOSGxeiVmHbNaceXTpgEIRD.KqtcLQIIKBotYFWDiMxM62wvld2..actELadQQ1Vy2UdfMDr.TsBNetIRu57ThPddCHwlX5sEwfNDFlt_GYYZQKbYtLAkWPGVbjhO3QzjNiVyi2E9yFCsVjzBG49Piqm.HO0bSzvU5z8PrHeeRPyoIucdn._MyRJw5wptk.6W13I2ngOrR2GX8OCcJo7eqG86MtCPdQn2FEAQBdyTvrZ6GBXAhBfYtVyCvb4ZIZsl04RFcYSnXcoC6O42rR1XRWlYqclxlvMTI.4rfvPgqBXaUuZa3iB0Ioy_9EoQswbFiH2wEkx9b3G7j8tS_0fj809E8S0at45Xaabc5QKQE.CwxfbNiH_wN6LEZfE9c4kJotzjMbM970uO.crEZ49y0Oi34WBC6IvD4DPjyfkiV3NMMl.JqlU8qEtQ6wt6mvNPUBbjWSa3Y8cF2vzgCk_pp1WvhBADoInn4DLVryD19uWP6krsGyrWDixYeLjfQK5LifbnnPmQeak4MA483s85rfgsb4PmtE4WKUbF.vVl47ZmWhfJ2lDRYhO.Hobj63lllDpDbvOrRhnPW4uy5cc0hw3C_fTOSa0FulG2wmfdm6ZoOU9g2B9IEw0_lXFCA3X0NnC2BTFddK07OFEhYdmNkb_6pf9hCObGNaKqdaEMX2.H8R1sedOLTgHlWTpwCn4TcS3EC8GRAlM_GwczKjnyDyHxJzyhxtf.w4Ko9qP4S63o9tGbpk0aaT_aB8HSEeGK020W5xRU0zlauB3pVre7DZ.zIShc_oIK4uWJEAG85ZnyfQn51L47kBqytPlE1GkPbgc36eujF_adSaL8EFOwdL3IAP0.IZc04Nl46OeAupKybeBjvYcJB4AZySEdky5W2QfVAWRx4.1QfvcvOJD4smJGAeGVUembajIZK_XBF7rO3WOpEAoM90teRcCWNH3CxcPpPaXRy5n2zPyWeixiUNHNL6fRCmvMURZ.lSqm9RjMMV0ZkRU12sQCNh3NLvI5oHptZcOsQiQLt_yfdXJ.Q-
X-RocketYMMF: jude_guei
X-Mailer: YahooMailClassic/9.0.19 YahooMailWebService/0.8.100.260964
Date: Sat, 19 Dec 2009 05:51:54 -0800 (PST)
From: Tedd Morgan <tedmorg@yahoo.com>
Reply-To: tedmorg@yahoo.com
Subject: Hello Dear !!
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear,

Please accept my apology if my mode of contacting you will in any way offend you. I am compelled to contact you via this medium for obvious reasons which you will understand when we discuss details of my proposition.
Awaiting to hear from you.
Mr.Tedd Morgan.








      
