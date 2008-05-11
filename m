Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYEKBvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYEKBvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 21:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYEKBvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 21:51:13 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64878 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752129AbYEKBvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 21:51:12 -0400
Date: Sun, 11 May 2008 02:50:18 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Alexander Bigga <ab@mycable.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] RTC: M41T80: Sort header inclusions for readability
Message-ID: <Pine.LNX.4.55.0805110245180.18978@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Sort the header inclusions for readability.  No functional changes.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 By request of I2C maintainers I have made it a separate patch.  It should
be obvious.  Please apply -- it goes on top of
patch-2.6.26-rc1-20080505-m41t80-kernel-h-15 sent yesterday.

  Maciej

patch-2.6.26-rc1-20080505-m41t80-headers-15
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-10 00:59:33.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-10 02:43:27.000000000 +0000
@@ -13,20 +13,20 @@
  *
  */
 
-#include <linux/module.h>
+#include <linux/bcd.h>
+#include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/i2c.h>
-#include <linux/rtc.h>
-#include <linux/bcd.h>
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/reboot.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
+#include <linux/miscdevice.h>
+#include <linux/reboot.h>
+#include <linux/watchdog.h>
 #endif
 
 #define M41T80_REG_SSEC	0
