Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZGCMju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZGCMju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZGCMjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:39:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:34661 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751072AbZGCMjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:39:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+Zy+ZQEOmZByG1AsIY/3fNG7a5kosMPM68kbxoCb
	R4KrzP01CO2kkc
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] media/omap: adding __init/__exit macros to lcd_drivers
Date: Fri, 3 Jul 2009 14:39:40 +0200
User-Agent: KMail/1.9.9
Cc: imre.deak@nokia.com, linux-omap@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031439.40456.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init and __exit macros to the module_init /
module_exit functions to several files in drivers/video/omap/

linux version 2.6.31-rc1 - linus git tree

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/video/omap/lcd_h3.c b/drivers/video/omap/lcd_h3.c
index 2486237..417ae5e 100644
--- a/drivers/video/omap/lcd_h3.c
+++ b/drivers/video/omap/lcd_h3.c
@@ -124,12 +124,12 @@ struct platform_driver h3_panel_driver = {
 	},
 };
 
-static int h3_panel_drv_init(void)
+static int __init h3_panel_drv_init(void)
 {
 	return platform_driver_register(&h3_panel_driver);
 }
 
-static void h3_panel_drv_cleanup(void)
+static void __exit h3_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&h3_panel_driver);
 }
diff --git a/drivers/video/omap/lcd_h4.c b/drivers/video/omap/lcd_h4.c
index 6ff5643..0c398bd 100644
--- a/drivers/video/omap/lcd_h4.c
+++ b/drivers/video/omap/lcd_h4.c
@@ -102,12 +102,12 @@ static struct platform_driver h4_panel_driver = {
 	},
 };
 
-static int h4_panel_drv_init(void)
+static int __init h4_panel_drv_init(void)
 {
 	return platform_driver_register(&h4_panel_driver);
 }
 
-static void h4_panel_drv_cleanup(void)
+static void __exit h4_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&h4_panel_driver);
 }
diff --git a/drivers/video/omap/lcd_inn1510.c b/drivers/video/omap/lcd_inn1510.c
index 6953ed4..cdbd8bb 100644
--- a/drivers/video/omap/lcd_inn1510.c
+++ b/drivers/video/omap/lcd_inn1510.c
@@ -109,12 +109,12 @@ struct platform_driver innovator1510_panel_driver = {
 	},
 };
 
-static int innovator1510_panel_drv_init(void)
+static int __init innovator1510_panel_drv_init(void)
 {
 	return platform_driver_register(&innovator1510_panel_driver);
 }
 
-static void innovator1510_panel_drv_cleanup(void)
+static void __exit innovator1510_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&innovator1510_panel_driver);
 }
diff --git a/drivers/video/omap/lcd_inn1610.c b/drivers/video/omap/lcd_inn1610.c
index 4c4f7ee..268f7f8 100644
--- a/drivers/video/omap/lcd_inn1610.c
+++ b/drivers/video/omap/lcd_inn1610.c
@@ -133,12 +133,12 @@ struct platform_driver innovator1610_panel_driver = {
 	},
 };
 
-static int innovator1610_panel_drv_init(void)
+static int __init innovator1610_panel_drv_init(void)
 {
 	return platform_driver_register(&innovator1610_panel_driver);
 }
 
-static void innovator1610_panel_drv_cleanup(void)
+static void __exit innovator1610_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&innovator1610_panel_driver);
 }
diff --git a/drivers/video/omap/lcd_osk.c b/drivers/video/omap/lcd_osk.c
index 379c96d..b3fa88b 100644
--- a/drivers/video/omap/lcd_osk.c
+++ b/drivers/video/omap/lcd_osk.c
@@ -127,12 +127,12 @@ struct platform_driver osk_panel_driver = {
 	},
 };
 
-static int osk_panel_drv_init(void)
+static int __init osk_panel_drv_init(void)
 {
 	return platform_driver_register(&osk_panel_driver);
 }
 
-static void osk_panel_drv_cleanup(void)
+static void __exit osk_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&osk_panel_driver);
 }
diff --git a/drivers/video/omap/lcd_palmte.c b/drivers/video/omap/lcd_palmte.c
index 2183173..4bf3c79 100644
--- a/drivers/video/omap/lcd_palmte.c
+++ b/drivers/video/omap/lcd_palmte.c
@@ -108,12 +108,12 @@ struct platform_driver palmte_panel_driver = {
 	},
 };
 
-static int palmte_panel_drv_init(void)
+static int __init palmte_panel_drv_init(void)
 {
 	return platform_driver_register(&palmte_panel_driver);
 }
 
-static void palmte_panel_drv_cleanup(void)
+static void __exit palmte_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&palmte_panel_driver);
 }
diff --git a/drivers/video/omap/lcd_palmtt.c b/drivers/video/omap/lcd_palmtt.c
index 57b0f6c..48ea1f9 100644
--- a/drivers/video/omap/lcd_palmtt.c
+++ b/drivers/video/omap/lcd_palmtt.c
@@ -113,12 +113,12 @@ struct platform_driver palmtt_panel_driver = {
 	},
 };
 
-static int palmtt_panel_drv_init(void)
+static int __init palmtt_panel_drv_init(void)
 {
 	return platform_driver_register(&palmtt_panel_driver);
 }
 
-static void palmtt_panel_drv_cleanup(void)
+static void __exit palmtt_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&palmtt_panel_driver);
 }
diff --git a/drivers/video/omap/lcd_palmz71.c b/drivers/video/omap/lcd_palmz71.c
index d33d78b..0697d29 100644
--- a/drivers/video/omap/lcd_palmz71.c
+++ b/drivers/video/omap/lcd_palmz71.c
@@ -109,12 +109,12 @@ struct platform_driver palmz71_panel_driver = {
 	},
 };
 
-static int palmz71_panel_drv_init(void)
+static int __init palmz71_panel_drv_init(void)
 {
 	return platform_driver_register(&palmz71_panel_driver);
 }
 
-static void palmz71_panel_drv_cleanup(void)
+static void __exit palmz71_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&palmz71_panel_driver);
 }
