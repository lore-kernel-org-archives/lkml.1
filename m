Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab0CJAnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:43:46 -0500
Received: from deliverator10.gatech.edu ([130.207.160.100]:48771 "EHLO
	deliverator10.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab0CJAnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:43:43 -0500
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 19:43:43 EST
From: Evan McClain <evan.mcclain@gatech.edu>
To: rpurdie@rpsys.net, akpm@linux-foundation.org, schwalbe@inf.tu-dresden.de,
       mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, Evan McClain <evan.mcclain@gatech.edu>
Subject: [PATCH] backlight: mbp_nvidia_bl - add five more MacBook variants
Date: Tue,  9 Mar 2010 19:20:58 -0500
Message-Id: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the MacBook 1,1 2,1 3,1 4,1 and 4,2 to the DMI tables.

Signed-off-by: Evan McClain <evan.mcclain@gatech.edu>
---
 drivers/video/backlight/mbp_nvidia_bl.c |   45 +++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 2e78b07..9804ee9 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -139,6 +139,51 @@ static int mbp_dmi_match(const struct dmi_system_id *id)
 static const struct dmi_system_id __initdata mbp_device_table[] = {
 	{
 		.callback	= mbp_dmi_match,
+		.ident		= "MacBook 1,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook1,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBook 2,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook2,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBook 3,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook3,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBook 4,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook4,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBook 4,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook4,2"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookPro 3,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-- 
1.7.0

