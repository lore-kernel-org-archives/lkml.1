Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbYA3JDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbYA3JDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759446AbYA3JB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:01:57 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:32570 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969AbYA3JBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:01:55 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61203058"
From: Bryan Wu <bryan.wu@analog.com>
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/3] [Video] BF54x LQ043 Framebuffer driver: fix bug lcd_device_register API breakage
Date: Wed, 30 Jan 2008 17:01:50 +0800
Message-Id: <1201683711-24948-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201683711-24948-1-git-send-email-bryan.wu@analog.com>
References: <1201683711-24948-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/video/bf54x-lq043fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index e9f5989..6b76007 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -673,7 +673,7 @@ static int __init bfin_bf54x_probe(struct platform_device *pdev)
 				      &bfin_lq043fb_bl_ops);
 	bl_dev->props.max_brightness = 255;
 
-	lcd_dev = lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
+	lcd_dev = lcd_device_register(DRIVER_NAME, &pdev->dev, NULL, &bfin_lcd_ops);
 	lcd_dev->props.max_contrast = 255, printk(KERN_INFO "Done.\n");
 #endif
 
-- 
1.5.3.4
