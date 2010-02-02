Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0BBHwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:20 -0500
Received: from iksaif.net ([88.191.73.63]:50257 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab0BBHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:08 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 28/28] asus-laptop: fix style problems reported by checkpath.pl
Date: Tue,  2 Feb 2010 08:39:11 +0100
Message-Id: <1265096351-15239-29-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-28-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-20-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-21-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-22-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-23-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-24-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-25-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-26-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-27-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-28-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   94 ++++++++++++++++++------------------
 1 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index d0d117b..791fcf3 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -45,12 +45,12 @@
 #include <linux/fb.h>
 #include <linux/leds.h>
 #include <linux/platform_device.h>
-#include <acpi/acpi_drivers.h>
-#include <acpi/acpi_bus.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
 #include <linux/rfkill.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/acpi_bus.h>
 
 #define ASUS_LAPTOP_VERSION	"0.42"
 
@@ -94,10 +94,10 @@ MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 /*
  * Some events we use, same for all Asus
  */
-#define ATKD_BR_UP	0x10	// (event & ~ATKD_BR_UP) = brightness level
-#define ATKD_BR_DOWN	0x20	// (event & ~ATKD_BR_DOWN) = britghness level
+#define ATKD_BR_UP	0x10	/* (event & ~ATKD_BR_UP) = brightness level */
+#define ATKD_BR_DOWN	0x20	/* (event & ~ATKD_BR_DOWN) = britghness level */
 #define ATKD_BR_MIN	ATKD_BR_UP
-#define ATKD_BR_MAX	(ATKD_BR_DOWN | 0xF)	// 0x2f
+#define ATKD_BR_MAX	(ATKD_BR_DOWN | 0xF)	/* 0x2f */
 #define ATKD_LCD_ON	0x33
 #define ATKD_LCD_OFF	0x34
 
@@ -114,10 +114,6 @@ MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 #define WL_RSTS		0x01	/* internal Wifi */
 #define BT_RSTS		0x02	/* internal Bluetooth */
 
-#define ASUS_HANDLE(object, paths...)					\
-	static acpi_handle  object##_handle = NULL;			\
-	static char *object##_paths[] = { paths }
-
 /* LED */
 #define METHOD_MLED		"MLED"
 #define METHOD_TLED		"TLED"
@@ -142,40 +138,44 @@ MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 #define METHOD_BRIGHTNESS_GET	"GPLV"
 
 /* Backlight */
-ASUS_HANDLE(lcd_switch, "\\_SB.PCI0.SBRG.EC0._Q10",	/* All new models */
-	    "\\_SB.PCI0.ISA.EC0._Q10",	/* A1x */
-	    "\\_SB.PCI0.PX40.ECD0._Q10",	/* L3C */
-	    "\\_SB.PCI0.PX40.EC0.Q10",	/* M1A */
-	    "\\_SB.PCI0.LPCB.EC0._Q10",	/* P30 */
-	    "\\_SB.PCI0.LPCB.EC0._Q0E", /* P30/P35 */
-	    "\\_SB.PCI0.PX40.Q10",	/* S1x */
-	    "\\Q10");		/* A2x, L2D, L3D, M2E */
+static acpi_handle lcd_switch_handle;
+static const char *lcd_switch_paths[] = {
+  "\\_SB.PCI0.SBRG.EC0._Q10",	/* All new models */
+  "\\_SB.PCI0.ISA.EC0._Q10",	/* A1x */
+  "\\_SB.PCI0.PX40.ECD0._Q10",	/* L3C */
+  "\\_SB.PCI0.PX40.EC0.Q10",	/* M1A */
+  "\\_SB.PCI0.LPCB.EC0._Q10",	/* P30 */
+  "\\_SB.PCI0.LPCB.EC0._Q0E", /* P30/P35 */
+  "\\_SB.PCI0.PX40.Q10",	/* S1x */
+  "\\Q10"};		/* A2x, L2D, L3D, M2E */
 
 /* Display */
 #define METHOD_SWITCH_DISPLAY	"SDSP"
