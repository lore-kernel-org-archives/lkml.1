Return-Path: <linux-kernel-owner+w=401wt.eu-S1030270AbXBTQuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270AbXBTQuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030277AbXBTQuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:50:14 -0500
Received: from [81.2.110.250] ([81.2.110.250]:45928 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030270AbXBTQuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:50:12 -0500
Date: Tue, 20 Feb 2007 17:54:01 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ide: remove a ton of pointless #undef REALLY_SLOW_IO
Message-ID: <20070220175401.4d45891e@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/cris/ide-cris.c linux-2.6.20-mm2/drivers/ide/cris/ide-cris.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/cris/ide-cris.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/cris/ide-cris.c	2007-02-20 13:59:16.000000000 +0000
@@ -17,8 +17,6 @@
  * device can't do DMA handshaking for some stupid reason. We don't need to do that.
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/timer.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/ide.c linux-2.6.20-mm2/drivers/ide/ide.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/ide.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/ide.c	2007-02-20 13:59:16.000000000 +0000
@@ -126,8 +126,6 @@
 #define	REVISION	"Revision: 7.00alpha2"
 #define	VERSION		"Id: ide.c 7.00a2 20020906"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #define _IDE_C			/* Tell ide.h it's really us */
 
 #include <linux/module.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/ide-disk.c linux-2.6.20-mm2/drivers/ide/ide-disk.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/ide-disk.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/ide-disk.c	2007-02-20 13:59:16.000000000 +0000
@@ -43,8 +43,6 @@
 
 #define IDEDISK_VERSION	"1.18"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 //#define DEBUG
 
 #include <linux/module.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/ide-probe.c linux-2.6.20-mm2/drivers/ide/ide-probe.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/ide-probe.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/ide-probe.c	2007-02-20 13:59:44.000000000 +0000
@@ -31,8 +31,6 @@
  *			valid after probe time even with noprobe
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/legacy/ali14xx.c linux-2.6.20-mm2/drivers/ide/legacy/ali14xx.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/legacy/ali14xx.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/legacy/ali14xx.c	2007-02-20 13:59:44.000000000 +0000
@@ -37,8 +37,6 @@
  * mode 4 for a while now with no trouble.)  -Derek
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/legacy/dtc2278.c linux-2.6.20-mm2/drivers/ide/legacy/dtc2278.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/legacy/dtc2278.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/legacy/dtc2278.c	2007-02-20 13:59:44.000000000 +0000
@@ -4,8 +4,6 @@
  *  Copyright (C) 1996  Linus Torvalds & author (see below)
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/legacy/ht6560b.c linux-2.6.20-mm2/drivers/ide/legacy/ht6560b.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/legacy/ht6560b.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/legacy/ht6560b.c	2007-02-20 13:59:44.000000000 +0000
@@ -36,8 +36,6 @@
 
 #define HT6560B_VERSION "v0.07"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/legacy/qd65xx.c linux-2.6.20-mm2/drivers/ide/legacy/qd65xx.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/legacy/qd65xx.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/legacy/qd65xx.c	2007-02-20 13:59:44.000000000 +0000
@@ -25,8 +25,6 @@
  * Samuel Thibault <samuel.thibault@fnac.net>
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/mips/au1xxx-ide.c linux-2.6.20-mm2/drivers/ide/mips/au1xxx-ide.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/mips/au1xxx-ide.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/mips/au1xxx-ide.c	2007-02-20 13:59:44.000000000 +0000
@@ -29,8 +29,6 @@
  * Note: for more information, please refer "AMD Alchemy Au1200/Au1550 IDE
  *       Interface and Linux Device Driver" Application Note.
  */
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/pci/cmd640.c linux-2.6.20-mm2/drivers/ide/pci/cmd640.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/pci/cmd640.c	2007-01-31 14:04:37.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/pci/cmd640.c	2007-02-20 13:59:44.000000000 +0000
@@ -98,7 +98,6 @@
  *			 (patch courtesy of Zoltan Hidvegi)
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
 #define CMD640_PREFETCH_MASKS 1
 
 //#define CMD640_DUMP_REGS
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/pci/generic.c linux-2.6.20-mm2/drivers/ide/pci/generic.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/pci/generic.c	2007-02-20 12:32:29.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/pci/generic.c	2007-02-20 13:59:44.000000000 +0000
@@ -21,8 +21,6 @@
  * are deemed to be part of the source code.
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/pci/opti621.c linux-2.6.20-mm2/drivers/ide/pci/opti621.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/pci/opti621.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/pci/opti621.c	2007-02-20 13:59:44.000000000 +0000
@@ -87,7 +87,6 @@
  * 0.5 doesn't work.
  */
 
-#undef REALLY_SLOW_IO	/* most systems can safely undef this */
 #define OPTI621_DEBUG		/* define for debug messages */
 
 #include <linux/types.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/pci/rz1000.c linux-2.6.20-mm2/drivers/ide/pci/rz1000.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/pci/rz1000.c	2007-02-20 12:32:29.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/pci/rz1000.c	2007-02-20 13:59:44.000000000 +0000
@@ -15,8 +15,6 @@
  *  Dunno if this fixes both ports, or only the primary port (?).
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>

