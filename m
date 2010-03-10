Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0CJMSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:18:07 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:46611 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0CJMSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:18:05 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 07:18:04 EST
Message-ID: <4B978DD4.4080907@inf.tu-dresden.de>
Date: Wed, 10 Mar 2010 13:17:24 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100217 Shredder/3.0.3pre
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>, Matthew Garrett <mjg@redhat.com>,
       Evan McClain <evan.mcclain@gatech.edu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Subject: [PATCH] mbp_nvidia_bl: Add support for older MacBookPro and MacBook
 6,1.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should be applied after Evan McClain's patch.
It adds support for all remaining models not yet present in
Linus'/Richard Purdie's tree nor Evan McClain's patch to finally
complete the list.

Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
---
  drivers/video/backlight/mbp_nvidia_bl.c |   45 +++++++++++++++++++++++++++++++
  1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 9804ee9..3d1a277 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -184,6 +184,42 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
  	},
  	{
  		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 1,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro1,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 1,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro1,2"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 2,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 2,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,2"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
  		.ident		= "MacBookPro 3,1",
  		.matches	= {
  			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
@@ -238,6 +274,15 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
  	},
  	{
  		.callback	= mbp_dmi_match,
+		.ident		= "MacBook 6,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook6,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
  		.ident		= "MacBookAir 2,1",
  		.matches	= {
  			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-- 
1.6.3.3

