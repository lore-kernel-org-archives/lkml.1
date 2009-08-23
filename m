Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbZHWPTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbZHWPTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 11:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933689AbZHWPTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 11:19:45 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:52312 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933694AbZHWPTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 11:19:44 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] video: mbp_nvidia_bl: add support for MacBookAir 1,1
Date: Sun, 23 Aug 2009 17:18:04 +0200
Message-Id: <1251040684-10399-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1MfEqz-0000DZ-9Y.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1MfEqz-0000DZ-9Y cb88242c29f8bfde61675d51d3354440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds LCD backlight support for the Intel GMA965
found in the MacBookAir 1,1.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/video/backlight/mbp_nvidia_bl.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 3bb4c0a..9fc7a53 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -166,6 +166,15 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
 	},
 	{
 		.callback	= mbp_dmi_match,
+		.ident		= "MacBookAir 1,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir1,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBook 5,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-- 
1.6.3.3

