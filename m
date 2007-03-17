Return-Path: <linux-kernel-owner+w=401wt.eu-S1751288AbXCQUm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbXCQUm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 16:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbXCQUm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 16:42:26 -0400
Received: from ns3.baby-dragons.com ([204.91.156.41]:50457 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXCQUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 16:42:25 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2007 16:42:25 EDT
Date: Sat, 17 Mar 2007 13:33:23 -0700 (PDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: MPT Fusion LSI22320 ,  Domain validation loops .
Message-ID: <Pine.LNX.4.64.0703171302440.18291@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (ns3.baby-dragons.com [204.91.156.41]); Sat, 17 Mar 2007 20:33:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hello All ,  I am have been having this problem since I purchased the 
controller and after changing out the disks I thought were the problem .
 	I am still getting the continous :

mptscsih: ioc1: attempting task abort! (sc=f7a64500)
scsi 3:0:4:0:
         command: Inquiry: 12 00 00 00 60 00
mptbase: Initiating ioc1 recovery
mptscsih: ioc1: task abort: SUCCESS (sc=f7a64500)
  target3:0:4: Domain Validation detected failure, dropping back
  target3:0:4: Domain Validation skipping write tests
  target3:0:4: Ending Domain Validation
  target3:0:4: asynchronous
  target3:0:5: Beginning Domain Validation
mptscsih: ioc0: attempting target reset! (sc=f7a64380)

 	The acutual device id's change and the driver continously resets the 
busses & starts all over .

 	The disks are in a HP DS-SL13R-BA 4354R 14drive ultra3 racKmount cabinet 
w/ dualbus & dualps ,  Which seems to present a ID6 ,  That does not show up in 
any of the bus scans .

 	Now I have previously had the same cabinet with 18gb disks which had the 
same problem with this controller .  BUT I also have a LSI Logic / Symbios 
Logic 53c1010 66MHz Ultra3 dual SCSI bus Adapter which works flawlessly with the 
18gb disks in this very same cabinet .
 	The cables for connecting the adapter(s) to tha cabinet are less than 24 
inches in length .

 	Would anyone please shed some light on what it is I am doing wrong or 
need to do or ....?  Too have this controller recognise these disk drives in 
this cabinet .

Here is the WHOLE enchalada .  Too big to put on the list so I posted them to my webpage .

http://www.baby-dragons.com/linux-2.6.20.2a.config
http://www.baby-dragons.com/filesrv1b-MPTFusion-problem.log

 		Tia ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
