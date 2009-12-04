Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZLDWIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZLDWIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZLDWIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:08:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZLDWIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:08:48 -0500
Message-ID: <4B1988AC.8080800@gmail.com>
Date: Fri, 04 Dec 2009 23:09:48 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: rui.zhang@intel.com, corentincj@iksaif.net, sziwan@users.sourceforge.net,
       cezary.jackiewicz@gmail.com, mjg59@srcf.ucam.org,
       jwoithe@physics.adelaide.edu.au, mzxreary@0pointer.de,
       laforge@gnumonks.org, malattia@linux.it, ibm-acpi@hmh.eng.br,
       carlos@strangeworlds.co.uk, gregkh@suse.de,
       broonie@opensource.wolfsonmicro.com, nicolas.ferre@atmel.com,
       rpurdie@rpsys.net, adaplas@gmail.com, benh@kernel.crashing.org,
       paulus@samba.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 03/31] Constify struct backlight_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct backlight_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/acpi/video.c                    |    2 +-
 drivers/macintosh/via-pmu-backlight.c   |    4 ++--
 drivers/platform/x86/acer-wmi.c         |    2 +-
 drivers/platform/x86/asus-laptop.c      |    2 +-
 drivers/platform/x86/asus_acpi.c        |    2 +-
 drivers/platform/x86/compal-laptop.c    |    2 +-
 drivers/platform/x86/dell-laptop.c      |    2 +-
 drivers/platform/x86/eeepc-laptop.c     |    2 +-
 drivers/platform/x86/fujitsu-laptop.c   |    2 +-
 drivers/platform/x86/msi-laptop.c       |    2 +-
 drivers/platform/x86/panasonic-laptop.c |    2 +-
 drivers/platform/x86/sony-laptop.c      |    2 +-
 drivers/platform/x86/thinkpad_acpi.c    |    2 +-
 drivers/platform/x86/toshiba_acpi.c     |    2 +-
 drivers/usb/misc/appledisplay.c         |    2 +-
 drivers/video/atmel_lcdfb.c             |    2 +-
 drivers/video/aty/aty128fb.c            |    2 +-
 drivers/video/aty/atyfb_base.c          |    2 +-
 drivers/video/aty/radeon_backlight.c    |    2 +-
 drivers/video/backlight/adp5520_bl.c    |    2 +-
 drivers/video/backlight/adx_bl.c        |    2 +-
 drivers/video/backlight/atmel-pwm-bl.c  |    2 +-
 drivers/video/backlight/backlight.c     |    2 +-
 drivers/video/backlight/corgi_lcd.c     |    2 +-
 drivers/video/backlight/cr_bllcd.c      |    2 +-
 drivers/video/backlight/da903x_bl.c     |    2 +-
 drivers/video/backlight/generic_bl.c    |    2 +-
 drivers/video/backlight/hp680_bl.c      |    2 +-
 drivers/video/backlight/jornada720_bl.c |    2 +-
 drivers/video/backlight/kb3886_bl.c     |    2 +-
 drivers/video/backlight/locomolcd.c     |    2 +-
 drivers/video/backlight/mbp_nvidia_bl.c |    2 +-
 drivers/video/backlight/omap1_bl.c      |    2 +-
 drivers/video/backlight/progear_bl.c    |    2 +-
 drivers/video/backlight/pwm_bl.c        |    2 +-
 drivers/video/backlight/tosa_bl.c       |    2 +-
 drivers/video/backlight/wm831x_bl.c     |    2 +-
 drivers/video/bf54x-lq043fb.c           |    2 +-
 drivers/video/bfin-t350mcqb-fb.c        |    2 +-
 drivers/video/nvidia/nv_backlight.c     |    2 +-
 drivers/video/riva/fbdev.c              |    2 +-
 include/linux/backlight.h               |   12 ++++++------
 42 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 05dff63..b662ab7 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -359,7 +359,7 @@ static int acpi_video_set_brightness(struct backlight_device *bd)
 				vd->brightness->levels[request_level]);
 }
 
