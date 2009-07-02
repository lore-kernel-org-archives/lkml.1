Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZGBRIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZGBRIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZGBRIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:08:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:51671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752314AbZGBRIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:08:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+m/ip0DK2mOqyQtesgvd8kuY03MGKMtYPDDs1zhL
	EbVd43OscTsAWh
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] hid: adding __init/__exit macros to several hids
Date: Thu, 2 Jul 2009 19:08:38 +0200
User-Agent: KMail/1.9.9
Cc: kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907021908.39275.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init and __exit macros to the module_init /
module_exit functions of several hids from drivers/hid/

linux version 2.6.31-rc1 - linus git tree

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 42ea359..df474c6 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -145,12 +145,12 @@ static struct hid_driver a4_driver = {
 	.remove = a4_remove,
 };
 
-static int a4_init(void)
+static int __init a4_init(void)
 {
 	return hid_register_driver(&a4_driver);
 }
 
-static void a4_exit(void)
+static void __exit a4_exit(void)
 {
 	hid_unregister_driver(&a4_driver);
 }
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 303ccce..4b96e7a 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -451,7 +451,7 @@ static struct hid_driver apple_driver = {
 	.input_mapped = apple_input_mapped,
 };
 
-static int apple_init(void)
+static int __init apple_init(void)
 {
 	int ret;
 
@@ -462,7 +462,7 @@ static int apple_init(void)
 	return ret;
 }
 
-static void apple_exit(void)
+static void __exit apple_exit(void)
 {
 	hid_unregister_driver(&apple_driver);
 }
diff --git a/drivers/hid/hid-belkin.c b/drivers/hid/hid-belkin.c
index 2f67231..4ce7aa3 100644
--- a/drivers/hid/hid-belkin.c
+++ b/drivers/hid/hid-belkin.c
@@ -88,12 +88,12 @@ static struct hid_driver belkin_driver = {
 	.probe = belkin_probe,
 };
 
-static int belkin_init(void)
+static int __init belkin_init(void)
 {
 	return hid_register_driver(&belkin_driver);
 }
 
-static void belkin_exit(void)
+static void __exit belkin_exit(void)
 {
 	hid_unregister_driver(&belkin_driver);
 }
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index ab8209e..7e597d7 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -70,12 +70,12 @@ static struct hid_driver ch_driver = {
 	.input_mapping = ch_input_mapping,
 };
 
-static int ch_init(void)
+static int __init ch_init(void)
 {
 	return hid_register_driver(&ch_driver);
 }
 
-static void ch_exit(void)
+static void __exit ch_exit(void)
 {
 	hid_unregister_driver(&ch_driver);
 }
diff --git a/drivers/hid/hid-chicony.c b/drivers/hid/hid-chicony.c
index 7f91076..8965ad9 100644
--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -63,12 +63,12 @@ static struct hid_driver ch_driver = {
 	.input_mapping = ch_input_mapping,
 };
 
-static int ch_init(void)
+static int __init ch_init(void)
 {
 	return hid_register_driver(&ch_driver);
 }
 
-static void ch_exit(void)
+static void __exit ch_exit(void)
 {
 	hid_unregister_driver(&ch_driver);
 }
diff --git a/drivers/hid/hid-cypress.c b/drivers/hid/hid-cypress.c
index 9d6d3b9..62e9cb1 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -141,12 +141,12 @@ static struct hid_driver cp_driver = {
 	.probe = cp_probe,
 };
 
-static int cp_init(void)
+static int __init cp_init(void)
 {
 	return hid_register_driver(&cp_driver);
 }
 
-static void cp_exit(void)
+static void __exit cp_exit(void)
 {
 	hid_unregister_driver(&cp_driver);
 }
diff --git a/drivers/hid/hid-ezkey.c b/drivers/hid/hid-ezkey.c
index 0a1fe05..ca1163e 100644
--- a/drivers/hid/hid-ezkey.c
+++ b/drivers/hid/hid-ezkey.c
@@ -78,12 +78,12 @@ static struct hid_driver ez_driver = {
 	.event = ez_event,
 };
 
-static int ez_init(void)
+static int __init ez_init(void)
 {
 	return hid_register_driver(&ez_driver);
 }
 
