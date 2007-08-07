Return-Path: <linux-kernel-owner+w=401wt.eu-S1765408AbXHGBcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765408AbXHGBcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 21:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbXHGBcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 21:32:41 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:1595 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXHGBck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 21:32:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=uAgw9E4Tbsd+Jae4qYAbu7LT6sJ+LkNyv7Fa7xX/DRKx0eRnwoNQ/jAPQT8XiNo2sK3kSbGx2bLmlhxESMYaZ3c2tTGngawBRkFRv7Q4MEXLuF7YkA85kc9ni7SaFtK/D3mTNdN2Sx45HLO8dV0j6erQoiijXtFxKTbxbixOZ14=
Date: Mon, 6 Aug 2007 21:32:33 -0400
From: Steven Walter <stevenrwalter@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org
Subject: [PATCH] V4L: Add additional ioctls to compat_ioctl32
Message-ID: <20070807013233.GA14202@dervierte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of these ioctls, I'm able to watch TV with a 32-bit version
of tvtime on x86_64
---
 drivers/media/video/compat_ioctl32.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/compat_ioctl32.c b/drivers/media/video/compat_ioctl32.c
index f065ad1..cefd138 100644
--- a/drivers/media/video/compat_ioctl32.c
+++ b/drivers/media/video/compat_ioctl32.c
@@ -848,6 +848,8 @@ long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOCSFREQ32:
 	case VIDIOCGAUDIO:
 	case VIDIOCSAUDIO:
+	case VIDIOCGVBIFMT:
+	case VIDIOCSVBIFMT:
 #endif
 	case VIDIOC_QUERYCAP:
 	case VIDIOC_ENUM_FMT:
@@ -874,7 +876,10 @@ long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_ENUMINPUT:
 	case VIDIOC_ENUMINPUT32:
 	case VIDIOC_G_CTRL:
+	case VIDIOC_S_CTRL:
 	case VIDIOC_S_CTRL32:
+	case VIDIOC_S_FREQUENCY:
+	case VIDIOC_G_FREQUENCY:
 	case VIDIOC_QUERYCTRL:
 	case VIDIOC_G_INPUT32:
 	case VIDIOC_S_INPUT32:
-- 
1.5.3.rc2


-- 
-Steven Walter <stevenrwalter@gmail.com>
"A human being should be able to change a diaper, plan an invasion,
butcher a hog, conn a ship, design a building, write a sonnet, balance
accounts, build a wall, set a bone, comfort the dying, take orders,
give orders, cooperate, act alone, solve equations, analyze a new
problem, pitch manure, program a computer, cook a tasty meal, fight
efficiently, die gallantly. Specialization is for insects."
   -Robert Heinlein
