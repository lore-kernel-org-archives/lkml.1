Return-Path: <linux-kernel-owner+w=401wt.eu-S1761991AbZEOSA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991AbZEOSA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZEOR7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:59:47 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2039 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbZEOR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:59:46 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 01/11] arch/arm: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:35 -0700
Message-Id: <95639f9b68460c13a86c121cc5ae73e722f4dc67.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-omap1/id.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap1/id.c b/arch/arm/mach-omap1/id.c
index 4ef26fa..f72a221 100644
--- a/arch/arm/mach-omap1/id.c
+++ b/arch/arm/mach-omap1/id.c
@@ -130,20 +130,18 @@ void __init omap_check_revision(void)
 	die_rev = omap_get_die_rev();
 	omap_id = omap_readl(OMAP32_ID_0);
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "OMAP_DIE_ID_0: 0x%08x\n", omap_readl(OMAP_DIE_ID_0));
-	printk(KERN_DEBUG "OMAP_DIE_ID_1: 0x%08x DIE_REV: %i\n",
-		omap_readl(OMAP_DIE_ID_1),
-	       (omap_readl(OMAP_DIE_ID_1) >> 17) & 0xf);
-	printk(KERN_DEBUG "OMAP_PRODUCTION_ID_0: 0x%08x\n",
-		omap_readl(OMAP_PRODUCTION_ID_0));
-	printk(KERN_DEBUG "OMAP_PRODUCTION_ID_1: 0x%08x JTAG_ID: 0x%04x\n",
-		omap_readl(OMAP_PRODUCTION_ID_1),
-		omap_readl(OMAP_PRODUCTION_ID_1) & 0xffff);
-	printk(KERN_DEBUG "OMAP32_ID_0: 0x%08x\n", omap_readl(OMAP32_ID_0));
-	printk(KERN_DEBUG "OMAP32_ID_1: 0x%08x\n", omap_readl(OMAP32_ID_1));
-	printk(KERN_DEBUG "JTAG_ID: 0x%04x DIE_REV: %i\n", jtag_id, die_rev);
-#endif
+	pr_debug("OMAP_DIE_ID_0: 0x%08x\n", omap_readl(OMAP_DIE_ID_0));
+	pr_debug("OMAP_DIE_ID_1: 0x%08x DIE_REV: %i\n",
+		 omap_readl(OMAP_DIE_ID_1),
+		 (omap_readl(OMAP_DIE_ID_1) >> 17) & 0xf);
+	pr_debug("OMAP_PRODUCTION_ID_0: 0x%08x\n",
+		 omap_readl(OMAP_PRODUCTION_ID_0));
+	pr_debug("OMAP_PRODUCTION_ID_1: 0x%08x JTAG_ID: 0x%04x\n",
+		 omap_readl(OMAP_PRODUCTION_ID_1),
+		 omap_readl(OMAP_PRODUCTION_ID_1) & 0xffff);
+	pr_debug("OMAP32_ID_0: 0x%08x\n", omap_readl(OMAP32_ID_0));
+	pr_debug("OMAP32_ID_1: 0x%08x\n", omap_readl(OMAP32_ID_1));
+	pr_debug("JTAG_ID: 0x%04x DIE_REV: %i\n", jtag_id, die_rev);
 
 	system_serial_high = omap_readl(OMAP_DIE_ID_0);
 	system_serial_low = omap_readl(OMAP_DIE_ID_1);
-- 
1.6.3.1.9.g95405b.dirty

