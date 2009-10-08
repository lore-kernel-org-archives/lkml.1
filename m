Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbZJHGFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbZJHGFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbZJHGFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34633 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbZJHGFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 12/13] Blackfin: drop all simple-gpio board resources
Date: Thu,  8 Oct 2009 02:04:28 -0400
Message-Id: <1254981869-21586-13-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simple-gpio has been replaced by the gpio sysfs interface, so drop the
unused simple-gpio resources from all Blackfin boards.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c      |   15 ---------------
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |   15 ---------------
 arch/blackfin/mach-bf527/boards/ezbrd.c      |   15 ---------------
 arch/blackfin/mach-bf527/boards/ezkit.c      |   15 ---------------
 arch/blackfin/mach-bf533/boards/blackstamp.c |   15 ---------------
 arch/blackfin/mach-bf533/boards/cm_bf533.c   |   15 ---------------
 arch/blackfin/mach-bf533/boards/ezkit.c      |   15 ---------------
 arch/blackfin/mach-bf533/boards/stamp.c      |   15 ---------------
 arch/blackfin/mach-bf537/boards/cm_bf537e.c  |   15 ---------------
 arch/blackfin/mach-bf537/boards/cm_bf537u.c  |   15 ---------------
 arch/blackfin/mach-bf537/boards/stamp.c      |   15 ---------------
 arch/blackfin/mach-bf537/boards/tcm_bf537.c  |   15 ---------------
 arch/blackfin/mach-bf538/boards/ezkit.c      |   15 ---------------
 arch/blackfin/mach-bf548/boards/cm_bf548.c   |   15 ---------------
 arch/blackfin/mach-bf548/boards/ezkit.c      |   15 ---------------
 arch/blackfin/mach-bf561/boards/cm_bf561.c   |   15 ---------------
 arch/blackfin/mach-bf561/boards/ezkit.c      |   15 ---------------
 17 files changed, 0 insertions(+), 255 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index 4c5c805..01975c0 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -549,19 +549,6 @@ static struct platform_device bf51x_sdh_device = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 static const unsigned int cclk_vlev_datasheet[] =
 {
 	VRPAIR(VLEV_100, 400000000),
@@ -638,8 +625,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&ezbrd_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init ezbrd_init(void)
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 1c4f9e2..f1996b1 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -799,19 +799,6 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 static const unsigned int cclk_vlev_datasheet[] =
 {
 	VRPAIR(VLEV_100, 400000000),
@@ -916,8 +903,6 @@ static struct platform_device *cmbf527_devices[] __initdata = {
 #if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
 	&cm_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init cm_init(void)
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index db06703..cad23b1 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -589,19 +589,6 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 static const unsigned int cclk_vlev_datasheet[] =
 {
 	VRPAIR(VLEV_100, 400000000),
@@ -710,8 +697,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&ezbrd_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init ezbrd_init(void)
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 9fbdebe..f09665f 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -882,19 +882,6 @@ static struct platform_device bfin_rotary_device = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 static const unsigned int cclk_vlev_datasheet[] =
 {
 	VRPAIR(VLEV_100, 400000000),
@@ -1011,8 +998,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&ezkit_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init ezkit_init(void)
diff --git a/arch/blackfin/mach-bf533/boards/blackstamp.c b/arch/blackfin/mach-bf533/boards/blackstamp.c
index fc78a38..b580884 100644
--- a/arch/blackfin/mach-bf533/boards/blackstamp.c
+++ b/arch/blackfin/mach-bf533/boards/blackstamp.c
@@ -275,19 +275,6 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 #include <linux/i2c-gpio.h>
 
@@ -378,8 +365,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 	&i2c_gpio_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init blackstamp_init(void)
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index a3c20e0..7fc3b86 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -241,19 +241,6 @@ static struct platform_device smsc911x_device = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 static struct resource bfin_uart_resources[] = {
 	{
@@ -486,8 +473,6 @@ static struct platform_device *cm_bf533_devices[] __initdata = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&para_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init cm_bf533_init(void)
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 986fcdc..d4689dc 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -389,19 +389,6 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 #include <linux/i2c-gpio.h>
 
@@ -500,8 +487,6 @@ static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 	&i2c_gpio_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init ezkit_init(void)
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index ff1fd93..82f70ef 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -408,19 +408,6 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 #include <linux/i2c-gpio.h>
 
@@ -536,8 +523,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&i2c_gpio_device,
 #endif
 
-	&bfin_gpios_device,
-
 #if defined(CONFIG_MTD_BFIN_ASYNC) || defined(CONFIG_MTD_BFIN_ASYNC_MODULE)
 	&stamp_flash_device,
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537e.c b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
index e930638..c85f4d7 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537e.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
@@ -276,19 +276,6 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
 static struct mtd_partition cm_partitions[] = {
 	{
@@ -678,8 +665,6 @@ static struct platform_device *cm_bf537e_devices[] __initdata = {
 #if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
 	&cm_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init cm_bf537e_init(void)
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537u.c b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
index fb6835b..ea11aa8 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537u.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
@@ -277,19 +277,6 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
 static struct mtd_partition cm_partitions[] = {
 	{
@@ -584,8 +571,6 @@ static struct platform_device *cm_bf537u_devices[] __initdata = {
 #if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
 	&cm_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init cm_bf537u_init(void)
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 3091a14..c46baa5 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -99,19 +99,6 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
 static struct resource bfin_pcmcia_cf_resources[] = {
 	{
@@ -1675,8 +1662,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&bfin_device_gpiokeys,
 #endif
 
-	&bfin_gpios_device,
-
 #if defined(CONFIG_MTD_NAND_PLATFORM) || defined(CONFIG_MTD_NAND_PLATFORM_MODULE)
 	&bfin_async_nand_device,
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index 72ff7f8..57163b6 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -277,19 +277,6 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
 static struct mtd_partition cm_partitions[] = {
 	{
@@ -586,8 +573,6 @@ static struct platform_device *cm_bf537_devices[] __initdata = {
 #if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
 	&cm_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init tcm_bf537_init(void)
diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index 8d612e7..14af5c2 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -483,19 +483,6 @@ static struct platform_device i2c_bfin_twi1_device = {
 #endif
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 #include <linux/gpio_keys.h>
 
@@ -635,8 +622,6 @@ static struct platform_device *cm_bf538_devices[] __initdata = {
 	&bfin_device_gpiokeys,
 #endif
 
-	&bfin_gpios_device,
-
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&ezkit_flash_device,
 #endif
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index 283be63..ccdcd6d 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -359,19 +359,6 @@ static struct platform_device musb_device = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_PATA_BF54X) || defined(CONFIG_PATA_BF54X_MODULE)
 static struct resource bfin_atapi_resources[] = {
 	{
@@ -830,8 +817,6 @@ static struct platform_device *cm_bf548_devices[] __initdata = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&para_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init cm_bf548_init(void)
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 8798831..1a5286b 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -882,19 +882,6 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 static const unsigned int cclk_vlev_datasheet[] =
 {
 /*
@@ -1002,8 +989,6 @@ static struct platform_device *ezkit_devices[] __initdata = {
 	&bfin_device_gpiokeys,
 #endif
 
-	&bfin_gpios_device,
-
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&ezkit_flash_device,
 #endif
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 3efeca7..dfc8d5b 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -265,19 +265,6 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 static struct resource isp1362_hcd_resources[] = {
 	{
@@ -512,8 +499,6 @@ static struct platform_device *cm_bf561_devices[] __initdata = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&para_flash_device,
 #endif
-
-	&bfin_gpios_device,
 };
 
 static int __init cm_bf561_init(void)
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index a8caa8a..9e2d8cf 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -366,19 +366,6 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif
 
-static struct resource bfin_gpios_resources = {
-	.start = 0,
-	.end   = MAX_BLACKFIN_GPIOS - 1,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct platform_device bfin_gpios_device = {
-	.name = "simple-gpio",
-	.id = -1,
-	.num_resources = 1,
-	.resource = &bfin_gpios_resources,
-};
-
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 #include <linux/i2c-gpio.h>
 
@@ -472,8 +459,6 @@ static struct platform_device *ezkit_devices[] __initdata = {
 	&isp1362_hcd_device,
 #endif
 
-	&bfin_gpios_device,
-
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&ezkit_flash_device,
 #endif
-- 
1.6.5.rc2

