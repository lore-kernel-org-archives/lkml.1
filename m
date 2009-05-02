Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbZEBE1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbZEBE1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 00:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZEBE1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 00:27:09 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:35882 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZEBE1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 00:27:06 -0400
Message-ID: <49FBCBC1.3050006@oracle.com>
Date: Fri, 01 May 2009 21:27:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Jan Engelhardt <jengelh@medozas.de>,
       Christopher Sylvain <chris.sylvain@gmail.com>
Subject: [PATCH] doc: small kernel-parameters updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49FBCB68.0117:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Change last "i386" to X86-32 as is used throughout the rest of the file.
Change combination of X86-32,X86-64 to just X86, as is done throughout
the rest of the file.

Add a note that hyphens and underscores are equivalent in parameter names,
with examples.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Christopher Sylvain <chris.sylvain@gmail.com>
---
 Documentation/kernel-parameters.txt |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- lnx-2630-rc4.orig/Documentation/kernel-parameters.txt
+++ lnx-2630-rc4/Documentation/kernel-parameters.txt
@@ -17,6 +17,12 @@ are specified on the kernel command line
 
 	usbcore.blinkenlights=1
 
+Hyphens (dashes) and underscores are equivalent in parameter names, so
+	log_buf_len=1M print-fatal-signals=1
+can also be entered as
+	log-buf-len=1M print_fatal_signals=1
+
+
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
 module. Loadable modules, after being loaded into the running kernel, also
@@ -345,7 +351,7 @@ and is between 256 and 4096 characters. 
 			not play well with APC CPU idle - disable it if you have
 			APC and your system crashes randomly.
 
-	apic=		[APIC,i386] Advanced Programmable Interrupt Controller
+	apic=		[APIC,X86-32] Advanced Programmable Interrupt Controller
 			Change the output verbosity whilst booting
 			Format: { quiet (default) | verbose | debug }
 			Change the amount of debugging information output
@@ -702,7 +708,7 @@ and is between 256 and 4096 characters. 
 			to discrete, to make X server driver able to add WB
 			entry later. This parameter enables that.
 
-	enable_timer_pin_1 [i386,x86-64]
+	enable_timer_pin_1 [X86]
 			Enable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs
 			(in particular on some ATI chipsets).