-static struct backlight_ops acpi_backlight_ops = {
+static const struct backlight_ops acpi_backlight_ops = {
 	.get_brightness = acpi_video_get_brightness,
 	.update_status  = acpi_video_set_brightness,
 };
diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index a348bb0..ecd9b3f 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -15,7 +15,7 @@
 
 #define MAX_PMU_LEVEL 0xFF
 
-static struct backlight_ops pmu_backlight_data;
+static const struct backlight_ops pmu_backlight_data;
 static DEFINE_SPINLOCK(pmu_backlight_lock);
 static int sleeping, uses_pmu_bl;
 static u8 bl_curve[FB_BACKLIGHT_LEVELS];
@@ -115,7 +115,7 @@ static int pmu_backlight_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops pmu_backlight_data = {
+static const struct backlight_ops pmu_backlight_data = {
 	.get_brightness	= pmu_backlight_get_brightness,
 	.update_status	= pmu_backlight_update_status,
 
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 454970d..98f0e9a 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -918,7 +918,7 @@ static int update_bl_status(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops acer_bl_ops = {
+static const struct backlight_ops acer_bl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index b39d2bb..c9a3dc4 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -249,7 +249,7 @@ static struct backlight_device *asus_backlight_device;
  */
 static int read_brightness(struct backlight_device *bd);
 static int update_bl_status(struct backlight_device *bd);
-static struct backlight_ops asusbl_ops = {
+static const struct backlight_ops asusbl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index ddf5240..61e6673 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1402,7 +1402,7 @@ static int asus_hotk_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
-static struct backlight_ops asus_backlight_data = {
+static const struct backlight_ops asus_backlight_data = {
 	.get_brightness = read_brightness,
 	.update_status  = set_brightness_status,
 };
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 11003bb..550ff1b 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -163,7 +163,7 @@ static int bl_update_status(struct backlight_device *b)
 	return set_lcd_level(b->props.brightness);
 }
 
-static struct backlight_ops compalbl_ops = {
+static const struct backlight_ops compalbl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status	= bl_update_status,
 };
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 74909c4..e1ac2ba 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -305,7 +305,7 @@ static int dell_get_intensity(struct backlight_device *bd)
 	return buffer.output[1];
 }
 
-static struct backlight_ops dell_ops = {
+static const struct backlight_ops dell_ops = {
 	.get_brightness = dell_get_intensity,
 	.update_status  = dell_send_intensity,
 };
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 4226e53..387aad9 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -242,7 +242,7 @@ static struct device *eeepc_hwmon_device;
  */
 static int read_brightness(struct backlight_device *bd);
 static int update_bl_status(struct backlight_device *bd);
-static struct backlight_ops eeepcbl_ops = {
+static const struct backlight_ops eeepcbl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index bcd4ba8..a249b35 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -436,7 +436,7 @@ static int bl_update_status(struct backlight_device *b)
 	return ret;
 }
 
-static struct backlight_ops fujitsubl_ops = {
+static const struct backlight_ops fujitsubl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status = bl_update_status,
 };
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 759763d..1093ba2 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -161,7 +161,7 @@ static int bl_update_status(struct backlight_device *b)
 	return set_lcd_level(b->props.brightness);
 }
 
-static struct backlight_ops msibl_ops = {
+static const struct backlight_ops msibl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status  = bl_update_status,
 };
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index fe7cf01..9012d8d 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -352,7 +352,7 @@ static int bl_set_status(struct backlight_device *bd)
 	return acpi_pcc_write_sset(pcc, SINF_DC_CUR_BRIGHT, bright);
 }
 
-static struct backlight_ops pcc_backlight_ops = {
+static const struct backlight_ops pcc_backlight_ops = {
 	.get_brightness	= bl_get,
 	.update_status	= bl_set_status,
 };
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index a2a742c..b37e25e 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -850,7 +850,7 @@ static int sony_backlight_get_brightness(struct backlight_device *bd)
 }
 
 static struct backlight_device *sony_backlight_device;
-static struct backlight_ops sony_backlight_ops = {
+static const struct backlight_ops sony_backlight_ops = {
 	.update_status = sony_backlight_update_status,
 	.get_brightness = sony_backlight_get_brightness,
 };
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index a848c7e..1c42bc6 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6095,7 +6095,7 @@ static int brightness_get(struct backlight_device *bd)
 	return status & TP_EC_BACKLIGHT_LVLMSK;
 }
 
-static struct backlight_ops ibm_backlight_data = {
+static const struct backlight_ops ibm_backlight_data = {
 	.get_brightness = brightness_get,
 	.update_status  = brightness_update_status,
 };
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 51c0a8b..0786629 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -671,7 +671,7 @@ static acpi_status remove_device(void)
 	return AE_OK;
 }
 
-static struct backlight_ops toshiba_backlight_data = {
+static const struct backlight_ops toshiba_backlight_data = {
         .get_brightness = get_lcd,
         .update_status  = set_lcd_status,
 };
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 1d8e39a..7aef786 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -178,7 +178,7 @@ static int appledisplay_bl_get_brightness(struct backlight_device *bd)
 		return pdata->msgdata[1];
 }
 
-static struct backlight_ops appledisplay_bl_data = {
+static const struct backlight_ops appledisplay_bl_data = {
 	.get_brightness	= appledisplay_bl_get_brightness,
 	.update_status	= appledisplay_bl_update_status,
 };
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index d5e8010..5687b56 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -110,7 +110,7 @@ static int atmel_bl_get_brightness(struct backlight_device *bl)
 	return lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
 }
 
-static struct backlight_ops atmel_lcdc_bl_ops = {
+static const struct backlight_ops atmel_lcdc_bl_ops = {
 	.update_status = atmel_bl_update_status,
 	.get_brightness = atmel_bl_get_brightness,
 };
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index e4e4d43..137cd34 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1787,7 +1787,7 @@ static int aty128_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops aty128_bl_data = {
+static const struct backlight_ops aty128_bl_data = {
 	.get_brightness	= aty128_bl_get_brightness,
 	.update_status	= aty128_bl_update_status,
 };
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 913b4a4..9295a38 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2225,7 +2225,7 @@ static int aty_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops aty_bl_data = {
+static const struct backlight_ops aty_bl_data = {
 	.get_brightness = aty_bl_get_brightness,
 	.update_status	= aty_bl_update_status,
 };
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 1a056ad..221bd6a 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -127,7 +127,7 @@ static int radeon_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops radeon_bl_data = {
+static const struct backlight_ops radeon_bl_data = {
 	.get_brightness = radeon_bl_get_brightness,
 	.update_status	= radeon_bl_update_status,
 };
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index ad05da5..3cb2cb9 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -84,7 +84,7 @@ static int adp5520_bl_get_brightness(struct backlight_device *bl)
 	return error ? data->current_brightness : reg_val;
 }
 
-static struct backlight_ops adp5520_bl_ops = {
+static const struct backlight_ops adp5520_bl_ops = {
 	.update_status	= adp5520_bl_update_status,
 	.get_brightness	= adp5520_bl_get_brightness,
 };
diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
index 2c3bdfc..d769b0b 100644
--- a/drivers/video/backlight/adx_bl.c
+++ b/drivers/video/backlight/adx_bl.c
@@ -61,7 +61,7 @@ static int adx_backlight_check_fb(struct fb_info *fb)
 	return 1;
 }
 
-static struct backlight_ops adx_backlight_ops = {
+static const struct backlight_ops adx_backlight_ops = {
 	.options = 0,
 	.update_status = adx_backlight_update_status,
 	.get_brightness = adx_backlight_get_brightness,
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 505c082..6b6b3cc 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -113,7 +113,7 @@ static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
 	return pwm_channel_enable(&pwmbl->pwmc);
 }
 
-static struct backlight_ops atmel_pwm_bl_ops = {
+static const struct backlight_ops atmel_pwm_bl_ops = {
 	.get_brightness = atmel_pwm_bl_get_intensity,
 	.update_status  = atmel_pwm_bl_set_intensity,
 };
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 6615ac7..18829cf 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -269,7 +269,7 @@ EXPORT_SYMBOL(backlight_force_update);
  * ERR_PTR() or a pointer to the newly allocated device.
  */
 struct backlight_device *backlight_device_register(const char *name,
-		struct device *parent, void *devdata, struct backlight_ops *ops)
+		struct device *parent, void *devdata, const struct backlight_ops *ops)
 {
 	struct backlight_device *new_bd;
 	int rc;
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 9677494..b4bcf80 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -451,7 +451,7 @@ void corgi_lcd_limit_intensity(int limit)
 }
 EXPORT_SYMBOL(corgi_lcd_limit_intensity);
 
-static struct backlight_ops corgi_bl_ops = {
+static const struct backlight_ops corgi_bl_ops = {
 	.get_brightness	= corgi_bl_get_intensity,
 	.update_status  = corgi_bl_update_status,
 };
diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index b9fe62b..2914bf1 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -108,7 +108,7 @@ static int cr_backlight_get_intensity(struct backlight_device *bd)
 	return intensity;
 }
 
-static struct backlight_ops cr_backlight_ops = {
+static const struct backlight_ops cr_backlight_ops = {
 	.get_brightness = cr_backlight_get_intensity,
 	.update_status = cr_backlight_set_intensity,
 };
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 701a108..feacfd5 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -94,7 +94,7 @@ static int da903x_backlight_get_brightness(struct backlight_device *bl)
 	return data->current_brightness;
 }
 
-static struct backlight_ops da903x_backlight_ops = {
+static const struct backlight_ops da903x_backlight_ops = {
 	.update_status	= da903x_backlight_update_status,
 	.get_brightness	= da903x_backlight_get_brightness,
 };
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 6d27f62..e6d348e 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -70,7 +70,7 @@ void corgibl_limit_intensity(int limit)
 }
 EXPORT_SYMBOL(corgibl_limit_intensity);
 
-static struct backlight_ops genericbl_ops = {
+static const struct backlight_ops genericbl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = genericbl_get_intensity,
 	.update_status  = genericbl_send_intensity,
diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 7fb4eef..f7cc528 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -98,7 +98,7 @@ static int hp680bl_get_intensity(struct backlight_device *bd)
 	return current_intensity;
 }
 
-static struct backlight_ops hp680bl_ops = {
+static const struct backlight_ops hp680bl_ops = {
 	.get_brightness = hp680bl_get_intensity,
 	.update_status  = hp680bl_set_intensity,
 };
diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 7aed256..db9071f 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -93,7 +93,7 @@ out:
 	return ret;
 }
 
-static struct backlight_ops jornada_bl_ops = {
+static const struct backlight_ops jornada_bl_ops = {
 	.get_brightness = jornada_bl_get_brightness,
 	.update_status = jornada_bl_update_status,
 	.options = BL_CORE_SUSPENDRESUME,
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index a38fda1..939e7b8 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -134,7 +134,7 @@ static int kb3886bl_get_intensity(struct backlight_device *bd)
 	return kb3886bl_intensity;
 }
 
-static struct backlight_ops kb3886bl_ops = {
+static const struct backlight_ops kb3886bl_ops = {
 	.get_brightness = kb3886bl_get_intensity,
 	.update_status  = kb3886bl_send_intensity,
 };
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 6b488b8..00a9591 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -141,7 +141,7 @@ static int locomolcd_get_intensity(struct backlight_device *bd)
 	return current_intensity;
 }
 
-static struct backlight_ops locomobl_data = {
+static const struct backlight_ops locomobl_data = {
 	.get_brightness = locomolcd_get_intensity,
 	.update_status  = locomolcd_set_intensity,
 };
diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 9edb8d7..5812468 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -33,7 +33,7 @@ struct dmi_match_data {
 	unsigned long iostart;
 	unsigned long iolen;
 	/* Backlight operations structure. */
-	struct backlight_ops backlight_ops;
+	const struct backlight_ops backlight_ops;
 };
 
 /* Module parameters. */
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index cbad67e..3cf900e 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -125,7 +125,7 @@ static int omapbl_get_intensity(struct backlight_device *dev)
 	return bl->current_intensity;
 }
 
-static struct backlight_ops omapbl_ops = {
+static const struct backlight_ops omapbl_ops = {
 	.get_brightness = omapbl_get_intensity,
 	.update_status  = omapbl_update_status,
 };
diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 9edaf24..075786e 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -54,7 +54,7 @@ static int progearbl_get_intensity(struct backlight_device *bd)
 	return intensity - HW_LEVEL_MIN;
 }
 
-static struct backlight_ops progearbl_ops = {
+static const struct backlight_ops progearbl_ops = {
 	.get_brightness = progearbl_get_intensity,
 	.update_status = progearbl_set_intensity,
 };
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 8871662..df9e0b3 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -56,7 +56,7 @@ static int pwm_backlight_get_brightness(struct backlight_device *bl)
 	return bl->props.brightness;
 }
 
-static struct backlight_ops pwm_backlight_ops = {
+static const struct backlight_ops pwm_backlight_ops = {
 	.update_status	= pwm_backlight_update_status,
 	.get_brightness	= pwm_backlight_get_brightness,
 };
diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 43edbad..e14ce4d 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -72,7 +72,7 @@ static int tosa_bl_get_brightness(struct backlight_device *dev)
 	return props->brightness;
 }
 
-static struct backlight_ops bl_ops = {
+static const struct backlight_ops bl_ops = {
 	.get_brightness		= tosa_bl_get_brightness,
 	.update_status		= tosa_bl_update_status,
 };
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 467bdb7..e32add3 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -112,7 +112,7 @@ static int wm831x_backlight_get_brightness(struct backlight_device *bl)
 	return data->current_brightness;
 }
 
-static struct backlight_ops wm831x_backlight_ops = {
+static const struct backlight_ops wm831x_backlight_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.update_status	= wm831x_backlight_update_status,
 	.get_brightness	= wm831x_backlight_get_brightness,
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index e49ae5e..db4e6f7 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -463,7 +463,7 @@ static int bl_get_brightness(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops bfin_lq043fb_bl_ops = {
+static const struct backlight_ops bfin_lq043fb_bl_ops = {
 	.get_brightness = bl_get_brightness,
 };
 
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 5cc36cf..4e06416 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -381,7 +381,7 @@ static int bl_get_brightness(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops bfin_lq043fb_bl_ops = {
+static const struct backlight_ops bfin_lq043fb_bl_ops = {
 	.get_brightness = bl_get_brightness,
 };
 
diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/nvidia/nv_backlight.c
index 443e3c8..c443d6a 100644
--- a/drivers/video/nvidia/nv_backlight.c
+++ b/drivers/video/nvidia/nv_backlight.c
@@ -87,7 +87,7 @@ static int nvidia_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops nvidia_bl_ops = {
+static const struct backlight_ops nvidia_bl_ops = {
 	.get_brightness = nvidia_bl_get_brightness,
 	.update_status	= nvidia_bl_update_status,
 };
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index d94c57f..912984c 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -331,7 +331,7 @@ static int riva_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops riva_bl_ops = {
+static const struct backlight_ops riva_bl_ops = {
 	.get_brightness = riva_bl_get_brightness,
 	.update_status	= riva_bl_update_status,
 };
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 0f5f578..8c4f884 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -36,18 +36,18 @@ struct backlight_device;
 struct fb_info;
 
 struct backlight_ops {
-	unsigned int options;
+	const unsigned int options;
 
 #define BL_CORE_SUSPENDRESUME	(1 << 0)
 
 	/* Notify the backlight driver some property has changed */
-	int (*update_status)(struct backlight_device *);
+	int (* const update_status)(struct backlight_device *);
 	/* Return the current backlight brightness (accounting for power,
 	   fb_blank etc.) */
-	int (*get_brightness)(struct backlight_device *);
+	int (* const get_brightness)(struct backlight_device *);
 	/* Check if given framebuffer device is the one bound to this backlight;
 	   return 0 if not, !=0 if it is. If NULL, backlight always matches the fb. */
-	int (*check_fb)(struct fb_info *);
+	int (* const check_fb)(struct fb_info *);
 };
 
 /* This structure defines all the properties of a backlight */
@@ -86,7 +86,7 @@ struct backlight_device {
 	   registered this device has been unloaded, and if class_get_devdata()
 	   points to something in the body of that driver, it is also invalid. */
 	struct mutex ops_lock;
-	struct backlight_ops *ops;
+	const struct backlight_ops *ops;
 
 	/* The framebuffer notifier block */
 	struct notifier_block fb_notif;
@@ -103,7 +103,7 @@ static inline void backlight_update_status(struct backlight_device *bd)
 }
 
 extern struct backlight_device *backlight_device_register(const char *name,
-	struct device *dev, void *devdata, struct backlight_ops *ops);
+	struct device *dev, void *devdata, const struct backlight_ops *ops);
 extern void backlight_device_unregister(struct backlight_device *bd);
 extern void backlight_force_update(struct backlight_device *bd,
 				   enum backlight_update_reason reason);

