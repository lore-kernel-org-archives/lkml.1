Return-Path: <linux-kernel-owner+w=401wt.eu-S1161182AbXDEFF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182AbXDEFF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 01:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161184AbXDEFF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 01:05:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:31822 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161182AbXDEFFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 01:05:54 -0400
Date: Wed, 4 Apr 2007 22:05:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] doc/kernel-parameters: use IA-32 tag instead of i386
Message-Id: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use documented tag for "IA-32" (not "i386") to indicate which
kernel parameters apply to IA-32.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2621-rc5g12.orig/Documentation/kernel-parameters.txt
+++ linux-2621-rc5g12/Documentation/kernel-parameters.txt
@@ -126,7 +126,7 @@ and is between 256 and 4096 characters. 
 			See header of drivers/scsi/53c7xx.c.
 			See also Documentation/scsi/ncr53c7xx.txt.
 
-	acpi=		[HW,ACPI,X86-64,i386]
+	acpi=		[HW,ACPI,X86-64,IA-32]
 			Advanced Configuration and Power Interface
 			Format: { force | off | ht | strict | noirq }
 			force -- enable ACPI if default was off
@@ -207,13 +207,13 @@ and is between 256 and 4096 characters. 
 			to assume that this machine's pmtimer latches its value
 			and always returns good values.
 
-	enable_timer_pin_1 [i386,x86-64]
+	enable_timer_pin_1 [IA-32,x86-64]
 			Enable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs
 			(in particular on some ATI chipsets).
 			The kernel tries to set a reasonable default.
 
-	disable_timer_pin_1 [i386,x86-64]
+	disable_timer_pin_1 [IA-32,x86-64]
 			Disable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs.
 
@@ -266,7 +266,7 @@ and is between 256 and 4096 characters. 
 			not play well with APC CPU idle - disable it if you have
 			APC and your system crashes randomly.
 
-	apic=		[APIC,i386] Change the output verbosity whilst booting
+	apic=		[APIC,IA-32] Change the output verbosity whilst booting
 			Format: { quiet (default) | verbose | debug }
 			Change the amount of debugging information output
 			when initialising the APIC and IO-APIC components.
