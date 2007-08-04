Return-Path: <linux-kernel-owner+w=401wt.eu-S1764694AbXHDNDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764694AbXHDNDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbXHDNDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:03:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60870 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756725AbXHDNDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:03:01 -0400
Date: Sat, 4 Aug 2007 15:02:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jordan Crouse <jordan.crouse@amd.com>, Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/video/geode/lxfb_core.c: cleanups
Message-ID: <20070804130242.GD3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This pacth contains the following cleanups:
- make the needlessly global geode_modedb[] static
- lxfb_setup(): remove an unused variable

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/video/geode/lxfb_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

6ff33bdabb002b71b60258da40b3021b0d0a1ee2 
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 5e30b40..2932863 100644
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
@@ -561,8 +561,6 @@ static struct pci_driver lxfb_driver = {
 #ifndef MODULE
 static int __init lxfb_setup(char *options)
 {
-	char *opt;
-
 	if (!options || !*options)
 		return 0;
 

