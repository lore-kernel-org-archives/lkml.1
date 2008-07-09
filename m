Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYGIKtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYGIKtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYGIKth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:49:37 -0400
Received: from hull.simtec.co.uk ([78.105.113.97]:42485 "EHLO
	ivanova.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751365AbYGIKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:49:36 -0400
Message-Id: <20080709104932.706237040@fluff.org>
References: <20080709104916.200210922@fluff.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 11:49:18 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Cc: sameo@openedhand.com, dbaryshkov@gmail.com,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 2/4] MFD: Coding style fixes
Content-Disposition: inline; filename=mfd-fix-codingstyle.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style fixes in the mfd core driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
===================================================================
--- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c	2008-07-09 10:43:54.000000000 +0100
+++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c	2008-07-09 10:44:45.000000000 +0100
@@ -16,9 +16,9 @@
 #include <linux/mfd/core.h>
 
 static int mfd_add_device(struct platform_device *parent,
-		const struct mfd_cell *cell,
-		struct resource *mem_base,
-		int irq_base)
+			  const struct mfd_cell *cell,
+			  struct resource *mem_base,
+			  int irq_base)
 {
 	struct resource res[cell->num_resources];
 	struct platform_device *pdev;
@@ -75,11 +75,10 @@ fail_alloc:
 	return ret;
 }
 
-int mfd_add_devices(
-		struct platform_device *parent,
-		const struct mfd_cell *cells, int n_devs,
-		struct resource *mem_base,
-		int irq_base)
+int mfd_add_devices(struct platform_device *parent,
+		    const struct mfd_cell *cells, int n_devs,
+		    struct resource *mem_base,
+		    int irq_base)
 {
 	int i;
 	int ret = 0;
Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
===================================================================
--- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h	2008-07-09 10:43:54.000000000 +0100
+++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h	2008-07-09 10:44:45.000000000 +0100
@@ -1,5 +1,3 @@
-#ifndef MFD_CORE_H
-#define MFD_CORE_H
 /*
  * drivers/mfd/mfd-core.h
  *
@@ -13,6 +11,9 @@
  *
  */
 
+#ifndef MFD_CORE_H
+#define MFD_CORE_H
+
 #include <linux/platform_device.h>
 
 /*
@@ -38,17 +39,15 @@ struct mfd_cell {
 	const struct resource	*resources;
 };
 
-static inline struct mfd_cell *
-mfd_get_cell(struct platform_device *pdev)
+static inline struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
 {
 	return (struct mfd_cell *)pdev->dev.platform_data;
 }
 
-extern int mfd_add_devices(
-		struct platform_device *parent,
-		const struct mfd_cell *cells, int n_devs,
-		struct resource *mem_base,
-		int irq_base);
+extern int mfd_add_devices(struct platform_device *parent,
+			   const struct mfd_cell *cells, int n_devs,
+			   struct resource *mem_base,
+			   int irq_base);
 
 extern void mfd_remove_devices(struct platform_device *parent);
 

-- 
