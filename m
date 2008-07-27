Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYG0SMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYG0SMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbYG0SM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:12:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:1258 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYG0SM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:12:26 -0400
Message-ID: <488CBA8B.8070307@nixpanic.net>
Date: Sun, 27 Jul 2008 20:12:27 +0200
From: Niels de Vos <niels@nixpanic.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove newline from the description of module parameters
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some module parameters with only one line have the '\n' at the end of
the description. This is not needed nor wanted as after the
description the type (i.e. int) is followed by a newline.

Some modules contain a multi-line description, these are not affected
by this patch.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
---
 drivers/acpi/asus_acpi.c                    |    4 ++--
 drivers/block/aoe/aoenet.c                  |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba7220.c |    2 +-
 drivers/media/video/cs5345.c                |    2 +-
 drivers/media/video/cs53l32a.c              |    2 +-
 drivers/media/video/mt9v022.c               |    2 +-
 drivers/net/netconsole.c                    |    2 +-
 drivers/net/tokenring/3c359.c               |    8 ++++----
 drivers/net/wireless/ipw2200.c              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/video/matrox/matroxfb_base.c        |    2 +-
 12 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index 44ad90c..d3d0886 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -78,9 +78,9 @@ MODULE_LICENSE("GPL");
 static uid_t asus_uid;
 static gid_t asus_gid;
 module_param(asus_uid, uint, 0);
-MODULE_PARM_DESC(asus_uid, "UID for entries in /proc/acpi/asus.\n");
+MODULE_PARM_DESC(asus_uid, "UID for entries in /proc/acpi/asus");
 module_param(asus_gid, uint, 0);
-MODULE_PARM_DESC(asus_gid, "GID for entries in /proc/acpi/asus.\n");
+MODULE_PARM_DESC(asus_gid, "GID for entries in /proc/acpi/asus");
 
 /* For each model, all features implemented, 
  * those marked with R are relative to HOTK, A for absolute */
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index d625169..0c81ca7 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -30,7 +30,7 @@ enum {
 
 static char aoe_iflist[IFLISTSZ];
 module_param_string(aoe_iflist, aoe_iflist, IFLISTSZ, 0600);
-MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"\n");
+MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"");
 
 #ifndef MODULE
 static int __init aoe_iflist_setup(char *str)
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 349ac3d..637bd7f 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -38,7 +38,7 @@
 
 int radeon_no_wb;
 
-MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers\n");
+MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
 module_param_named(no_wb, radeon_no_wb, int, 0444);
 
 static int dri_library_name(struct drm_device *dev, char *buf)
diff --git a/drivers/infiniband/hw/ipath/ipath_iba7220.c b/drivers/infiniband/hw/ipath/ipath_iba7220.c
index fb70712..fadbfbf 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -528,7 +528,7 @@ static const struct ipath_cregs ipath_7220_cregs = {
 
 static char int_type[16] = "auto";
 module_param_string(interrupt_type, int_type, sizeof(int_type), 0444);
-MODULE_PARM_DESC(int_type, " interrupt_type=auto|force_msi|force_intx\n");
+MODULE_PARM_DESC(int_type, " interrupt_type=auto|force_msi|force_intx");
 
 /* packet rate matching delay; chip has support */
 static u8 rate_to_delay[2][2] = {
diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
index 1c3fa3a..2fb2c0e 100644
--- a/drivers/media/video/cs5345.c
+++ b/drivers/media/video/cs5345.c
@@ -35,7 +35,7 @@ static int debug;
 
 module_param(debug, bool, 0644);
 
-MODULE_PARM_DESC(debug, "Debugging messages\n\t\t\t0=Off (default), 1=On");
+MODULE_PARM_DESC(debug, "Debugging messages, 0=Off (default), 1=On");
 
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
index 645b339..d9f920e 100644
--- a/drivers/media/video/cs53l32a.c
+++ b/drivers/media/video/cs53l32a.c
@@ -39,7 +39,7 @@ static int debug;
 
 module_param(debug, bool, 0644);
 
-MODULE_PARM_DESC(debug, "Debugging messages\n\t\t\t0=Off (default), 1=On");
+MODULE_PARM_DESC(debug, "Debugging messages, 0=Off (default), 1=On");
 
 static unsigned short normal_i2c[] = { 0x22 >> 1, I2C_CLIENT_END };
 
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index b31ba4e..56808cd 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -25,7 +25,7 @@
 
 static char *sensor_type;
 module_param(sensor_type, charp, S_IRUGO);
-MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"\n");
+MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 
 /* mt9v022 selected register addresses */
 #define MT9V022_CHIP_VERSION		0x00
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index e13966b..9681618 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -53,7 +53,7 @@ MODULE_LICENSE("GPL");
 
 static char config[MAX_PARAM_LENGTH];
 module_param_string(netconsole, config, MAX_PARAM_LENGTH, 0);
-MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr]\n");
+MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr]");
 
 #ifndef	MODULE
 static int __init option_setup(char *opt)
diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index 7766cde..bf62132 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -95,20 +95,20 @@ MODULE_DESCRIPTION("3Com 3C359 Velocity XL Token Ring Adapter Driver \n") ;
 static int ringspeed[XL_MAX_ADAPTERS] = {0,} ;
 
 module_param_array(ringspeed, int, NULL, 0);
-MODULE_PARM_DESC(ringspeed,"3c359: Ringspeed selection - 4,16 or 0") ; 
+MODULE_PARM_DESC(ringspeed,"3c359: Ringspeed selection - 4,16 or 0") ;
 
 /* Packet buffer size */
 
 static int pkt_buf_sz[XL_MAX_ADAPTERS] = {0,} ;
  
 module_param_array(pkt_buf_sz, int, NULL, 0) ;
-MODULE_PARM_DESC(pkt_buf_sz,"3c359: Initial buffer size") ; 
+MODULE_PARM_DESC(pkt_buf_sz,"3c359: Initial buffer size") ;
 /* Message Level */
 
-static int message_level[XL_MAX_ADAPTERS] = {0,} ; 
+static int message_level[XL_MAX_ADAPTERS] = {0,} ;
 
 module_param_array(message_level, int, NULL, 0) ;
-MODULE_PARM_DESC(message_level, "3c359: Level of reported messages \n") ; 
+MODULE_PARM_DESC(message_level, "3c359: Level of reported messages") ;
 /* 
  *	This is a real nasty way of doing this, but otherwise you
  *	will be stuck with 1555 lines of hex #'s in the code.
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 1acfbcd..846a7d0 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -11946,7 +11946,7 @@ module_param(auto_create, int, 0444);
 MODULE_PARM_DESC(auto_create, "auto create adhoc network (default on)");
 
 module_param(led, int, 0444);
-MODULE_PARM_DESC(led, "enable led control on some systems (default 0 off)\n");
+MODULE_PARM_DESC(led, "enable led control on some systems (default 0 off)");
 
 module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9afecb8..ba2df1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2469,7 +2469,7 @@ MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
 module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
 module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, 0444);
-MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])\n");
+MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(debug, iwl4965_mod_params.debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index 54e82f3..c021362 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -2536,7 +2536,7 @@ module_param(fh, int, 0);
 MODULE_PARM_DESC(fh, "Startup horizontal frequency, 0-999kHz, 1000-INF Hz");
 module_param(fv, int, 0);
 MODULE_PARM_DESC(fv, "Startup vertical frequency, 0-INF Hz\n"
-"You should specify \"fv:max_monitor_vsync,fh:max_monitor_hsync,maxclk:max_monitor_dotclock\"\n");
+"You should specify \"fv:max_monitor_vsync,fh:max_monitor_hsync,maxclk:max_monitor_dotclock\"");
 module_param(grayscale, int, 0);
 MODULE_PARM_DESC(grayscale, "Sets display into grayscale. Works perfectly with paletized videomode (4, 8bpp), some limitations apply to 16, 24 and 32bpp videomodes (default=nograyscale)");
 module_param(cross4MB, int, 0);
-- 
1.5.5.1

