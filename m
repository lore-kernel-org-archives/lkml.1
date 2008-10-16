Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYJPTPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYJPTPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYJPTPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:15:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbYJPTPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:15:38 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Adam Jackson <ajax@redhat.com>
Subject: [PATCH] sony-laptop: newline-terminate the printk for backlight change failure
Date: Thu, 16 Oct 2008 15:15:35 -0400
Message-Id: <1224184535-30764-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/sony-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index 60775be..5a97d3a 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -970,7 +970,7 @@ static int sony_nc_resume(struct acpi_device *device)
 	/* set the last requested brightness level */
 	if (sony_backlight_device &&
 			!sony_backlight_update_status(sony_backlight_device))
-		printk(KERN_WARNING DRV_PFX "unable to restore brightness level");
+		printk(KERN_WARNING DRV_PFX "unable to restore brightness level\n");
 
 	/* re-initialize models with specific requirements */
 	dmi_check_system(sony_nc_ids);
-- 
1.6.0.1

