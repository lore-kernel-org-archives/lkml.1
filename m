Return-Path: <linux-kernel-owner+w=401wt.eu-S966146AbXDGR1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966146AbXDGR1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966187AbXDGR1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:27:20 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:35372 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966146AbXDGR1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:27:19 -0400
Date: Sat, 7 Apr 2007 13:27:09 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: aeb@cwi.nl
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] partitions: Enhance Kconfig help text for EESOX and MSDOS
 formats
Message-ID: <alpine.DEB.0.83.0704071322440.9798@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Adds help text for ACORN_PARTITION_EESOX and improves help text for 
MSDOS_PARTITION in fs/partitions/Kconfig.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

Applied against Linux v2.6.20.6.

--- linux-2.6.20.6-orig/fs/partitions/Kconfig	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/Kconfig	2007-04-07 13:22:17.000000000 -0400
@@ -32,6 +32,10 @@ config ACORN_PARTITION_EESOX
 	bool "EESOX partition support" if PARTITION_ADVANCED
 	default y if ARCH_ACORN
 	depends on ACORN_PARTITION
+	help
+	  EESOX SCSI card on-disk partition format support for Acorn
+	  systems. If you have one of these cards, or want to use a disk
+	  written by one, say Y.
 
 config ACORN_PARTITION_ICS
 	bool "ICS partition support" if PARTITION_ADVANCED
@@ -108,7 +112,11 @@ config MSDOS_PARTITION
 	bool "PC BIOS (MSDOS partition tables) support" if PARTITION_ADVANCED
 	default y
 	help
-	  Say Y here.
+	  Standard PC-compatible partition table support for Linux. Used by
+	  i386 systems, Linux/Windows dual-boot systems, and many others.
+	  Unless you are certain your system does not use this partition
+	  table format, and you're not using any disks from a system that
+	  does, say Y.
 
 config BSD_DISKLABEL
 	bool "BSD disklabel (FreeBSD partition tables) support"
