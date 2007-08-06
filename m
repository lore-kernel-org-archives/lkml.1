Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbXHFUM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbXHFUM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbXHFUMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:12:22 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4546 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbXHFUMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:12:21 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] drivers/media/video/videodev.c: memset fix
Date: Mon, 6 Aug 2007 22:12:20 +0200
User-Agent: KMail/1.9.5
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708062212.20509.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Looks like memset() is zeroing wrong nr of bytes.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/media/video/videodev.c | 46097 -> 46100 (+3 bytes)
 drivers/media/video/videodev.o | 165109 -> 165209 (+100 bytes)

 drivers/media/video/videodev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc1-mm2-a/drivers/media/video/videodev.c	2007-08-01 08:43:47.000000000 +0200
+++ linux-2.6.23-rc1-mm2-b/drivers/media/video/videodev.c	2007-08-06 20:37:46.000000000 +0200
@@ -448,7 +448,7 @@ static int __video_do_ioctl(struct inode
 	if (cmd == VIDIOCGMBUF) {
 		struct video_mbuf *p=arg;

-		memset(p,0,sizeof(p));
+		memset(p, 0, sizeof(*p));

 		if (!vfd->vidiocgmbuf)
 			return ret;
