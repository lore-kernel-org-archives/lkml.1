Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZFEIST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZFEIST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZFEIGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37536 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbZFEIFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 35/62] Blackfin: rename some Blackfin drivers
Date: Fri,  5 Jun 2009 04:04:44 -0400
Message-Id: <1244189111-19639-36-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to keep the naming conventions consistent, so:
	SPI_ADC_BF533 -> BFIN_SPI_ADC
	TWI_LCD       -> BFIN_TWI_LCD

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c     |   10 +++++-----
 arch/blackfin/mach-bf527/boards/cm_bf527.c  |   10 +++++-----
 arch/blackfin/mach-bf527/boards/ezbrd.c     |   10 +++++-----
 arch/blackfin/mach-bf527/boards/ezkit.c     |   10 +++++-----
 arch/blackfin/mach-bf533/boards/H8606.c     |    4 ++--
 arch/blackfin/mach-bf533/boards/cm_bf533.c  |    4 ++--
 arch/blackfin/mach-bf533/boards/ezkit.c     |    4 ++--
 arch/blackfin/mach-bf533/boards/stamp.c     |    6 +++---
 arch/blackfin/mach-bf537/boards/cm_bf537.c  |    4 ++--
 arch/blackfin/mach-bf537/boards/pnav10.c    |    8 ++++----
 arch/blackfin/mach-bf537/boards/stamp.c     |   10 +++++-----
 arch/blackfin/mach-bf537/boards/tcm_bf537.c |    4 ++--
 arch/blackfin/mach-bf548/boards/ezkit.c     |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c  |    4 ++--
 14 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index 602dce0..62bba09 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -166,8 +166,8 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -253,8 +253,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
@@ -518,7 +518,7 @@ static struct platform_device i2c_bfin_twi_device = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 48e69ee..6d6f9ef 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -463,8 +463,8 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -554,8 +554,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
@@ -789,7 +789,7 @@ static struct platform_device i2c_bfin_twi_device = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 		.type = "pcf8574_lcd",
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index 7fe480e..1435c5d 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -247,8 +247,8 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -354,8 +354,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
@@ -586,7 +586,7 @@ static struct platform_device i2c_bfin_twi_device = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 9ab8d8c..147edd1 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -485,8 +485,8 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -600,8 +600,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
@@ -854,7 +854,7 @@ static struct platform_device i2c_bfin_twi_device = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index 0c66bf4..895f213 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -173,7 +173,7 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.ctl_reg = 0x1000,
@@ -216,7 +216,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 4,     /* actual baudrate is SCLK/(2xspeed_hz) */
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index e897487..a727e53 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -82,7 +82,7 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 #endif
 
 /* SPI ADC chip */
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
@@ -117,7 +117,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 08cd096..842f1c9 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -118,7 +118,7 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -154,7 +154,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index db96f33..e19c565 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -192,7 +192,7 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -237,7 +237,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
@@ -448,7 +448,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.irq = 39,
 	},
 #endif
-#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 41c75b9..4fee196 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -86,7 +86,7 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -129,7 +129,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 4e1de1e..26707ce 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -265,8 +265,8 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -333,8 +333,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 9bd0a80..f56289a 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -508,8 +508,8 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -695,8 +695,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) \
+	|| defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
@@ -1280,7 +1280,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.irq = IRQ_PF5,
 	},
 #endif
-#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index 53ad10f..2805745 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -86,7 +86,7 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -129,7 +129,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 096e661..2780e41 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -786,7 +786,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info0[] = {
 
 #if !defined(CONFIG_BF542)	/* The BF542 only has 1 TWI */
 static struct i2c_board_info __initdata bfin_i2c_board_info1[] = {
-#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+#if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
 	},
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index f623c6b..0dd9685 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -83,7 +83,7 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
@@ -126,7 +126,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+#if defined(CONFIG_BFIN_SPI_ADC) || defined(CONFIG_BFIN_SPI_ADC_MODULE)
 	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
-- 
1.6.3.1

