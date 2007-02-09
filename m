Return-Path: <linux-kernel-owner+w=401wt.eu-S1946648AbXBIQq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946648AbXBIQq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946638AbXBIQig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:38:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51666 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946635AbXBIQiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:21 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] usbvision missing __user
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYlQ-0006lO-Kc@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/usbvision/usbvision-video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 7243337..bdd6301 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1072,7 +1072,7 @@ static int usbvision_v4l2_ioctl(struct inode *inode, struct file *file,
 }
 
 
-static ssize_t usbvision_v4l2_read(struct file *file, char *buf,
+static ssize_t usbvision_v4l2_read(struct file *file, char __user *buf,
 		      size_t count, loff_t *ppos)
 {
 	struct video_device *dev = video_devdata(file);
-- 
1.5.0-rc2.GIT