-static void ez_exit(void)
+static void __exit ez_exit(void)
 {
 	hid_unregister_driver(&ez_driver);
 }
diff --git a/drivers/hid/hid-gyration.c b/drivers/hid/hid-gyration.c
index d42d222..cab13e8 100644
--- a/drivers/hid/hid-gyration.c
+++ b/drivers/hid/hid-gyration.c
@@ -81,12 +81,12 @@ static struct hid_driver gyration_driver = {
 	.event = gyration_event,
 };
 
-static int gyration_init(void)
+static int __init gyration_init(void)
 {
 	return hid_register_driver(&gyration_driver);
 }
 
-static void gyration_exit(void)
+static void __exit gyration_exit(void)
 {
 	hid_unregister_driver(&gyration_driver);
 }
diff --git a/drivers/hid/hid-kensington.c b/drivers/hid/hid-kensington.c
index 7353bd7..a5b4016 100644
--- a/drivers/hid/hid-kensington.c
+++ b/drivers/hid/hid-kensington.c
@@ -48,12 +48,12 @@ static struct hid_driver ks_driver = {
 	.input_mapping = ks_input_mapping,
 };
 
-static int ks_init(void)
+static int __init ks_init(void)
 {
 	return hid_register_driver(&ks_driver);
 }
 
-static void ks_exit(void)
+static void __exit ks_exit(void)
 {
 	hid_unregister_driver(&ks_driver);
 }
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index 72ee3fe..f887171 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -54,12 +54,12 @@ static struct hid_driver kye_driver = {
 	.report_fixup = kye_report_fixup,
 };
 
-static int kye_init(void)
+static int __init kye_init(void)
 {
 	return hid_register_driver(&kye_driver);
 }
 
-static void kye_exit(void)
+static void __exit kye_exit(void)
 {
 	hid_unregister_driver(&kye_driver);
 }
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 7afbaa0..ac212a7 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -315,12 +315,12 @@ static struct hid_driver lg_driver = {
 	.probe = lg_probe,
 };
 
-static int lg_init(void)
+static int __init lg_init(void)
 {
 	return hid_register_driver(&lg_driver);
 }
 
-static void lg_exit(void)
+static void __exit lg_exit(void)
 {
 	hid_unregister_driver(&lg_driver);
 }
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 5e9e37a..359cc44 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -197,12 +197,12 @@ static struct hid_driver ms_driver = {
 	.probe = ms_probe,
 };
 
-static int ms_init(void)
+static int __init ms_init(void)
 {
 	return hid_register_driver(&ms_driver);
 }
 
-static void ms_exit(void)
+static void __exit ms_exit(void)
 {
 	hid_unregister_driver(&ms_driver);
 }
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index 240f876..2cd05aa 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -65,12 +65,12 @@ static struct hid_driver mr_driver = {
 	.input_mapping = mr_input_mapping,
 };
 
-static int mr_init(void)
+static int __init mr_init(void)
 {
 	return hid_register_driver(&mr_driver);
 }
 
-static void mr_exit(void)
+static void __exit mr_exit(void)
 {
 	hid_unregister_driver(&mr_driver);
 }
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 75ed9d2..a9ce1e5 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -265,12 +265,12 @@ static struct hid_driver ntrig_driver = {
 	.event = ntrig_event,
 };
 
-static int ntrig_init(void)
+static int __init ntrig_init(void)
 {
 	return hid_register_driver(&ntrig_driver);
 }
 
-static void ntrig_exit(void)
+static void __exit ntrig_exit(void)
 {
 	hid_unregister_driver(&ntrig_driver);
 }
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index 2e83e8f..500fbd0 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -105,12 +105,12 @@ static struct hid_driver pl_driver = {
 	.probe = pl_probe,
 };
 
-static int pl_init(void)
+static int __init pl_init(void)
 {
 	return hid_register_driver(&pl_driver);
 }
 
-static void pl_exit(void)
+static void __exit pl_exit(void)
 {
 	hid_unregister_driver(&pl_driver);
 }
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 4db9a34..c6d7dbc 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -217,12 +217,12 @@ static struct hid_driver pl_driver = {
 	.probe = pl_probe,
 };
 
