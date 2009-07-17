Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbZGQAIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbZGQAIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933724AbZGQAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:05:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39128 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717AbZGQAF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 12/21] Blackfin: fix incomplete renaming of the bfin-twi-lcd driver
Date: Thu, 16 Jul 2009 20:05:37 -0400
Message-Id: <1247789146-18786-13-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The sed used to rename the bfin-twi-lcd only replaced the first instance
rather than all which led to the resources not being enabled when the
driver was built as a module.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c    |    2 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c |    2 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c    |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c    |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c    |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c    |    2 +-
 arch/blackfin/mach-bf548/boards/ezkit.c    |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index d979110..809be26 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -534,7 +534,7 @@ static struct platform_device i2c_bfin_twi_device = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index f4867ce..b09484f 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -793,7 +793,7 @@ static struct platform_device i2c_bfin_twi_device = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 		.type = "pcf8574_lcd",
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index b2f30f0..2ad68cd 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -591,7 +591,7 @@ static struct platform_device i2c_bfin_twi_device = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 799a1d1..75e563d 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -858,7 +858,7 @@ static struct platform_device i2c_bfin_twi_device = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index a68ade8..3d743cc 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -453,7 +453,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.irq = 39,
 	},
 #endif
-#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index c1f76dd..ab92e42 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1316,7 +1316,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.irq = IRQ_PF5,
 	},
 #endif
-#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 81f5b95..dc0dd9b 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -864,7 +864,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info0[] = {
 
 #if !defined(CONFIG_BF542)	/* The BF542 only has 1 TWI */
 static struct i2c_board_info __initdata bfin_i2c_board_info1[] = {
-#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
-- 
1.6.3.3

