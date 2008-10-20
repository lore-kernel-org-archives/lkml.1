Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYJTX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYJTX0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYJTX0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:26:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23160 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYJTX0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:26:05 -0400
Message-ID: <48FD1374.9090504@oracle.com>
Date: Mon, 20 Oct 2008 16:25:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, x86@kernel.org
CC: Uwe Hermann <uwe@hermann-uwe.de>
Subject: [PATCH] doc/x86: update file locations and 00-INDEX
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

A few Doc/x86/ files were moved, so account for that.
Update Doc/x86/00-INDEX file.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Uwe Hermann <uwe@hermann-uwe.de>
---
 Documentation/kernel-parameters.txt |    4 ++--
 Documentation/lguest/lguest.c       |    2 +-
 Documentation/x86/00-INDEX          |    8 ++++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

--- linux.trees.git.orig/Documentation/kernel-parameters.txt
+++ linux.trees.git/Documentation/kernel-parameters.txt
@@ -111,7 +111,7 @@ In addition, the following text indicate
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
 Do not modify the syntax of boot loader parameters without extreme
-need or coordination with <Documentation/x86/i386/boot.txt>.
+need or coordination with <Documentation/x86/boot.txt>.
 
 There are also arch-specific kernel-parameters not documented here.
 See for example <Documentation/x86/x86_64/boot-options.txt>.
@@ -2306,7 +2306,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/fb/modedb.txt.
 
 	vga=		[BOOT,X86-32] Select a particular video mode
-			See Documentation/x86/i386/boot.txt and
+			See Documentation/x86/boot.txt and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
--- linux.trees.git.orig/Documentation/lguest/lguest.c
+++ linux.trees.git/Documentation/lguest/lguest.c
@@ -402,7 +402,7 @@ static unsigned long load_bzimage(int fd
 	void *p = from_guest_phys(0x100000);
 
 	/* Go back to the start of the file and read the header.  It should be
-	 * a Linux boot header (see Documentation/x86/i386/boot.txt) */
+	 * a Linux boot header (see Documentation/x86/boot.txt) */
 	lseek(fd, 0, SEEK_SET);
 	read(fd, &boot, sizeof(boot));
 
--- linux.trees.git.orig/Documentation/x86/00-INDEX
+++ linux.trees.git/Documentation/x86/00-INDEX
@@ -1,4 +1,12 @@
 00-INDEX
 	- this file
+boot.txt
+	- the Linux/x86 boot protocol
 mtrr.txt
 	- how to use x86 Memory Type Range Registers to increase performance
+pat.txt
+	- Linux/x86 Page Attribute Table APIs and debugging
+usb-legacy-support.txt
+	- Handling USB legacy support issues
+zero-page.txt
+	- struct boot_params info (in page 0)
