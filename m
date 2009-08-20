Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbZHTLEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbZHTLEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZHTLEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:04:22 -0400
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:34928 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbZHTLEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:04:22 -0400
X-Greylist: delayed 1462 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 07:04:21 EDT
Message-ID: <4A8D27F4.3050204@inf.tu-dresden.de>
Date: Thu, 20 Aug 2009 12:39:48 +0200
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add support for new Apple machines.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the new Apple models MacBook 5,1,
MacBook Pro 5,1, MacBook Pro 5,2, MacBook Pro 5,5. It's just a
device table update.

This patch is against Linus Torvald's tree.

Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
---
 drivers/video/backlight/mbp_nvidia_bl.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 3bb4c0a..5f8c27f 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -175,6 +175,15 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
 	},
 	{
 		.callback	= mbp_dmi_match,
+		.ident		= "MacBook 5,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,2"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookAir 2,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
@@ -191,6 +200,24 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
 		},
 		.driver_data	= (void *)&nvidia_chipset_data,
 	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 5,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,2"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 5,5",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,5"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
 	{ }
 };

-- 
1.6.0.4

