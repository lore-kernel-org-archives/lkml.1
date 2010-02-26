Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056Ab0BZPTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:19:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017Ab0BZPTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:07 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Mario Limonciello <Mario_Limonciello@Dell.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Matthew Garrett <mjg@redhat.com>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Subject: [PATCH 02/14] compal-laptop: Add support for known Compal made Dell laptops
Date: Fri, 26 Feb 2010 10:18:35 -0500
Message-Id: <1267197527-18062-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mario Limonciello <Mario_Limonciello@Dell.com>

The following Dell laptops are known to have been manufacturer by Compal
and are supported by the compal-laptop platform driver
 - Mini 9
 - Mini 10
 - Mini 12
 - Mini 10v
 - Inspiron 11z

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
---
 drivers/platform/x86/compal-laptop.c |   46 ++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 1a387e7..c78d254 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -310,6 +310,47 @@ static struct dmi_system_id __initdata compal_dmi_table[] = {
 		},
 		.callback = dmi_check_cb
 	},
+	{
+		.ident = "Dell Mini 9",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 910"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "Dell Mini 10",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1010"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "Dell Mini 10v",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1011"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "Dell Inspiron 11z",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1110"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "Dell Mini 12",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1210"),
+		},
+		.callback = dmi_check_cb
+	},
+
 	{ }
 };
 
@@ -403,3 +444,8 @@ MODULE_ALIAS("dmi:*:rnIFL90:rvrREFERENCE:*");
 MODULE_ALIAS("dmi:*:rnIFL91:rvrIFT00:*");
 MODULE_ALIAS("dmi:*:rnJFL92:rvrIFT00:*");
 MODULE_ALIAS("dmi:*:rnIFT00:rvrIFT00:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron910:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1010:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1011:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1110:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1210:*");
-- 
1.6.6.1

