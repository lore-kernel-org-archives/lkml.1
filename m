Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYJYPsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYJYPsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 11:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYJYPsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 11:48:39 -0400
Received: from smtp2.iwebs.cz ([78.156.136.15]:33329 "EHLO smtp2.iwebs.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbYJYPsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 11:48:38 -0400
X-Greylist: delayed 1256 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2008 11:48:38 EDT
Message-ID: <49033AE4.3000502@gmail.com>
Date: Sat, 25 Oct 2008 17:27:32 +0200
From: =?UTF-8?B?SmnFmcOtIE1vcmF2ZWM=?= <jim.lkml@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080928)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Typo in drivers/video/modedb.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I viewed drivers/video/modedb.c, so I accidentally noticed a very old typo already contained in 2.6.0.
This typo remained unheeded at least 5 years. Clear evidence of its importance.  ;) 
---
diff -Nupr a/drivers/video/modedb.c b/drivers/video/modedb.c
--- a/drivers/video/modedb.c	2008-10-25 16:18:00.000000000 +0200
+++ b/drivers/video/modedb.c	2008-10-25 16:18:10.000000000 +0200
@@ -329,7 +329,7 @@ const struct fb_videomode vesa_modes[] =
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 	/* 17 1152x864-75 VESA */
-	{ NULL, 75, 1153, 864, 9259, 256, 64, 32, 1, 128, 3,
+	{ NULL, 75, 1152, 864, 9259, 256, 64, 32, 1, 128, 3,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 	/* 18 1280x960-60 VESA */
---
