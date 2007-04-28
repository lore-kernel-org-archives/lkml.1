Return-Path: <linux-kernel-owner+w=401wt.eu-S1161158AbXD1TUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158AbXD1TUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030772AbXD1TUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:20:09 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37508 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161029AbXD1TTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:19:54 -0400
Date: Sat, 28 Apr 2007 21:20:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: michael@mihu.de, mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for saa7146_video_do_ioctl()
Message-ID: <20070428192005.GT3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for saa7146_video_do_ioctl() in 
include/media/saa7146_vv.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/common/saa7146_fops.c |    1 -
 include/media/saa7146_vv.h          |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21-rc7-mm2/include/media/saa7146_vv.h.old	2007-04-28 15:04:39.000000000 +0200
+++ linux-2.6.21-rc7-mm2/include/media/saa7146_vv.h	2007-04-28 15:05:11.000000000 +0200
@@ -216,6 +216,8 @@
 extern struct saa7146_use_ops saa7146_video_uops;
 int saa7146_start_preview(struct saa7146_fh *fh);
 int saa7146_stop_preview(struct saa7146_fh *fh);
+int saa7146_video_do_ioctl(struct inode *inode, struct file *file,
+			   unsigned int cmd, void *arg);
 
 /* from saa7146_vbi.c */
 extern struct saa7146_use_ops saa7146_vbi_uops;
--- linux-2.6.21-rc7-mm2/drivers/media/common/saa7146_fops.c.old	2007-04-28 15:05:32.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/media/common/saa7146_fops.c	2007-04-28 15:05:44.000000000 +0200
@@ -307,7 +307,6 @@
 	return 0;
 }
 
-int saa7146_video_do_ioctl(struct inode *inode, struct file *file, unsigned int cmd, void *arg);
 static int fops_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 /*

