Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYA3JDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYA3JDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbYA3JB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:01:56 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:21161 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbYA3JBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:01:54 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47622461"
From: Bryan Wu <bryan.wu@analog.com>
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/3] [Video] BF54x LQ043 Framebuffer driver: fix bug NULL for gpio_request label is not allowed
Date: Wed, 30 Jan 2008 17:01:49 +0800
Message-Id: <1201683711-24948-2-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201683711-24948-1-git-send-email-bryan.wu@analog.com>
References: <1201683711-24948-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/video/bf54x-lq043fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index c8e7427..e9f5989 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -241,7 +241,7 @@ static int request_ports(struct bfin_bf54xfb_info *fbi)
 	u16 eppi_req_18[] = EPPI0_18;
 	u16 disp = fbi->mach_info->disp;
 
-	if (gpio_request(disp, NULL)) {
+	if (gpio_request(disp, DRIVER_NAME)) {
 		printk(KERN_ERR "Requesting GPIO %d faild\n", disp);
 		return -EFAULT;
 	}
-- 
1.5.3.4
