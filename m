Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbYCZRJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbYCZRJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbYCZRI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:08:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:29091 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYCZRI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:26 -0400
Message-Id: <20080326171223.416343087@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:10:59 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 01/37] ISAPNP: move config register addresses out of isapnp.h
Content-Disposition: inline; filename=isapnp-remove-register-addrs-from-header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are used only in drivers/pnp/isapnp/core.c, so no need to
expose them to the world.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-21 11:52:12.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-21 11:53:24.000000000 -0600
@@ -88,6 +88,14 @@
 #define _LTAG_MEM32RANGE	0x85
 #define _LTAG_FIXEDMEM32RANGE	0x86
 
+/* Logical device control and configuration registers */
+
+#define ISAPNP_CFG_ACTIVATE	0x30	/* byte */
+#define ISAPNP_CFG_MEM		0x40	/* 4 * dword */
+#define ISAPNP_CFG_PORT		0x60	/* 8 * word */
+#define ISAPNP_CFG_IRQ		0x70	/* 2 * word */
+#define ISAPNP_CFG_DMA		0x74	/* 2 * byte */
+
 /*
  * Sizes of ISAPNP logical device configuration register sets.
  * See PNP-ISA-v1.0a.pdf, Appendix A.
Index: work7/include/linux/isapnp.h
===================================================================
--- work7.orig/include/linux/isapnp.h	2008-03-21 11:45:41.000000000 -0600
+++ work7/include/linux/isapnp.h	2008-03-21 11:52:39.000000000 -0600
@@ -26,16 +26,6 @@
 #include <linux/pnp.h>
 
 /*
- *  Configuration registers (TODO: change by specification)
- */ 
-
-#define ISAPNP_CFG_ACTIVATE		0x30	/* byte */
-#define ISAPNP_CFG_MEM			0x40	/* 4 * dword */
-#define ISAPNP_CFG_PORT			0x60	/* 8 * word */
-#define ISAPNP_CFG_IRQ			0x70	/* 2 * word */
-#define ISAPNP_CFG_DMA			0x74	/* 2 * byte */
-
-/*
  *
  */
 

-- 
