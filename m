Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbYC3Xaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbYC3Xaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYC3X3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:29:13 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54362 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757591AbYC3X3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:29:12 -0400
Date: Mon, 31 Mar 2008 02:28:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for zoran_device.c:zr36016_write()
Message-ID: <20080330232859.GB28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for zr36016_write() in 
drivers/media/video/zoran_card.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/zoran_card.h   |    2 ++
 drivers/media/video/zoran_device.c |    5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

b6d787f7215fc790d26d01be89a0358c9b430421 diff --git a/drivers/media/video/zoran_card.h b/drivers/media/video/zoran_card.h
index 8444ca0..1b5c417 100644
--- a/drivers/media/video/zoran_card.h
+++ b/drivers/media/video/zoran_card.h
@@ -50,4 +50,6 @@ extern int zoran_check_jpg_settings(struct zoran *zr,
 extern void zoran_open_init_params(struct zoran *zr);
 extern void zoran_vdev_release(struct video_device *vdev);
 
+void zr36016_write(struct videocodec *codec, u16 reg, u32 val);
+
 #endif				/* __ZORAN_CARD_H__ */
diff --git a/drivers/media/video/zoran_device.c b/drivers/media/video/zoran_device.c
index f97c206..f347fa5 100644
--- a/drivers/media/video/zoran_device.c
+++ b/drivers/media/video/zoran_device.c
@@ -927,11 +927,6 @@ count_reset_interrupt (struct zoran *zr)
 	return isr;
 }
 
-/* hack */
-extern void zr36016_write (struct videocodec *codec,
-			   u16                reg,
-			   u32                val);
-
 void
 jpeg_start (struct zoran *zr)
 {

