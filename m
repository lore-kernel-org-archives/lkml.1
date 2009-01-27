Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZA0NxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZA0NxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZA0NxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:53:13 -0500
Received: from mail.openmoko.org ([88.198.124.205]:46515 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbZA0NxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:53:11 -0500
Subject: [PATCH 2/3] pcf50633_charger: Remove mbc_set_status
To: linux-kernel@vger.kernel.org
From: Balaji Rao <balajirrao@openmoko.org>
Cc: Anton Vorontsov <cbou@mail.ru>, Andy Green <andy@openmoko.com>
Date: Tue, 27 Jan 2009 19:22:55 +0530
Message-ID: <20090127135255.6875.64874.stgit@fedora.yogi>
In-Reply-To: <20090127135238.6875.26314.stgit@fedora.yogi>
References: <20090127135238.6875.26314.stgit@fedora.yogi>
User-Agent: StGit/0.14.3.328.gd3b3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused 'pcf50633_mbc_set_status' function.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/pcf50633-charger.c |   15 ---------------
 include/linux/mfd/pcf50633/mbc.h |    1 -
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 41aec2a..aceffdc 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -84,21 +84,6 @@ int pcf50633_mbc_get_status(struct pcf50633 *pcf)
 }
 EXPORT_SYMBOL_GPL(pcf50633_mbc_get_status);
 
-void pcf50633_mbc_set_status(struct pcf50633 *pcf, int what, int status)
-{
-	struct pcf50633_mbc *mbc = platform_get_drvdata(pcf->mbc_pdev);
-
-	if (what & PCF50633_MBC_USB_ONLINE)
-		mbc->usb_online = !!status;
-	if (what & PCF50633_MBC_USB_ACTIVE)
-		mbc->usb_active = !!status;
-	if (what & PCF50633_MBC_ADAPTER_ONLINE)
-		mbc->adapter_online = !!status;
-	if (what & PCF50633_MBC_ADAPTER_ACTIVE)
-		mbc->adapter_active = !!status;
-}
-EXPORT_SYMBOL_GPL(pcf50633_mbc_set_status);
-
 static ssize_t
 show_chgmode(struct device *dev, struct device_attribute *attr, char *buf)
 {
diff --git a/include/linux/mfd/pcf50633/mbc.h b/include/linux/mfd/pcf50633/mbc.h
index 6e17619..4119579 100644
--- a/include/linux/mfd/pcf50633/mbc.h
+++ b/include/linux/mfd/pcf50633/mbc.h
@@ -128,7 +128,6 @@ enum pcf50633_reg_mbcs3 {
 int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma);
 
 int pcf50633_mbc_get_status(struct pcf50633 *);
-void pcf50633_mbc_set_status(struct pcf50633 *, int what, int status);
 
 #endif
 

