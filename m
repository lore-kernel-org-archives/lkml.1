Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZKILrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZKILrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbZKILrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:47:39 -0500
Received: from smtp.nokia.com ([192.100.122.233]:64580 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbZKILqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:46:33 -0500
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 18/19] OMAP: SDP: Enable DSS2 for OMAP3 SDP board
Date: Mon,  9 Nov 2009 13:45:25 +0200
Message-Id: <1257767126-12059-19-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1257767126-12059-18-git-send-email-tomi.valkeinen@nokia.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-2-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-3-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-4-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-5-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-6-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-7-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-8-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-9-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-10-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-11-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-12-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-13-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-14-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-15-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-16-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-17-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-18-git-send-email-tomi.valkeinen@nokia.com>
X-OriginalArrivalTime: 09 Nov 2009 11:46:19.0479 (UTC) FILETIME=[40AC8E70:01CA6132]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/configs/omap_3430sdp_defconfig |   32 +++++-
 arch/arm/mach-omap2/board-3430sdp.c     |  167 ++++++++++++++++++++++++++++---
 2 files changed, 179 insertions(+), 20 deletions(-)

diff --git a/arch/arm/configs/omap_3430sdp_defconfig b/arch/arm/configs/omap_3430sdp_defconfig
index 8a4a7e2..730ada3 100644
--- a/arch/arm/configs/omap_3430sdp_defconfig
+++ b/arch/arm/configs/omap_3430sdp_defconfig
@@ -1077,6 +1077,8 @@ CONFIG_TWL4030_CORE=y
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
 # CONFIG_MFD_PCF50633 is not set
+CONFIG_REGULATOR=y
+CONFIG_REGULATOR_TWL4030=y
 
 #
 # Multimedia devices
@@ -1336,10 +1338,33 @@ CONFIG_FB_CFB_IMAGEBLIT=y
 #
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
-CONFIG_FB_OMAP=y
-# CONFIG_FB_OMAP_LCDC_EXTERNAL is not set
+# CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
+# CONFIG_FB_BROADSHEET is not set
+# CONFIG_FB_OMAP_LCD_VGA is not set
 # CONFIG_FB_OMAP_BOOTLOADER_INIT is not set
-CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE=2
+CONFIG_OMAP2_VRAM=y
+CONFIG_OMAP2_VRFB=y
+CONFIG_OMAP2_DSS=y
+CONFIG_OMAP2_VRAM_SIZE=4
+CONFIG_OMAP2_DSS_DEBUG_SUPPORT=y
+# CONFIG_OMAP2_DSS_RFBI is not set
+CONFIG_OMAP2_DSS_VENC=y
+# CONFIG_OMAP2_DSS_SDI is not set
+# CONFIG_OMAP2_DSS_DSI is not set
+# CONFIG_OMAP2_DSS_FAKE_VSYNC is not set
+CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=0
+CONFIG_FB_OMAP2=y
+CONFIG_FB_OMAP2_DEBUG_SUPPORT=y
+# CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE is not set
+CONFIG_FB_OMAP2_NUM_FBS=3
+
+#
+# OMAP2/3 Display Device Drivers
+#
+CONFIG_PANEL_GENERIC=y
+# CONFIG_PANEL_SAMSUNG_LTE430WQ_F0C is not set
+CONFIG_PANEL_SHARP_LS037V7DW01=y
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -1703,7 +1728,6 @@ CONFIG_RTC_DRV_TWL4030=y
 # on-CPU RTC drivers
 #
 # CONFIG_DMADEVICES is not set
-# CONFIG_REGULATOR is not set
 # CONFIG_UIO is not set
 # CONFIG_STAGING is not set
 
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 7c1bbe2..da46036 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -37,6 +37,7 @@
 #include <plat/common.h>
 #include <plat/dma.h>
 #include <plat/gpmc.h>
+#include <plat/display.h>
 
 #include <plat/control.h>
 #include <plat/gpmc-smc91x.h>
@@ -152,31 +153,152 @@ static struct spi_board_info sdp3430_spi_board_info[] __initdata = {
 	},
 };
 
