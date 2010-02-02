Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab0BBHxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:53:55 -0500
Received: from iksaif.net ([88.191.73.63]:50276 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab0BBHwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:12 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 05/28] asus-laptop: use tabs to indent macros and remove unused ones
Date: Tue,  2 Feb 2010 08:38:48 +0100
Message-Id: <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   51 +++++++++++++++--------------------
 1 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 7058cb5..5889bda 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -50,50 +50,43 @@
 #include <asm/uaccess.h>
 #include <linux/input.h>
 
-#define ASUS_LAPTOP_VERSION "0.42"
+#define ASUS_LAPTOP_VERSION	"0.42"
 
-#define ASUS_HOTK_NAME          "Asus Laptop Support"
-#define ASUS_HOTK_CLASS         "hotkey"
-#define ASUS_HOTK_DEVICE_NAME   "Hotkey"
-#define ASUS_HOTK_FILE          KBUILD_MODNAME
-#define ASUS_HOTK_PREFIX        "\\_SB.ATKD."
+#define ASUS_HOTK_NAME		"Asus Laptop Support"
+#define ASUS_HOTK_CLASS		"hotkey"
+#define ASUS_HOTK_DEVICE_NAME	"Hotkey"
+#define ASUS_HOTK_FILE		KBUILD_MODNAME
+#define ASUS_HOTK_PREFIX	"\\_SB.ATKD."
 
 
 /*
  * Some events we use, same for all Asus
  */
-#define ATKD_BR_UP       0x10
-#define ATKD_BR_DOWN     0x20
-#define ATKD_LCD_ON      0x33
-#define ATKD_LCD_OFF     0x34
+#define ATKD_BR_UP	0x10
+#define ATKD_BR_DOWN	0x20
+#define ATKD_LCD_ON	0x33
+#define ATKD_LCD_OFF	0x34
 
 /*
  * Known bits returned by \_SB.ATKD.HWRS
  */
-#define WL_HWRS     0x80
-#define BT_HWRS     0x100
+#define WL_HWRS		0x80
+#define BT_HWRS		0x100
 
 /*
  * Flags for hotk status
  * WL_ON and BT_ON are also used for wireless_status()
  */
-#define WL_ON       0x01	/* internal Wifi */
-#define BT_ON       0x02	/* internal Bluetooth */
-#define MLED_ON     0x04	/* mail LED */
-#define TLED_ON     0x08	/* touchpad LED */
-#define RLED_ON     0x10	/* Record LED */
-#define PLED_ON     0x20	/* Phone LED */
-#define GLED_ON     0x40	/* Gaming LED */
-#define LCD_ON      0x80	/* LCD backlight */
-#define GPS_ON      0x100	/* GPS */
-#define KEY_ON      0x200	/* Keyboard backlight */
-
-#define ASUS_LOG    ASUS_HOTK_FILE ": "
-#define ASUS_ERR    KERN_ERR    ASUS_LOG
-#define ASUS_WARNING    KERN_WARNING    ASUS_LOG
-#define ASUS_NOTICE KERN_NOTICE ASUS_LOG
-#define ASUS_INFO   KERN_INFO   ASUS_LOG
-#define ASUS_DEBUG  KERN_DEBUG  ASUS_LOG
+#define WL_ON		0x01	/* internal Wifi */
+#define BT_ON		0x02	/* internal Bluetooth */
+#define MLED_ON		0x04	/* mail LED */
+#define TLED_ON		0x08	/* touchpad LED */
+#define RLED_ON		0x10	/* Record LED */
+#define PLED_ON		0x20	/* Phone LED */
+#define GLED_ON		0x40	/* Gaming LED */
+#define LCD_ON		0x80	/* LCD backlight */
+#define GPS_ON		0x100	/* GPS */
+#define KEY_ON		0x200	/* Keyboard backlight */
 
 MODULE_AUTHOR("Julien Lerouge, Karol Kozimor, Corentin Chary");
 MODULE_DESCRIPTION(ASUS_HOTK_NAME);
-- 
1.6.6.1

