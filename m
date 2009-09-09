Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZIIJUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZIIJUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZIIJUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:20:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57481 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZIIJUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:20:39 -0400
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [PATCH] UBUNTU: [Upstream] Input: Add keyboard quirk for Samsung R59P/R60P/R61P laptops
Date: Wed,  9 Sep 2009 17:20:35 +0800
Message-Id: <1252488035-20118-1-git-send-email-keng-yu.lin@canonical.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OriginalAuthor: Moiseev Vladimir <cdb@linkycat.com>, Alexander Huhlaev <sancheolz@gmail.com>
BugLink: http://bugs.launchpad.net/bugs/253874

Add quirk for Samsung R59P/R60P/R61P to make the hotkeys work

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
---
 drivers/input/keyboard/atkbd.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 8066924..941f845 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1615,6 +1615,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 		.driver_data = atkbd_samsung_forced_release_keys,
 	},
 	{
+		.ident = "Samsung R59P/R60P/R61P",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "R59P/R60P/R61P"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_samsung_keymap_fixup,
+	},
+	{
 		.ident = "Fujitsu Amilo PA 1510",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-- 
1.6.0.4

