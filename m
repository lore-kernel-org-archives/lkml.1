Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120Ab0BZPXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:23:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965110Ab0BZPXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:23:22 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Erik Andren <erik.andren@gmail.com>
Subject: [PATCH 12/14] dell-laptop: Add another Dell laptop to the DMI whitelist
Date: Fri, 26 Feb 2010 10:18:45 -0500
Message-Id: <1267197527-18062-13-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Andren <erik.andren@gmail.com>

The Latitude C640 has another variation of dell in its DMI vendor entry.
Add it to the whitelist in order to enjoy the sweet fruits of software
backlight toggling.

Signed-off-by: Erik Andren <erik.andren@gmail.com>
---
 drivers/platform/x86/dell-laptop.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 04b2ddb..b7f4d27 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -81,6 +81,13 @@ static const struct dmi_system_id __initdata dell_device_table[] = {
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
 
@@ -609,3 +616,4 @@ MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Dell laptop driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("dmi:*svnDellInc.:*:ct8:*");
+MODULE_ALIAS("dmi:*svnDellComputerCorporation.:*:ct8:*");
-- 
1.6.6.1

