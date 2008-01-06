Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYAFOCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYAFOCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYAFOCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:02:00 -0500
Received: from lazybastard.de ([212.112.238.170]:55655 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYAFOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:02:00 -0500
Date: Sun, 6 Jan 2008 14:56:01 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Claim maintainership for block2mtd and update email addresses
Message-ID: <20080106135600.GB3120@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been prime author and maintainer of block2mtd from day one, but
neither MAINTAINERS nor the module source makes this fact clear.  And while
I'm at it, update my email addresses tree-wide, as the old address currently
bounces and change my name to "joern" as unicode will likely continue to
cause trouble until the end of this century.

Signed-off-by: Jörn Engel <joern@lazybastard.org>
---

 MAINTAINERS                     |   10 ++++++++--
 drivers/mtd/devices/block2mtd.c |    4 ++--
 drivers/mtd/devices/phram.c     |    4 ++--
 drivers/mtd/maps/mtx-1_flash.c  |    2 +-
 scripts/checkstack.pl           |    2 +-
 5 files changed, 14 insertions(+), 8 deletions(-)

--- linux-2.6.24-rc3logfs/drivers/mtd/devices/block2mtd.c~block2mtd_maintainer	2007-08-08 19:30:04.000000000 +0200
+++ linux-2.6.24-rc3logfs/drivers/mtd/devices/block2mtd.c	2008-01-06 14:22:57.000000000 +0100
@@ -4,7 +4,7 @@
  * block2mtd.c - create an mtd from a block device
  *
  * Copyright (C) 2001,2002	Simon Evans <spse@secret.org.uk>
- * Copyright (C) 2004-2006	JÃ¶rn Engel <joern@wh.fh-wedel.de>
+ * Copyright (C) 2004-2006	Joern Engel <joern@lazybastard.org>
  *
  * Licence: GPL
  */
@@ -485,5 +485,5 @@ module_init(block2mtd_init);
 module_exit(block2mtd_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Simon Evans <spse@secret.org.uk> and others");
+MODULE_AUTHOR("Joern Engel <joern@lazybastard.org>");
 MODULE_DESCRIPTION("Emulate an MTD using a block device");
--- linux-2.6.24-rc3logfs/MAINTAINERS~block2mtd_maintainer	2007-11-30 13:59:51.000000000 +0100
+++ linux-2.6.24-rc3logfs/MAINTAINERS	2008-01-06 14:21:49.000000000 +0100
@@ -835,6 +835,12 @@ L:	linux-kernel@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
 
+BLOCK2MTD DRIVER
+P:	Joern Engel
+M:	joern@lazybastard.org
+L:	linux-mtd@lists.infradead.org
+S:	Maintained
+
 BLUETOOTH SUBSYSTEM
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
@@ -2985,8 +2991,8 @@ L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
 
 PHRAM MTD DRIVER
-P:	JÃ¶rn Engel
-M:	joern@wh.fh-wedel.de
+P:	Joern Engel
+M:	joern@lazybastard.org
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
 
--- linux-2.6.24-rc3logfs/drivers/mtd/devices/phram.c~block2mtd_maintainer	2007-08-08 19:30:04.000000000 +0200
+++ linux-2.6.24-rc3logfs/drivers/mtd/devices/phram.c	2008-01-06 14:22:30.000000000 +0100
@@ -2,7 +2,7 @@
  * $Id: phram.c,v 1.16 2005/11/07 11:14:25 gleixner Exp $
  *
  * Copyright (c) ????		Jochen SchÃ¤uble <psionic@psionic.de>
- * Copyright (c) 2003-2004	JÃ¶rn Engel <joern@wh.fh-wedel.de>
+ * Copyright (c) 2003-2004	Joern Engel <joern@lazybastard.org>
  *
  * Usage:
  *
@@ -299,5 +299,5 @@ module_init(init_phram);
 module_exit(cleanup_phram);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("JÃ¶rn Engel <joern@wh.fh-wedel.de>");
+MODULE_AUTHOR("Joern Engel <joern@lazybastard.org>");
 MODULE_DESCRIPTION("MTD driver for physical RAM");
--- linux-2.6.24-rc3logfs/scripts/checkstack.pl~block2mtd_maintainer	2007-11-15 20:52:00.000000000 +0100
+++ linux-2.6.24-rc3logfs/scripts/checkstack.pl	2008-01-06 14:28:14.000000000 +0100
@@ -2,7 +2,7 @@
 
 #	Check the stack usage of functions
 #
-#	Copyright Joern Engel <joern@wh.fh-wedel.de>
+#	Copyright Joern Engel <joern@lazybastard.org>
 #	Inspired by Linus Torvalds
 #	Original idea maybe from Keith Owens
 #	s390 port and big speedup by Arnd Bergmann <arnd@bergmann-dalldorf.de>
--- linux-2.6.24-rc3logfs/drivers/mtd/maps/mtx-1_flash.c~block2mtd_maintainer	2007-08-08 19:30:04.000000000 +0200
+++ linux-2.6.24-rc3logfs/drivers/mtd/maps/mtx-1_flash.c	2008-01-06 14:28:44.000000000 +0100
@@ -4,7 +4,7 @@
  * $Id: mtx-1_flash.c,v 1.2 2005/11/07 11:14:27 gleixner Exp $
  *
  * (C) 2005 Bruno Randolf <bruno.randolf@4g-systems.biz>
- * (C) 2005 JÃ¶rn Engel <joern@wohnheim.fh-wedel.de>
+ * (C) 2005 Joern Engel <joern@lazybastard.org>
  *
  */
 
