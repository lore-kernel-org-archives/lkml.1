Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZHSSfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZHSSfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZHSSfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:35:07 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:44491 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZHSSfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:35:07 -0400
X-Loopcount0: from 10.9.160.253
From: Mario Limonciello <Mario_Limonciello@Dell.com>
To: cezary.jackiewicz@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Mario Limonciello <Mario_Limonciello@Dell.com>
Subject: [PATCH 1/3] Add support for known Compal made Dell laptops
Date: Wed, 19 Aug 2009 13:35:27 -0500
Message-Id: <1250706927-10344-1-git-send-email-Mario_Limonciello@Dell.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following Dell laptops are known to have been manufacturer by Compal
and are supported by the compal-laptop platform driver
 - Mini 9
 - Mini 10
 - Mini 12
 - Mini 10v
 - Inspiron 11z

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
---
 drivers/platform/x86/compal-laptop.c |   46 ++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 11003bb..c1c8c03 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -311,6 +311,47 @@ static struct dmi_system_id __initdata compal_dmi_table[] = {
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
 
@@ -404,3 +445,8 @@ MODULE_ALIAS("dmi:*:rnIFL90:rvrREFERENCE:*");
 MODULE_ALIAS("dmi:*:rnIFL91:rvrIFT00:*");
 MODULE_ALIAS("dmi:*:rnJFL92:rvrIFT00:*");
 MODULE_ALIAS("dmi:*:rnIFT00:rvrIFT00:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron910:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1010:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1011:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1110:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1210:*");
-- 
1.6.3.3

