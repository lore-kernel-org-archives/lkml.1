Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXDDS0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXDDS0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbXDDSMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:12:09 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38701 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060AbXDDSLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:11:53 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 59/90] ARM: OMAP: Mostly cosmetic to sync up with linux-omap tree
Date: Wed,  4 Apr 2007 14:05:38 -0400
Message-Id: <1175710128235-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101252580-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
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

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 0002de8..5a87aa9 100644
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
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index a0c6730..b603bc5 100644
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
diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index 3e84a03..2e0419f 100644
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

