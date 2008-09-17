Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYIQSSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYIQSSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYIQSRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:17:53 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:32070 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbYIQSRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Khq2JNtUeZyEq6Oz8YcihzD5PIfz9C+2Du3al5atwTqR3mHcrTaMLuXaEfI1zqkPT8
         pJOFq4fbFxmjxHXabQ4Ak9iRxaX4dzW8Q+G0WnyLKtep85SA313Z+5K+g8Q6Twm37ov1
         Bd3Y0ydZd7hxHHrDHcXUc1u0hDsgjmD/LPEZ4=
Date: Wed, 17 Sep 2008 22:17:43 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: viro@zeniv.linux.org.uk, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] block: remove unused variables
Message-ID: <20080917181743.GC29966@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 block/compat_ioctl.c |    2 --
 block/ioctl.c        |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 504344d..ec2060f 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -582,8 +582,6 @@ static int compat_blk_trace_setup(struct block_device *bdev, char __user *arg)
 static int compat_blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned cmd, unsigned long arg)
 {
-	int ret;
-
 	switch (cmd) {
 	case HDIO_GET_UNMASKINTR:
 	case HDIO_GET_MULTCOUNT:
diff --git a/block/ioctl.c b/block/ioctl.c
index 0db89f9..9e84f36 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -268,7 +268,6 @@ static int blkdev_locked_ioctl(struct file *file, struct block_device *bdev,
 int blkdev_driver_ioctl(struct inode *inode, struct file *file,
 			struct gendisk *disk, unsigned cmd, unsigned long arg)
 {
-	int ret;
 	fmode_t mode = 0;
 	if (file) {
 		mode = file->f_mode;
