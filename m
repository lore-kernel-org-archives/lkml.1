Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYCaJMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYCaJMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYCaJIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:24 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54097 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbYCaJIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:22 -0400
Date: Mon, 31 Mar 2008 12:08:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] v4l2-int-device.c: add MODULE_LICENSE
Message-ID: <20080331090808.GQ28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that it's in an own module it needs a MODULE_LICENSE.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
211290b92395b7ad1797878a014ee251bf55010f diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/video/v4l2-int-device.c
index a545dca..0e45499 100644
--- a/drivers/media/video/v4l2-int-device.c
+++ b/drivers/media/video/v4l2-int-device.c
@@ -156,3 +156,5 @@ int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg)
 		find_ioctl(d->u.slave, cmd,
 			   (v4l2_int_ioctl_func *)no_such_ioctl_1))(d, arg);
 }
+
+MODULE_LICENSE("GPL");

