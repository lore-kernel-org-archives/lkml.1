Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZBEHUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZBEHUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZBEHUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:20:33 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:25825 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZBEHUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:20:32 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82343850"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Uwe Kleine-Koenig <ukleinek@strlen.de>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] video/framebuffer: move the probe func into .devinit.text in Blackfin LCD driver
Date: Thu,  5 Feb 2009 15:22:07 +0800
Message-Id: <1233818527-6688-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-Koenig <ukleinek@strlen.de>

Signed-off-by: Uwe Kleine-Koenig <ukleinek@strlen.de>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/video/bfin-t350mcqb-fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 2a423d3..90cfdda 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -447,7 +447,7 @@ static irqreturn_t bfin_t350mcqb_irq_error(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __init bfin_t350mcqb_probe(struct platform_device *pdev)
+static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 {
 	struct bfin_t350mcqbfb_info *info;
 	struct fb_info *fbinfo;
-- 
1.5.6.3
