Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbXI3VOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbXI3VOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 17:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXI3VOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 17:14:34 -0400
Received: from web56808.mail.re3.yahoo.com ([66.196.97.82]:24517 "HELO
	web56808.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751356AbXI3VOe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:14:34 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 17:14:33 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=sXEUp/Wlxcp0Iixqdc2vdmmpoGsqWLEAdKNYc4AC7PJZWUKBMYTmSmiNrah4y9h+79AcQVoiADoQXEZ3Nu84P1PJTm78w+WR7DdCDTFZSGXcJRDJV0G2GILlG+BmakFYtewU9ukRJjvZGgGD19e4/OFMKvq6ad/rAP9uXpjCiB0=;
X-YMail-OSG: PE0z..EVM1mIZeR5V03DM1zHerIBpaZUdTbkLifmwppcepm8uVi9ONXlb.UylbL_19S4seCdCuV0xHR2O8S9qLosQR8xFRxIXgml.q5N4YyISVcBn0ocrA.WYWHx4w--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Sun, 30 Sep 2007 14:07:52 -0700 (PDT)
From: Scott Simpson <simps05192@yahoo.com>
Subject: Conflict when loading initio driver
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <786233.43251.qm@web56808.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



 
  
  
  
  
  
  
  
   <!--
#toc,
.toc,
.mw-warning {
	border: 1px solid #aaa;
	background-color: #f9f9f9;
	padding: 5px;
	font-size: 95%;
}
#toc h2,
.toc h2 {
	display: inline;
	border: none;
	padding: 0;
	font-size: 100%;
	font-weight: bold;
}
#toc #toctitle,
.toc #toctitle,
#toc .toctitle,
.toc .toctitle {
	text-align: center;
}
#toc ul,
.toc ul {
	list-style-type: none;
	list-style-image: none;
	margin-left: 0;
	padding-left: 0;
	text-align: left;
}
#toc ul ul,
.toc ul ul {
	margin: 0 0 0 2em;
}
#toc .toctoggle,
.toc .toctoggle {
	font-size: 94%;
}@media print, projection, embossed {
	body {
		padding-top:1in;
		padding-bottom:1in;
		padding-left:1in;
		padding-right:1in;
	}
}
body {
	font-family:'Times New Roman';
	color:#000000;
	widows:2;
	font-style:normal;
	text-indent:0in;
	font-variant:normal;
	font-size:12pt;
	text-decoration:none;
	font-weight:normal;
	text-align:left;
}
table {
}
td {
	border-collapse:collapse;
	text-align:left;
	vertical-align:top;
}
p, h1, h2, h3, li {
	color:#000000;
	font-family:'Times New Roman';
	font-size:12pt;
	text-align:left;
	vertical-align:normal;
}
     -->
  
 
  
   SuSE 10.3 (new release candidate), 2.6.22.5-29 kernel, SCSI initio driver



   

   I have a scanner connected to a Initio INI-950 SCSI card and I recently upgraded from SuSE 10.2 to 10.3. The new kernel doesn't see any of my devices. I get the following in /var/log/messages:



   

   Sep 30 09:05:13 r2d2 kernel: ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 17 (level, low) -> IRQ 16

   Sep 30 09:05:13 r2d2 kernel: initio: I/O port range 0x0 is busy.

   Sep 30 09:05:13 r2d2 kernel: ACPI: PCI interrupt for device 0000:00:0a.0 disabled



   

   so there is some conflict of some kind. How would I go about reconciling this? Thanks.

   


  

 



       
____________________________________________________________________________________
Pinpoint customers who are looking for what you sell. 
http://searchmarketing.yahoo.com/
