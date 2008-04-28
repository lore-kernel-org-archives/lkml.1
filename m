Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbYD1Pot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbYD1Pot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbYD1Pjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:46 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35025 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964971AbYD1Pjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:45 -0400
Date: Mon, 28 Apr 2008 18:39:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make em28xx_capture_start() static
Message-ID: <20080428153912.GM2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

em28xx_capture_start() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/em28xx/em28xx-core.c |    2 +-
 drivers/media/video/em28xx/em28xx.h      |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

bd1af5dee0801229ebd017be2fda03b25b4cdebb diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 5d837c1..c80a665 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -356,7 +356,7 @@ int em28xx_colorlevels_set_default(struct em28xx *dev)
 	return em28xx_write_regs(dev, EM28XX_R1A_BOFFSET, "\x00", 1);
 }
 
-int em28xx_capture_start(struct em28xx *dev, int start)
+static int em28xx_capture_start(struct em28xx *dev, int start)
 {
 	int rc;
 	/* FIXME: which is the best order? */
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 002f170..e1430a9 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -450,7 +450,6 @@ int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len);
 int em28xx_audio_analog_set(struct em28xx *dev);
 
 int em28xx_colorlevels_set_default(struct em28xx *dev);
-int em28xx_capture_start(struct em28xx *dev, int start);
 int em28xx_outfmt_set_yuv422(struct em28xx *dev);
 int em28xx_resolution_set(struct em28xx *dev);
 int em28xx_set_alternate(struct em28xx *dev);

