Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbZIGCX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbZIGCX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbZIGCX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:23:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:47621 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758421AbZIGCX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:23:26 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+oUb9elWWoMWQP4k3CtvSBUzPDUpBd7jsUFjWf2e
	0e3S3N5kd24SGn
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Harald Welte <laforge@gnumonks.org>,
       Harald Welte <HaraldWelte@viatech.com>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/3] viafb: make module parameters visible in sysfs
Date: Mon,  7 Sep 2009 02:24:42 +0000
Message-Id: <1252290284-3668-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@gnumonks.org>

viafb: make module parameters visible in sysfs

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |   43 +++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 34e49b8..a5bbcab 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/stat.h>
 #define _MASTER_FILE
 
 #include "global.h"
@@ -2150,79 +2151,79 @@ module_init(viafb_init);
 module_exit(viafb_exit);
 
 #ifdef MODULE
-module_param(viafb_memsize, int, 0);
+module_param(viafb_memsize, int, S_IRUSR);
 
-module_param(viafb_mode, charp, 0);
+module_param(viafb_mode, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_mode, "Set resolution (default=640x480)");
 
-module_param(viafb_mode1, charp, 0);
+module_param(viafb_mode1, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_mode1, "Set resolution (default=640x480)");
 
-module_param(viafb_bpp, int, 0);
+module_param(viafb_bpp, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_bpp, "Set color depth (default=32bpp)");
 
-module_param(viafb_bpp1, int, 0);
+module_param(viafb_bpp1, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_bpp1, "Set color depth (default=32bpp)");
 
-module_param(viafb_refresh, int, 0);
+module_param(viafb_refresh, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_refresh,
 	"Set CRT viafb_refresh rate (default = 60)");
 
-module_param(viafb_refresh1, int, 0);
+module_param(viafb_refresh1, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_refresh1,
 	"Set CRT refresh rate (default = 60)");
 
-module_param(viafb_lcd_panel_id, int, 0);
+module_param(viafb_lcd_panel_id, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_lcd_panel_id,
 	"Set Flat Panel type(Default=1024x768)");
 
-module_param(viafb_lcd_dsp_method, int, 0);
+module_param(viafb_lcd_dsp_method, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_lcd_dsp_method,
 	"Set Flat Panel display scaling method.(Default=Expandsion)");
 
-module_param(viafb_SAMM_ON, int, 0);
+module_param(viafb_SAMM_ON, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_SAMM_ON,
 	"Turn on/off flag of SAMM(Default=OFF)");
 
-module_param(viafb_accel, int, 0);
+module_param(viafb_accel, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_accel,
 	"Set 2D Hardware Acceleration: 0 = OFF, 1 = ON (default)");
 
-module_param(viafb_active_dev, charp, 0);
+module_param(viafb_active_dev, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_active_dev, "Specify active devices.");
 
-module_param(viafb_display_hardware_layout, int, 0);
+module_param(viafb_display_hardware_layout, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_display_hardware_layout,
 	"Display Hardware Layout (LCD Only, DVI Only...,etc)");
 
-module_param(viafb_second_size, int, 0);
+module_param(viafb_second_size, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_second_size,
 	"Set secondary device memory size");
 
-module_param(viafb_dual_fb, int, 0);
+module_param(viafb_dual_fb, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_dual_fb,
 	"Turn on/off flag of dual framebuffer devices.(Default = OFF)");
 
-module_param(viafb_platform_epia_dvi, int, 0);
+module_param(viafb_platform_epia_dvi, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_platform_epia_dvi,
 	"Turn on/off flag of DVI devices on EPIA board.(Default = OFF)");
 
-module_param(viafb_device_lcd_dualedge, int, 0);
+module_param(viafb_device_lcd_dualedge, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_device_lcd_dualedge,
 	"Turn on/off flag of dual edge panel.(Default = OFF)");
 
-module_param(viafb_bus_width, int, 0);
+module_param(viafb_bus_width, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_bus_width,
 	"Set bus width of panel.(Default = 12)");
 
-module_param(viafb_lcd_mode, int, 0);
+module_param(viafb_lcd_mode, int, S_IRUSR);
 MODULE_PARM_DESC(viafb_lcd_mode,
 	"Set Flat Panel mode(Default=OPENLDI)");
 
-module_param(viafb_lcd_port, charp, 0);
+module_param(viafb_lcd_port, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_lcd_port, "Specify LCD output port.");
 
-module_param(viafb_dvi_port, charp, 0);
+module_param(viafb_dvi_port, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_dvi_port, "Specify DVI output port.");
 
 MODULE_LICENSE("GPL");
-- 
1.6.3.2

