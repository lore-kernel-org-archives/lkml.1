Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZLAXlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZLAXlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZLAXlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:41:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:40049 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754704AbZLAXlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:41:31 -0500
X-Authenticated: #2813124
X-Provags-ID: V01U2FsdGVkX19gVT8dBB5gAfVmDrVYX9tlMqR3/b6b3TO0A299c0
	ViSa+neeadTB3R
Subject: [PATCH] mbp_nvidia_bl: add two more MacBookPro variants
From: Daniel Ritz <daniel.ritz@gmx.ch>
To: Richard Purdie <rpurdie@rpsys.net>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 00:41:31 +0100
Message-ID: <1259710891.13720.12.camel@MacRitz2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the MacBookPro 5,3 and 5,4 to the DMI tables.

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>

---
 drivers/video/backlight/mbp_nvidia_bl.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 9edb8d7..6335b14 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -220,6 +220,24 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
 	},
 	{
 		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 5,3",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,3"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 5,4",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,4"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookPro 5,5",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-- 
1.6.3.3



