Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYGUTfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYGUTfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYGUTdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:33:55 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42249 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbYGUTdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:33:54 -0400
Date: Mon, 21 Jul 2008 22:33:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make cx25840_debug static
Message-ID: <20080721193348.GF14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cx25840_debug can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/cx25840/cx25840-core.c |    2 +-
 drivers/media/video/cx25840/cx25840-core.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

5684f477ccc0e951f0bc0271cff9a9330f4c3b7f 
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index e7bf4f4..209d3bc 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -50,7 +50,7 @@ MODULE_LICENSE("GPL");
 
 static unsigned short normal_i2c[] = { 0x88 >> 1, I2C_CLIENT_END };
 
-int cx25840_debug;
+static int cx25840_debug;
 
 module_param_named(debug,cx25840_debug, int, 0644);
 
diff --git a/drivers/media/video/cx25840/cx25840-core.h b/drivers/media/video/cx25840/cx25840-core.h
index 72916ba..b87337e 100644
--- a/drivers/media/video/cx25840/cx25840-core.h
+++ b/drivers/media/video/cx25840/cx25840-core.h
@@ -24,8 +24,6 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 
-extern int cx25840_debug;
-
 /* ENABLE_PVR150_WORKAROUND activates a workaround for a hardware bug that is
    present in Hauppauge PVR-150 (and possibly PVR-500) cards that have
    certain NTSC tuners (tveeprom tuner model numbers 85, 99 and 112). The