-ASUS_HANDLE(display_get,
-	    /* A6B, A6K A6R A7D F3JM L4R M6R A3G M6A M6V VX-1 V6J V6V W3Z */
-	    "\\_SB.PCI0.P0P1.VGA.GETD",
-	    /* A3E A4K, A4D A4L A6J A7J A8J Z71V M9V S5A M5A z33A W1Jc W2V G1 */
-	    "\\_SB.PCI0.P0P2.VGA.GETD",
-	    /* A6V A6Q */
-	    "\\_SB.PCI0.P0P3.VGA.GETD",
-	    /* A6T, A6M */
-	    "\\_SB.PCI0.P0PA.VGA.GETD",
-	    /* L3C */
-	    "\\_SB.PCI0.PCI1.VGAC.NMAP",
-	    /* Z96F */
-	    "\\_SB.PCI0.VGA.GETD",
-	    /* A2D */
-	    "\\ACTD",
-	    /* A4G Z71A W1N W5A W5F M2N M3N M5N M6N S1N S5N */
-	    "\\ADVG",
-	    /* P30 */
-	    "\\DNXT",
-	    /* A2H D1 L2D L3D L3H L2E L5D L5C M1A M2E L4L W3V */
-	    "\\INFB",
-	    /* A3F A6F A3N A3L M6N W3N W6A */
-	    "\\SSTE");
+
+static acpi_handle display_get_handle;
+static const char *display_get_paths[] = {
+  /* A6B, A6K A6R A7D F3JM L4R M6R A3G M6A M6V VX-1 V6J V6V W3Z */
+  "\\_SB.PCI0.P0P1.VGA.GETD",
+  /* A3E A4K, A4D A4L A6J A7J A8J Z71V M9V S5A M5A z33A W1Jc W2V G1 */
+  "\\_SB.PCI0.P0P2.VGA.GETD",
+  /* A6V A6Q */
+  "\\_SB.PCI0.P0P3.VGA.GETD",
+  /* A6T, A6M */
+  "\\_SB.PCI0.P0PA.VGA.GETD",
+  /* L3C */
+  "\\_SB.PCI0.PCI1.VGAC.NMAP",
+  /* Z96F */
+  "\\_SB.PCI0.VGA.GETD",
+  /* A2D */
+  "\\ACTD",
+  /* A4G Z71A W1N W5A W5F M2N M3N M5N M6N S1N S5N */
+  "\\ADVG",
+  /* P30 */
+  "\\DNXT",
+  /* A2H D1 L2D L3D L3H L2E L5D L5C M1A M2E L4L W3V */
+  "\\INFB",
+  /* A3F A6F A3N A3L M6N W3N W6A */
+  "\\SSTE"};
 
 #define METHOD_ALS_CONTROL	"ALSC" /* Z71A Z71V */
 #define METHOD_ALS_LEVEL	"ALSL" /* Z71A Z71V */
@@ -426,7 +426,7 @@ static void asus_kled_cdev_set(struct led_classdev *led_cdev,
 	struct asus_led *led = container_of(led_cdev, struct asus_led, led);
 	struct asus_laptop *asus = led->asus;
 
-        led->wk = value;
+	led->wk = value;
 	queue_work(asus->led_workqueue, &led->work);
 }
 
@@ -474,7 +474,7 @@ static int asus_led_register(struct asus_laptop *asus,
 	struct led_classdev *led_cdev = &led->led;
 
 	if (!method || acpi_check_handle(asus->handle, method, NULL))
-	    return 0; /* Led not present */
+		return 0; /* Led not present */
 
 	led->asus = asus;
 	led->method = method;
@@ -687,8 +687,8 @@ static ssize_t show_infos(struct device *dev,
 	acpi_status rv = AE_OK;
 
 	/*
-	 * We use the easy way, we don't care of off and count, so we don't set eof
-	 * to 1
+	 * We use the easy way, we don't care of off and count,
+	 * so we don't set eof to 1
 	 */
 
 	len += sprintf(page, ASUS_LAPTOP_NAME " " ASUS_LAPTOP_VERSION "\n");
@@ -904,7 +904,7 @@ static int read_display(struct asus_laptop *asus)
 			pr_warning("Error reading display status\n");
 	}
 
-	value &= 0x0F;		/* needed for some models, shouldn't hurt others */
+	value &= 0x0F; /* needed for some models, shouldn't hurt others */
 
 	return value;
 }
@@ -1041,7 +1041,7 @@ static ssize_t show_gps(struct device *dev,
 static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
- 	struct asus_laptop *asus = dev_get_drvdata(dev);
+	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int rv, value;
 	int ret;
 
-- 
1.6.6.1

