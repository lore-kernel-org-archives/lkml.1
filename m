Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0BNK51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:57:27 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:36235 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab0BNK50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:57:26 -0500
From: Erik Andren <erik.andren@gmail.com>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Erik Andren <erik.andren@gmail.com>
Subject: [PATCH 1/1] platform/x86/dell-laptop: Add another Dell laptop to the DMI whitelist
Date: Sun, 14 Feb 2010 11:54:57 +0100
Message-Id: <1266144897-2681-1-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.253.14.98
X-Scan-Result: No virus found in message 1Ngc8L-0004l5-C7.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Ngc8L-0004l5-C7 65285a4d945703f26deaa8ef7b3b2c7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Latitude C640 has another variation of dell in its DMI vendor entry.
Add it to the whitelist in order to enjoy the sweet fruits of software backlight toggling.

Signed-off-by: Erik Andren <erik.andren@gmail.com>
---
 drivers/platform/x86/dell-laptop.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 3780994..b5246f1 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -79,6 +79,13 @@ static const struct dmi_system_id __initdata dell_device_table[] = {
 			DMI_MATCH(DMI_CHASSIS_TYPE, "8"),
 		},
 	},
+	{
+		.ident = "Dell Computer Corporation",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.3.3

