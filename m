Return-Path: <linux-kernel-owner+w=401wt.eu-S1761231AbYBSGMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231AbYBSGMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYBSGMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:12:36 -0500
Received: from qb-out-0506.google.com ([72.14.204.235]:16960 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYBSGMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:12:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hLfsnU4VPry8PCDbKlCDLfmbLuphW7BQsw5bvbus+DVYtaRphUUj6aI7k3TeiUEjb3ssZfxoXD6QYspePR+ZUsMrAVKS5mhlbYUwv0bqEfwSDdunthU/s6BNhPMyCRyXgEG4Sm1xABVVvVyRm/MrDpch0SQhQirXBo++sLDLjFY=
Subject: [PATCH] bttv: struct member initialized twice
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 22:12:41 -0800
Message-Id: <1203401561.7766.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes sparse warning:
drivers/media/video/bt8xx/bttv-driver.c:3391:3: warning: Initializer entry defined twice
drivers/media/video/bt8xx/bttv-driver.c:3392:3:   also defined here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/video/bt8xx/bttv-driver.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 5404fcc..a080c14 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3389,7 +3389,6 @@ static struct video_device bttv_video_template =
 	.vidiocgmbuf                    = vidiocgmbuf,
 #endif
 	.vidioc_g_crop                  = bttv_g_crop,
-	.vidioc_g_crop                  = bttv_g_crop,
 	.vidioc_s_crop                  = bttv_s_crop,
 	.vidioc_g_fbuf                  = bttv_g_fbuf,
 	.vidioc_s_fbuf                  = bttv_s_fbuf,
-- 
1.5.4.2.200.g99e75



