Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbXKTB6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbXKTB6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbXKTBt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:56 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2099 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780AbXKTBtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:14 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "LinuxTV.org Project" <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Stelian Pop <stelian@popies.net>, video4linux-list@redhat.com
Subject: [PATCH 25/59] drivers/media/video: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:17 -0800
Message-Id: <1195523331-15303-26-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-25-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
 <1195523331-15303-25-git-send-email-joe@perches.com>
Message-Id: <8cdb362d494c702f6f0cf095e8e24435550bf5ce.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/cx25840/cx25840-vbi.c   |    2 +-
 drivers/media/video/meye.c                  |    2 +-
 drivers/media/video/saa7134/saa7134-input.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-vbi.c b/drivers/media/video/cx25840/cx25840-vbi.c
index ced13fe..d2949e5 100644
--- a/drivers/media/video/cx25840/cx25840-vbi.c
+++ b/drivers/media/video/cx25840/cx25840-vbi.c
@@ -180,7 +180,7 @@ void cx25840_vbi_setup(struct i2c_client *client)
 						fsc/1000000,fsc%1000000);
 
 		v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, "
-			"vblank %i , vactive %i, vblank656 %i, src_dec %i,"
+			"vblank %i , vactive %i, vblank656 %i, src_dec %i, "
 			"burst 0x%02x, luma_lpf %i, uv_lpf %i, comb 0x%02x,"
 			" sc 0x%06x\n",
 			hblank, hactive, vblank, vactive, vblank656,
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index c311632..3d51fa0 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -2023,7 +2023,7 @@ static int __init meye_init(void)
 	if (gbufsize < 0 || gbufsize > MEYE_MAX_BUFSIZE)
 		gbufsize = MEYE_MAX_BUFSIZE;
 	gbufsize = PAGE_ALIGN(gbufsize);
-	printk(KERN_INFO "meye: using %d buffers with %dk (%dk total)"
+	printk(KERN_INFO "meye: using %d buffers with %dk (%dk total) "
 			 "for capture\n",
 			 gbuffers,
 			 gbufsize / 1024, gbuffers * gbufsize / 1024);
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 3abaa1b..a485185 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -49,7 +49,7 @@ module_param(repeat_delay, int, 0644);
 MODULE_PARM_DESC(repeat_delay, "delay before key repeat started");
 static int repeat_period = 33;
 module_param(repeat_period, int, 0644);
-MODULE_PARM_DESC(repeat_period, "repeat period between"
+MODULE_PARM_DESC(repeat_period, "repeat period between "
     "keypresses when key is down");
 
 #define dprintk(fmt, arg...)	if (ir_debug) \
-- 
1.5.3.5.652.gf192c