-static struct platform_device sdp3430_lcd_device = {
-	.name		= "sdp2430_lcd",
-	.id		= -1,
+
+#define SDP3430_LCD_PANEL_BACKLIGHT_GPIO	8
+#define SDP3430_LCD_PANEL_ENABLE_GPIO		5
+
+static unsigned backlight_gpio;
+static unsigned enable_gpio;
+static int lcd_enabled;
+static int dvi_enabled;
+
+static void __init sdp3430_display_init(void)
+{
+	int r;
+
+	enable_gpio    = SDP3430_LCD_PANEL_ENABLE_GPIO;
+	backlight_gpio = SDP3430_LCD_PANEL_BACKLIGHT_GPIO;
+
+	r = gpio_request(enable_gpio, "LCD reset");
+	if (r) {
+		printk(KERN_ERR "failed to get LCD reset GPIO\n");
+		goto err0;
+	}
+
+	r = gpio_request(backlight_gpio, "LCD Backlight");
+	if (r) {
+		printk(KERN_ERR "failed to get LCD backlight GPIO\n");
+		goto err1;
+	}
+
+	gpio_direction_output(enable_gpio, 0);
+	gpio_direction_output(backlight_gpio, 0);
+
+	return;
+err1:
+	gpio_free(enable_gpio);
+err0:
+	return;
+}
+
+static int sdp3430_panel_enable_lcd(struct omap_dss_device *dssdev)
+{
+	if (dvi_enabled) {
+		printk(KERN_ERR "cannot enable LCD, DVI is enabled\n");
+		return -EINVAL;
+	}
+
+	gpio_direction_output(enable_gpio, 1);
+	gpio_direction_output(backlight_gpio, 1);
+
+	lcd_enabled = 1;
+
+	return 0;
+}
+
+static void sdp3430_panel_disable_lcd(struct omap_dss_device *dssdev)
+{
+	lcd_enabled = 0;
+
+	gpio_direction_output(enable_gpio, 0);
+	gpio_direction_output(backlight_gpio, 0);
+}
+
+static int sdp3430_panel_enable_dvi(struct omap_dss_device *dssdev)
+{
+	if (lcd_enabled) {
+		printk(KERN_ERR "cannot enable DVI, LCD is enabled\n");
+		return -EINVAL;
+	}
+
+	dvi_enabled = 1;
+
+	return 0;
+}
+
+static void sdp3430_panel_disable_dvi(struct omap_dss_device *dssdev)
+{
+	dvi_enabled = 0;
+}
+
+static int sdp3430_panel_enable_tv(struct omap_dss_device *dssdev)
+{
+	return 0;
+}
+
+static void sdp3430_panel_disable_tv(struct omap_dss_device *dssdev)
+{
+}
+
+
+static struct omap_dss_device sdp3430_lcd_device = {
+	.name			= "lcd",
+	.driver_name		= "sharp_ls_panel",
+	.type			= OMAP_DISPLAY_TYPE_DPI,
+	.phy.dpi.data_lines	= 16,
+	.platform_enable	= sdp3430_panel_enable_lcd,
+	.platform_disable	= sdp3430_panel_disable_lcd,
 };
 
-static struct regulator_consumer_supply sdp3430_vdac_supply = {
-	.supply		= "vdac",
-	.dev		= &sdp3430_lcd_device.dev,
+static struct omap_dss_device sdp3430_dvi_device = {
+	.name			= "dvi",
+	.driver_name		= "generic_panel",
+	.type			= OMAP_DISPLAY_TYPE_DPI,
+	.phy.dpi.data_lines	= 24,
+	.platform_enable	= sdp3430_panel_enable_dvi,
+	.platform_disable	= sdp3430_panel_disable_dvi,
 };
 
-static struct regulator_consumer_supply sdp3430_vdvi_supply = {
-	.supply		= "vdvi",
-	.dev		= &sdp3430_lcd_device.dev,
+static struct omap_dss_device sdp3430_tv_device = {
+	.name			= "tv",
+	.driver_name		= "venc",
+	.type			= OMAP_DISPLAY_TYPE_VENC,
+	.phy.venc.type		= OMAP_DSS_VENC_TYPE_SVIDEO,
+	.platform_enable	= sdp3430_panel_enable_tv,
+	.platform_disable	= sdp3430_panel_disable_tv,
 };
 
-static struct platform_device *sdp3430_devices[] __initdata = {
+
+static struct omap_dss_device *sdp3430_dss_devices[] = {
 	&sdp3430_lcd_device,
+	&sdp3430_dvi_device,
+	&sdp3430_tv_device,
 };
 
-static struct omap_lcd_config sdp3430_lcd_config __initdata = {
-	.ctrl_name	= "internal",
+static struct omap_dss_board_info sdp3430_dss_data = {
+	.num_devices	= ARRAY_SIZE(sdp3430_dss_devices),
+	.devices	= sdp3430_dss_devices,
+	.default_device	= &sdp3430_lcd_device,
+};
+
+static struct platform_device sdp3430_dss_device = {
+	.name		= "omapdss",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &sdp3430_dss_data,
+	},
+};
+
+static struct regulator_consumer_supply sdp3430_vdda_dac_supply = {
+	.supply		= "vdda_dac",
+	.dev		= &sdp3430_dss_device.dev,
+};
+
+static struct platform_device *sdp3430_devices[] __initdata = {
+	&sdp3430_dss_device,
 };
 
 static struct omap_board_config_kernel sdp3430_config[] __initdata = {
-	{ OMAP_TAG_LCD,		&sdp3430_lcd_config },
 };
 
 static void __init omap_3430sdp_init_irq(void)
@@ -392,22 +514,34 @@ static struct regulator_init_data sdp3430_vdac = {
 					| REGULATOR_CHANGE_STATUS,
 	},
 	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &sdp3430_vdac_supply,
+	.consumer_supplies	= &sdp3430_vdda_dac_supply,
 };
 
 /* VPLL2 for digital video outputs */
+static struct regulator_consumer_supply sdp3430_vpll2_supplies[] = {
+	{
+		.supply		= "vdvi",
+		.dev		= &sdp3430_lcd_device.dev,
+	},
+	{
+		.supply		= "vdds_dsi",
+		.dev		= &sdp3430_dss_device.dev,
+	}
+};
+
 static struct regulator_init_data sdp3430_vpll2 = {
 	.constraints = {
 		.name			= "VDVI",
 		.min_uV			= 1800000,
 		.max_uV			= 1800000,
+		.apply_uV		= true,
 		.valid_modes_mask	= REGULATOR_MODE_NORMAL
 					| REGULATOR_MODE_STANDBY,
 		.valid_ops_mask		= REGULATOR_CHANGE_MODE
 					| REGULATOR_CHANGE_STATUS,
 	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &sdp3430_vdvi_supply,
+	.num_consumer_supplies	= ARRAY_SIZE(sdp3430_vpll2_supplies),
+	.consumer_supplies	= sdp3430_vpll2_supplies,
 };
 
 static struct twl4030_codec_audio_data sdp3430_audio = {
@@ -508,6 +642,7 @@ static void __init omap_3430sdp_init(void)
 	omap_serial_init();
 	usb_musb_init();
 	board_smc91x_init();
+	sdp3430_display_init();
 	enable_board_wakeup_source();
 }
 
-- 
1.6.5.1

