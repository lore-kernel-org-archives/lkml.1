Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbXHFUO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbXHFUO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760994AbXHFUOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:14:03 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4553 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbXHFUOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:14:00 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Mauro Chehab <mchehab@infradead.org>
Subject: [PATCH] drivers/media/video/zoran_driver.c: fix memset in ioctl
Date: Mon, 6 Aug 2007 22:13:59 +0200
User-Agent: KMail/1.9.5
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708062213.59257.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Looks like memset() is zeroing wrong nr of bytes.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/media/video/zoran_driver.c | 117098 -> 117099 (+1 bytes)
 drivers/media/video/zoran_driver.o | 206096 -> 205952 (-144 bytes)

 drivers/media/video/zoran_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc1-mm2-a/drivers/media/video/zoran_driver.c	2007-08-01 08:43:47.000000000 +0200
+++ linux-2.6.23-rc1-mm2-b/drivers/media/video/zoran_driver.c	2007-08-06 20:36:28.000000000 +0200
@@ -3196,7 +3196,7 @@ zoran_do_ioctl (struct inode *inode,
 			"%s: VIDIOC_QUERYBUF - index=%d, type=%d\n",
 			ZR_DEVNAME(zr), buf->index, buf->type);

-		memset(buf, 0, sizeof(buf));
+		memset(buf, 0, sizeof(*buf));
 		buf->type = type;
 		buf->index = index;

