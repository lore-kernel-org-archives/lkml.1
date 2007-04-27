Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbXD0I70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbXD0I70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbXD0I70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:59:26 -0400
Received: from mtwmail.mindtree.com.60.200.203.in-addr.arpa ([203.200.60.136]:14633
	"EHLO mailwo11.mindtree.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755494AbXD0I7Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:59:25 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 04:59:25 EDT
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2826
Content-class: urn:content-classes:message
Importance: normal
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: assembly code in the loadable kernel module
Date: Fri, 27 Apr 2007 14:15:48 +0530
Message-ID: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: assembly code in the loadable kernel module
Thread-Index: AceIqHPI01c+xOYFSsapxz5Q2xP5+A==
From: "Parav K Pandit" <Parav_Pandit@mindtree.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Apr 2007 08:45:49.0271 (UTC) FILETIME=[746FB670:01C788A8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have written one function in assembly for my kernel module.
Function is in module3.s file.
I have added the module3.o file in the object list in the Makefile.
But it shows compile time warning and following output.

What do I need to do to compile assembly code in my kernel module.

CC [M]  /home/parav/cache_improve/test_module/module1.o
CC [M]  /home/parav/cache_improve/test_module/module2.o
as -a32 -o /home/parav/cache_improve/test_module/module3.o
/home/parav/cache_improve/test_module/module3.s
LD [M]  /home/parav/cache_improve/test_module/sdk3_module.o
Building modules, stage 2.
MODPOST
Warning: could not find /home/parav/cache_improve/test_module/.module3.o.cmd
for /home/parav/cache_improve/test_module/module3.o
*** Warning: "test_func"
[/home/parav/cache_improve/test_module/sdk3_module.ko] undefined!
*** Warning: "" [/home/parav/cache_improve/test_module/sdk3_module.ko]
undefined!

I expect CC[M] kind of command for the module3.o file also so that
.module3.o.cmd file gets generated.

Regards,
Parav Pandit



DISCLAIMER:
This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. MindTree Consulting Limited (MindTree) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within MindTree or outside. If you have received this message by mistake please notify the sender by return  e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited.  Please note that e-mails are susceptible to change and MindTree shall not be liable for any improper, untimely or incomplete transmission.
