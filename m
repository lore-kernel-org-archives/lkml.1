Return-Path: <linux-kernel-owner+w=401wt.eu-S1765726AbXGZXkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765726AbXGZXkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbXGZXjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:39:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39675 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073AbXGZXjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:39:52 -0400
Date: Thu, 26 Jul 2007 16:44:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, tony.luck@intel.com,
       jejb <james.bottomley@steeleye.com>
Subject: [PATCH] various doc/kernel-parameters fixes
Message-Id: <20070726164429.f41358d7.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

- tell what APIC (by request), MTD, & PARIDE mean
- correct some source file names
- remove IA64 "llsc*=" (seems to have been removed from source tree)
- removel SCSI "53c7xx=" (driver already removed)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- linux-2623-rc1g2.orig/Documentation/kernel-parameters.txt
+++ linux-2623-rc1g2/Documentation/kernel-parameters.txt
@@ -57,14 +57,14 @@ parameter is applicable:
 	MDA	MDA console support is enabled.
 	MOUSE	Appropriate mouse support is enabled.
 	MSI	Message Signaled Interrupts (PCI).
-	MTD	MTD support is enabled.
+	MTD	MTD (Memory Technology Device) support is enabled.
 	NET	Appropriate network support is enabled.
 	NUMA	NUMA support is enabled.
 	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
-	PV_OPS	A paravirtualized kernel
-	PARIDE	The ParIDE subsystem is enabled.
+	PV_OPS	A paravirtualized kernel is enabled.
+	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
 	PCI	PCI bus support is enabled.
 	PCMCIA	The PCMCIA subsystem is enabled.
@@ -122,10 +122,6 @@ and is between 256 and 4096 characters. 
 ./include/asm/setup.h as COMMAND_LINE_SIZE.
 
 
-	53c7xx=		[HW,SCSI] Amiga SCSI controllers
-			See header of drivers/scsi/53c7xx.c.
-			See also Documentation/scsi/ncr53c7xx.txt.
-
 	acpi=		[HW,ACPI,X86-64,i386]
 			Advanced Configuration and Power Interface
 			Format: { force | off | ht | strict | noirq }
@@ -279,7 +275,8 @@ and is between 256 and 4096 characters. 
 			not play well with APC CPU idle - disable it if you have
 			APC and your system crashes randomly.
 
-	apic=		[APIC,i386] Change the output verbosity whilst booting
+	apic=		[APIC,i386] Advanced Programmable Interrupt Controller
+			Change the output verbosity whilst booting
 			Format: { quiet (default) | verbose | debug }
 			Change the amount of debugging information output
 			when initialising the APIC and IO-APIC components.
@@ -768,7 +765,8 @@ and is between 256 and 4096 characters. 
 			See Documentation/nfsroot.txt.
 
 	ip2=		[HW] Set IO/IRQ pairs for up to 4 IntelliPort boards
-			See comment before ip2_setup() in drivers/char/ip2.c.
+			See comment before ip2_setup() in
+			drivers/char/ip2/ip2base.c.
 
 	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
 			See header of drivers/scsi/ips.c.
@@ -864,9 +862,6 @@ and is between 256 and 4096 characters. 
 			if PNPBIOS or ACPI should describe them.  This
 			is for working around firmware defects.
 
-	llsc*=		[IA64] See function print_params() in
-			arch/ia64/sn/kernel/llsc4.c.
-
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
 			See Documentation/ramdisk.txt.
 
@@ -1039,7 +1034,7 @@ and is between 256 and 4096 characters. 
 			<name>,<region-number>[,<base>,<size>,<buswidth>,<altbuswidth>]
 
 	mtdparts=	[MTD]
-			See drivers/mtd/cmdline.c.
+			See drivers/mtd/cmdlinepart.c.
 
 	mtouchusb.raw_coordinates=
 			[HW] Make the MicroTouch USB driver use raw coordinates
