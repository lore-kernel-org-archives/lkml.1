Return-Path: <linux-kernel-owner+w=401wt.eu-S1763400AbXGZRF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763400AbXGZRF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764271AbXGZRFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:05:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:31373 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbXGZRFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:05:45 -0400
Date: Thu, 26 Jul 2007 10:10:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: hpa@zytor.com
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [patch] x86 boot code comments typos
Message-Id: <20070726101035.9300f2d8.randy.dunlap@oracle.com>
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

Fix comments typos in new x86 boot code.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/i386/boot/code16gcc.h  |    2 +-
 arch/i386/boot/header.S     |    2 +-
 arch/i386/boot/pm.c         |    2 +-
 arch/i386/boot/video-bios.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2623-rc1g2.orig/arch/i386/boot/pm.c
+++ linux-2623-rc1g2/arch/i386/boot/pm.c
@@ -80,7 +80,7 @@ static void move_kernel_around(void)
  */
 static void mask_all_interrupts(void)
 {
-	outb(0xff, 0xa1);	/* Mask all interrupts on the seconday PIC */
+	outb(0xff, 0xa1);	/* Mask all interrupts on the secondary PIC */
 	io_delay();
 	outb(0xfb, 0x21);	/* Mask all but cascade on the primary PIC */
 	io_delay();
--- linux-2623-rc1g2.orig/arch/i386/boot/video-bios.c
+++ linux-2623-rc1g2/arch/i386/boot/video-bios.c
@@ -44,7 +44,7 @@ static int set_bios_mode(u8 mode)
 		     : "+a" (ax)
 		     : : "ebx", "ecx", "edx", "esi", "edi");
 
-	do_restore = 1;		/* Assume video contents was lost */
+	do_restore = 1;		/* Assume video contents were lost */
 	new_mode = ax & 0x7f;	/* Not all BIOSes are clean with the top bit */
 
 	if (new_mode == mode)
--- linux-2623-rc1g2.orig/arch/i386/boot/code16gcc.h
+++ linux-2623-rc1g2/arch/i386/boot/code16gcc.h
@@ -2,7 +2,7 @@
  * code16gcc.h
  *
  * This file is -include'd when compiling 16-bit C code.
- * Note: this asm() needs to be emitted before gcc omits any code.
+ * Note: this asm() needs to be emitted before gcc emits any code.
  * Depending on gcc version, this requires -fno-unit-at-a-time or
  * -fno-toplevel-reorder.
  *
--- linux-2623-rc1g2.orig/arch/i386/boot/header.S
+++ linux-2623-rc1g2/arch/i386/boot/header.S
@@ -225,7 +225,7 @@ start_of_setup:
 	int	$0x13
 #endif
 
-# We will have entired with %cs = %ds+0x20, normalize %cs so
+# We will have entered with %cs = %ds+0x20, normalize %cs so
 # it is on par with the other segments.
 	pushw	%ds
 	pushw	$setup2
