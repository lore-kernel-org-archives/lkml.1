Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbYC2DNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbYC2DNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbYC2DKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:10:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58351 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292AbYC2DKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:10:49 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] zr364xx __user annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRSy-00031L-M1@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:10:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/zr364xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index 1b44784..04949c8 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -390,7 +390,7 @@ static int read_frame(struct zr364xx_camera *cam, int framenum)
 }
 
 
-static ssize_t zr364xx_read(struct file *file, char *buf, size_t cnt,
+static ssize_t zr364xx_read(struct file *file, char __user *buf, size_t cnt,
 			    loff_t * ppos)
 {
 	unsigned long count = cnt;
-- 
1.5.3.GIT


