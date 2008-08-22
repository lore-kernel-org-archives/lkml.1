Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYHVTEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYHVTEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHVTEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:04:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36096 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYHVTEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:04:05 -0400
Message-ID: <48AF0D4E.2030007@oracle.com>
Date: Fri, 22 Aug 2008 12:02:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] documentation: add more early_param boot options
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add some (more) early_param boot options to kernel-parameters.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- lin2627-rc4.orig/Documentation/kernel-parameters.txt
+++ lin2627-rc4/Documentation/kernel-parameters.txt
@@ -129,6 +129,13 @@ and is between 256 and 4096 characters. 
 ./include/asm/setup.h as COMMAND_LINE_SIZE.
 
 
+	additional_cpus=  [IA-64,X86-32,X86-64]
+			Format: <int>
+			Specify the number of additional hotplug CPUs that
+			should be supported/allowed.  Can be used to
+			override BIOS info or to provide this info if not
+			already available.
+
 	acpi=		[HW,ACPI,X86-64,i386]
 			Advanced Configuration and Power Interface
 			Format: { force | off | ht | strict | noirq }
@@ -1077,6 +1084,8 @@ and is between 256 and 4096 characters. 
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
+	lmb=debug	[KNL] Enable lmb debug messages.
+
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
 			See Documentation/ramdisk.txt.
 
@@ -1474,6 +1483,9 @@ and is between 256 and 4096 characters. 
 
 	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
 
+	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
+			See Documentation/debugging-via-ohci1394.txt for more info.
+
 	olpc_ec_timeout= [OLPC] ms delay when issuing EC commands
 			Rather than timing out after 20 ms if an EC
 			command is not properly ACKed, override the length