-static int pl_init(void)
+static int __init pl_init(void)
 {
 	return hid_register_driver(&pl_driver);
 }
 
-static void pl_exit(void)
+static void __exit pl_exit(void)
 {
 	hid_unregister_driver(&pl_driver);
 }
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index 07083aa..d89243d 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -83,12 +83,12 @@ static struct hid_driver samsung_driver = {
 	.probe = samsung_probe,
 };
 
-static int samsung_init(void)
+static int __init samsung_init(void)
 {
 	return hid_register_driver(&samsung_driver);
 }
 
-static void samsung_exit(void)
+static void __exit samsung_exit(void)
 {
 	hid_unregister_driver(&samsung_driver);
 }
diff --git a/drivers/hid/hid-sjoy.c b/drivers/hid/hid-sjoy.c
index eab169e..203c438 100644
--- a/drivers/hid/hid-sjoy.c
+++ b/drivers/hid/hid-sjoy.c
@@ -163,12 +163,12 @@ static struct hid_driver sjoy_driver = {
 	.probe = sjoy_probe,
 };
 
-static int sjoy_init(void)
+static int __init sjoy_init(void)
 {
 	return hid_register_driver(&sjoy_driver);
 }
 
-static void sjoy_exit(void)
+static void __exit sjoy_exit(void)
 {
 	hid_unregister_driver(&sjoy_driver);
 }
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index c259938..4e84502 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -135,12 +135,12 @@ static struct hid_driver sony_driver = {
 	.report_fixup = sony_report_fixup,
 };
 
-static int sony_init(void)
+static int __init sony_init(void)
 {
 	return hid_register_driver(&sony_driver);
 }
 
-static void sony_exit(void)
+static void __exit sony_exit(void)
 {
 	hid_unregister_driver(&sony_driver);
 }
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index e0a8fd3..438107d 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -65,12 +65,12 @@ static struct hid_driver sp_driver = {
 	.input_mapping = sp_input_mapping,
 };
 
-static int sp_init(void)
+static int __init sp_init(void)
 {
 	return hid_register_driver(&sp_driver);
 }
 
-static void sp_exit(void)
+static void __exit sp_exit(void)
 {
 	hid_unregister_driver(&sp_driver);
 }
diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index fcd6ccd..1914ea0 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -259,12 +259,12 @@ static struct hid_driver tm_driver = {
 	.probe = tm_probe,
 };
 
-static int tm_init(void)
+static int __init tm_init(void)
 {
 	return hid_register_driver(&tm_driver);
 }
 
-static void tm_exit(void)
+static void __exit tm_exit(void)
 {
 	hid_unregister_driver(&tm_driver);
 }
diff --git a/drivers/hid/hid-topseed.c b/drivers/hid/hid-topseed.c
index 152ccfa..6925eda 100644
--- a/drivers/hid/hid-topseed.c
+++ b/drivers/hid/hid-topseed.c
@@ -60,12 +60,12 @@ static struct hid_driver ts_driver = {
 	.input_mapping = ts_input_mapping,
 };
 
-static int ts_init(void)
+static int __init ts_init(void)
 {
 	return hid_register_driver(&ts_driver);
 }
 
-static void ts_exit(void)
+static void __exit ts_exit(void)
 {
 	hid_unregister_driver(&ts_driver);
 }
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 1f9237f..7475421 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -237,7 +237,7 @@ static struct hid_driver wacom_driver = {
 	.raw_event = wacom_raw_event,
 };
 
-static int wacom_init(void)
+static int __init wacom_init(void)
 {
 	int ret;
 
@@ -248,7 +248,7 @@ static int wacom_init(void)
 	return ret;
 }
 
-static void wacom_exit(void)
+static void __exit wacom_exit(void)
 {
 	hid_unregister_driver(&wacom_driver);
 }
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index 57f7107..a79f0d7 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -152,12 +152,12 @@ static struct hid_driver zp_driver = {
 	.probe = zp_probe,
 };
 
-static int zp_init(void)
+static int __init zp_init(void)
 {
 	return hid_register_driver(&zp_driver);
 }
 
-static void zp_exit(void)
+static void __exit zp_exit(void)
 {
 	hid_unregister_driver(&zp_driver);
 }
