Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbZINUVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbZINUVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933521AbZINUVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:21:06 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54044 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933504AbZINUIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 23/72] Blackfin: rename PCF8574 driver config
Date: Mon, 14 Sep 2009 16:07:27 -0400
Message-Id: <1252958896-25150-24-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The "TWI_KEYPAD" driver was renamed to "INPUT_PCF8574", so update the
defines in the board resources accordingly.

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
index 809be26..4c594e6 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -539,7 +539,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
 #endif
-#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+#if defined(CONFIG_INPUT_PCF8574) || defined(CONFIG_INPUT_PCF8574_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
 		.irq = IRQ_PF8,
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index b09484f..3a62066 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -799,7 +799,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.type = "pcf8574_lcd",
 	},
 #endif
-#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+#if defined(CONFIG_INPUT_PCF8574) || defined(CONFIG_INPUT_PCF8574_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
 		.type = "pcf8574_keypad",
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index 2ad68cd..809c790 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -596,7 +596,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
 #endif
-#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+#if defined(CONFIG_INPUT_PCF8574) || defined(CONFIG_INPUT_PCF8574_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
 		.irq = IRQ_PF8,
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 75e563d..b843d0e 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -863,7 +863,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
 #endif
-#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+#if defined(CONFIG_INPUT_PCF8574) || defined(CONFIG_INPUT_PCF8574_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
 		.irq = IRQ_PF8,
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 3d743cc..42d4c9f 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -458,7 +458,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
 #endif
-#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+#if defined(CONFIG_INPUT_PCF8574) || defined(CONFIG_INPUT_PCF8574_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
 		.irq = 39,
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index b9da979..72d11de 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1348,7 +1348,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
 #endif
-#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+#if defined(CONFIG_INPUT_PCF8574) || defined(CONFIG_INPUT_PCF8574_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
 		.irq = IRQ_PG6,
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index dc0dd9b..aa82836 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -869,7 +869,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info1[] = {
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
 #endif
-#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+#if defined(CONFIG_INPUT_PCF8574) || defined(CONFIG_INPUT_PCF8574_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
 		.irq = 212,
-- 
1.6.4.2

