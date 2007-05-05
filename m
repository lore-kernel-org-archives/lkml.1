Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbXEEQya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbXEEQya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934006AbXEEQy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:54:29 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:42078 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933977AbXEEQy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:54:27 -0400
Message-id: <291686362220885823@wsc.cz>
In-reply-to: <248077021012417739@wsc.cz>
Subject: [PATCH 2/2] V4L2: videodev, allow debugging
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <video4linux-list@redhat.com>
Date: Sat,  5 May 2007 16:50:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

videodev, allow debugging

fix typo? in videodev.c to allow debugging

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 94b6ccaf1ca50632014202d3eeb99a0e23185ddb
tree 55e2ac37ca4e12846d851b863b620b154e9df500
parent a38d21f4b5d5029b0b083fe2651e78c7657fda3b
author Jiri Slaby <jirislaby@gmail.com> Sat, 05 May 2007 16:44:18 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 05 May 2007 16:44:18 +0200

 drivers/media/video/videodev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
index 5263b50..a3cef80 100644
--- a/drivers/media/video/videodev.c
+++ b/drivers/media/video/videodev.c
@@ -433,7 +433,7 @@ static int __video_do_ioctl(struct inode *inode, struct file *file,
 	int                  ret = -EINVAL;
 
 	if ( (vfd->debug & V4L2_DEBUG_IOCTL) &&
-				!(vfd->debug | V4L2_DEBUG_IOCTL_ARG)) {
+				!(vfd->debug & V4L2_DEBUG_IOCTL_ARG)) {
 		v4l_print_ioctl(vfd->name, cmd);
 	}
 
