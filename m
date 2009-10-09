Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbZJIJQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbZJIJQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbZJIJQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:16:48 -0400
Received: from mail.atmel.fr ([81.80.104.162]:36882 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757692AbZJIJQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:16:48 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: jkosina@suse.cz
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Claudio Scordino <claudio@evidence.eu.com>
Subject: [PATCH TRIVIAL] atmel_lcdfb.c: Fix sinfo->irqbase from %lu to %d in dev_info().
Date: Fri,  9 Oct 2009 12:20:21 +0200
Message-Id: <1255083621-25147-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Scordino <claudio@evidence.eu.com>

This patch fixes a type mismatch when calling dev_info() in the
atmel_lcdfb.c driver.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/video/atmel_lcdfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 2830ffd..317afab 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -959,7 +959,7 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(1);
 
-	dev_info(dev, "fb%d: Atmel LCDC at 0x%08lx (mapped at %p), irq %lu\n",
+	dev_info(dev, "fb%d: Atmel LCDC at 0x%08lx (mapped at %p), irq %d\n",
 		       info->node, info->fix.mmio_start, sinfo->mmio, sinfo->irq_base);
 
 	return 0;
-- 
1.5.6.5

