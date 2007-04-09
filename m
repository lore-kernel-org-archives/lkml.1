Return-Path: <linux-kernel-owner+w=401wt.eu-S1030188AbXDIVXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030188AbXDIVXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965951AbXDIVXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:23:42 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:27006 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965933AbXDIVXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:33 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 12/18] ARM: OMAP: Mostly cosmetic to sync up with linux-omap tree
Date: Mon,  9 Apr 2007 17:22:17 -0400
Message-Id: <117615378995-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761537863183-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com> <11761537743905-git-send-email-tony@atomide.com> <1176153781321-git-send-email-tony@atomide.com> <1176153783637-git-send-email-tony@atomide.com> <11761537863183-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tmlind@baageli.(none)>

Mostly cosmetic to sync up with linux-omap tree

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/Kconfig   |    2 +-
 arch/arm/mach-omap2/devices.c |    6 +++---
 arch/arm/plat-omap/devices.c  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -46,7 +46,7 @@ config MACH_OMAP_H3
 config MACH_OMAP_OSK
 	bool "TI OSK Support"
 	depends on ARCH_OMAP1 && ARCH_OMAP16XX
-	select TPS65010
+	select OMAP_MCBSP
     	help
 	  TI OMAP 5912 OSK (OMAP Starter Kit) board support. Say Y here
           if you have such a board.
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -24,7 +24,7 @@
 #include <asm/arch/mux.h>
 #include <asm/arch/gpio.h>
 
-#if 	defined(CONFIG_I2C_OMAP) || defined(CONFIG_I2C_OMAP_MODULE)
+#if	defined(CONFIG_I2C_OMAP) || defined(CONFIG_I2C_OMAP_MODULE)
 
 #define OMAP2_I2C_BASE2		0x48072000
 #define OMAP2_I2C_INT2		57
@@ -42,8 +42,8 @@ static struct resource i2c_resources2[] = {
 };
 
 static struct platform_device omap_i2c_device2 = {
-        .name           = "i2c_omap",
-        .id             = 2,
+	.name           = "i2c_omap",
+	.id             = 2,
 	.num_resources	= ARRAY_SIZE(i2c_resources2),
 	.resource	= i2c_resources2,
 };
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -112,8 +112,8 @@ static struct resource i2c_resources1[] = {
 /* DMA not used; works around erratum writing to non-empty i2c fifo */
 
 static struct platform_device omap_i2c_device1 = {
-        .name           = "i2c_omap",
-        .id             = 1,
+	.name           = "i2c_omap",
+	.id             = 1,
 	.num_resources	= ARRAY_SIZE(i2c_resources1),
 	.resource	= i2c_resources1,
 };
-- 
1.4.4.2

