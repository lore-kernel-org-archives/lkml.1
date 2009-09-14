Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZINRtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZINRtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZINRtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:49:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47404 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZINRtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:49:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] fbdev: bfin-t350mcqb-fb: fix LCD dimensions
Date: Mon, 14 Sep 2009 13:49:09 -0400
Message-Id: <1252950549-9838-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252950549-9838-1-git-send-email-vapier@gentoo.org>
References: <1252950549-9838-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The height/width framebuffer members need to be set in millimeters so that
software can do proper scaling.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bfin-t350mcqb-fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 46cb07f..2549c53 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -487,8 +487,8 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 
 	fbinfo->var.nonstd = 0;
 	fbinfo->var.activate = FB_ACTIVATE_NOW;
-	fbinfo->var.height = -1;
-	fbinfo->var.width = -1;
+	fbinfo->var.height = 53;
+	fbinfo->var.width = 70;
 	fbinfo->var.accel_flags = 0;
 	fbinfo->var.vmode = FB_VMODE_NONINTERLACED;
 
-- 
1.6.4.2

