Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXJXQge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXJXQge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbXJXQY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60927 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759321AbXJXQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:26 -0400
Date: Wed, 24 Oct 2007 18:24:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jordan Crouse <jordan.crouse@amd.com>, Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make video/geode/lxfb_core.c:geode_modedb[] static
Message-ID: <20071024162456.GR30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

geode_modedb[] can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
145d02fc23c7bea85aa3c934e0ceef78d0101e0a 
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 583185f..eb6b881 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -34,7 +34,7 @@ static int fbsize;
  * we try to make it something sane - 640x480-60 is sane
  */
 
-const struct fb_videomode geode_modedb[] __initdata = {
+static const struct fb_videomode geode_modedb[] __initdata = {
 	/* 640x480-60 */
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,

