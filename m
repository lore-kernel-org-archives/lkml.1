Return-Path: <linux-kernel-owner+w=401wt.eu-S934517AbYBNA3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbYBNA3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933826AbYBNAXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:23:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:1801 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764080AbYBNAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:23:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rxajsDz5axCGO8wA0yH0Tl0VhgfBaXOWgXhGXDi+aJvioM81yt6PUN9ERzi4/IOFG0jXDFlki0ey3DGdHVi3oRUYBo/R49YokVkELY9r08t233OBUSKsIpoo3g3mRZQdYrPJj5D2zXaIxn/uwPbUM+7W15uDgYX7134LWjKmigA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 01:37:36 +0100
Message-Id: <20080214003736.12879.81192.sendpatchset@localhost.localdomain>
In-Reply-To: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
References: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/11] ppc: don't include <linux/ide.h>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/ppc/platforms/4xx/bamboo.c     |    1 -
 arch/ppc/platforms/4xx/ebony.c      |    1 -
 arch/ppc/platforms/4xx/luan.c       |    1 -
 arch/ppc/platforms/4xx/ocotea.c     |    1 -
 arch/ppc/platforms/4xx/taishan.c    |    1 -
 arch/ppc/platforms/4xx/yucca.c      |    1 -
 arch/ppc/platforms/chestnut.c       |    1 -
 arch/ppc/platforms/cpci690.c        |    1 -
 arch/ppc/platforms/ev64260.c        |    1 -
 arch/ppc/platforms/mvme5100.c       |    1 -
 arch/ppc/platforms/powerpmc250.c    |    1 -
 arch/ppc/platforms/prpmc750.c       |    1 -
 arch/ppc/platforms/prpmc800.c       |    1 -
 arch/ppc/platforms/radstone_ppc7d.c |    1 -
 arch/ppc/platforms/residual.c       |    1 -
 arch/ppc/platforms/spruce.c         |    1 -
 16 files changed, 16 deletions(-)

Index: b/arch/ppc/platforms/4xx/bamboo.c
===================================================================
--- a/arch/ppc/platforms/4xx/bamboo.c
+++ b/arch/ppc/platforms/4xx/bamboo.c
@@ -22,7 +22,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
Index: b/arch/ppc/platforms/4xx/ebony.c
===================================================================
--- a/arch/ppc/platforms/4xx/ebony.c
+++ b/arch/ppc/platforms/4xx/ebony.c
@@ -25,7 +25,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
Index: b/arch/ppc/platforms/4xx/luan.c
===================================================================
--- a/arch/ppc/platforms/4xx/luan.c
+++ b/arch/ppc/platforms/4xx/luan.c
@@ -23,7 +23,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
Index: b/arch/ppc/platforms/4xx/ocotea.c
===================================================================
--- a/arch/ppc/platforms/4xx/ocotea.c
+++ b/arch/ppc/platforms/4xx/ocotea.c
@@ -23,7 +23,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
Index: b/arch/ppc/platforms/4xx/taishan.c
===================================================================
--- a/arch/ppc/platforms/4xx/taishan.c
+++ b/arch/ppc/platforms/4xx/taishan.c
@@ -23,7 +23,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
Index: b/arch/ppc/platforms/4xx/yucca.c
===================================================================
--- a/arch/ppc/platforms/4xx/yucca.c
+++ b/arch/ppc/platforms/4xx/yucca.c
@@ -24,7 +24,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
Index: b/arch/ppc/platforms/chestnut.c
===================================================================
--- a/arch/ppc/platforms/chestnut.c
+++ b/arch/ppc/platforms/chestnut.c
@@ -22,7 +22,6 @@
 #include <linux/initrd.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
Index: b/arch/ppc/platforms/cpci690.c
===================================================================
--- a/arch/ppc/platforms/cpci690.c
+++ b/arch/ppc/platforms/cpci690.c
@@ -10,7 +10,6 @@
  */
 #include <linux/delay.h>
 #include <linux/pci.h>
-#include <linux/ide.h>
 #include <linux/irq.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
Index: b/arch/ppc/platforms/ev64260.c
===================================================================
--- a/arch/ppc/platforms/ev64260.c
+++ b/arch/ppc/platforms/ev64260.c
@@ -23,7 +23,6 @@
 
 #include <linux/delay.h>
 #include <linux/pci.h>
-#include <linux/ide.h>
 #include <linux/irq.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
Index: b/arch/ppc/platforms/mvme5100.c
===================================================================
--- a/arch/ppc/platforms/mvme5100.c
+++ b/arch/ppc/platforms/mvme5100.c
@@ -17,7 +17,6 @@
 #include <linux/initrd.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/kdev_t.h>
 #include <linux/root_dev.h>
Index: b/arch/ppc/platforms/powerpmc250.c
===================================================================
--- a/arch/ppc/platforms/powerpmc250.c
+++ b/arch/ppc/platforms/powerpmc250.c
@@ -25,7 +25,6 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/root_dev.h>
 
 #include <asm/byteorder.h>
Index: b/arch/ppc/platforms/prpmc750.c
===================================================================
--- a/arch/ppc/platforms/prpmc750.c
+++ b/arch/ppc/platforms/prpmc750.c
@@ -22,7 +22,6 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/root_dev.h>
 #include <linux/slab.h>
 #include <linux/serial_reg.h>
Index: b/arch/ppc/platforms/prpmc800.c
===================================================================
--- a/arch/ppc/platforms/prpmc800.c
+++ b/arch/ppc/platforms/prpmc800.c
@@ -20,7 +20,6 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/root_dev.h>
 #include <linux/harrier_defs.h>
 
Index: b/arch/ppc/platforms/radstone_ppc7d.c
===================================================================
--- a/arch/ppc/platforms/radstone_ppc7d.c
+++ b/arch/ppc/platforms/radstone_ppc7d.c
@@ -29,7 +29,6 @@
 #include <linux/initrd.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
Index: b/arch/ppc/platforms/residual.c
===================================================================
--- a/arch/ppc/platforms/residual.c
+++ b/arch/ppc/platforms/residual.c
@@ -38,7 +38,6 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/ide.h>
 
 #include <asm/sections.h>
 #include <asm/mmu.h>
Index: b/arch/ppc/platforms/spruce.c
===================================================================
--- a/arch/ppc/platforms/spruce.c
+++ b/arch/ppc/platforms/spruce.c
@@ -22,7 +22,6 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
 #include <linux/tty.h>
