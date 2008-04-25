Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYDYDaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYDYDaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYDYD3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:29:54 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:43800 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYDYD33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:29:29 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="52517690"
From: Bryan Wu <cooloney@kernel.org>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] BF54x Framebuffer Driver: drop request_irq cast
Date: Fri, 25 Apr 2008 11:29:05 +0800
Message-Id: <1209094146-19872-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209094146-19872-1-git-send-email-cooloney@kernel.org>
References: <1209094146-19872-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/video/bf54x-lq043fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index eefba3d..850212d 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -652,7 +652,7 @@ static int __init bfin_bf54x_probe(struct platform_device *pdev)
 		goto out7;
 	}
 
-	if (request_irq(info->irq, (void *)bfin_bf54x_irq_error, IRQF_DISABLED,
+	if (request_irq(info->irq, bfin_bf54x_irq_error, IRQF_DISABLED,
 			"PPI ERROR", info) < 0) {
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to request PPI ERROR IRQ\n");
-- 
1.5.5
