Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbYBMVig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbYBMVig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763534AbYBMVa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:26 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55685 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608AbYBMVaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:22 -0500
Date: Wed, 13 Feb 2008 23:30:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>, toshiba_acpi@memebeam.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] thinkpad_acpi.c: make 2 functions static
Message-ID: <20080213213006.GV3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_patch_makes_the_needlessly_global_hotkey_wakeup_reason_notify_change_and_hotkey_wakeup_hotunplug_complete_notify_change_static

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

;-)

da7d9b1a1d74ba5265d02e316a215540fe2daf19 diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 7ba1aca..e2c7edd 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -1689,7 +1689,7 @@ static ssize_t hotkey_wakeup_reason_show(struct device *dev,
 static struct device_attribute dev_attr_hotkey_wakeup_reason =
 	__ATTR(wakeup_reason, S_IRUGO, hotkey_wakeup_reason_show, NULL);
 
-void hotkey_wakeup_reason_notify_change(void)
+static void hotkey_wakeup_reason_notify_change(void)
 {
 	if (tp_features.hotkey_mask)
 		sysfs_notify(&tpacpi_pdev->dev.kobj, NULL,
@@ -1708,7 +1708,7 @@ static struct device_attribute dev_attr_hotkey_wakeup_hotunplug_complete =
 	__ATTR(wakeup_hotunplug_complete, S_IRUGO,
 	       hotkey_wakeup_hotunplug_complete_show, NULL);
 
-void hotkey_wakeup_hotunplug_complete_notify_change(void)
+static void hotkey_wakeup_hotunplug_complete_notify_change(void)
 {
 	if (tp_features.hotkey_mask)
 		sysfs_notify(&tpacpi_pdev->dev.kobj, NULL,

