Return-Path: <linux-kernel-owner+w=401wt.eu-S934790AbZLGJ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbZLGJ05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbZLGJ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:26:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:42589 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607AbZLGJ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:26:56 -0500
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [2.6.31.stable] Input: atkbd - add force relese key quirk for Samsung R59P/R60P/R61P
Date: Mon,  7 Dec 2009 17:26:54 +0800
Message-Id: <1260178014-16741-1-git-send-email-keng-yu.lin@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OriginalAuthor:
    Moiseev Vladimir <cdb@linkycat.com>
    Alexander Huhlaev <sancheolz@gmail.com>

BugLink: http://bugs.launchpad.net/bugs/253874

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
---
 drivers/input/keyboard/atkbd.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 6c6a09b..abc314f 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1608,6 +1608,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 		.driver_data = atkbd_samsung_forced_release_keys,
 	},
 	{
+		.ident = "Samsung R59P/R60P/R61P",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "R59P/R60P/R61P"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
 		.ident = "Fujitsu Amilo PA 1510",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-- 
1.6.3.3

