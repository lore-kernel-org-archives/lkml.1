Return-Path: <linux-kernel-owner+w=401wt.eu-S1764680AbXGQKM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764680AbXGQKM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 06:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXGQKMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 06:12:19 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:39051 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbXGQKMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 06:12:16 -0400
Date: Tue, 17 Jul 2007 14:11:39 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: airlied@linux.ie, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: drm: de-typedef fallout in sis
Message-ID: <20070717101139.GA11053@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/char/drm/sis_mm.o
drivers/char/drm/sis_mm.c: In function 'sis_fb_init':
drivers/char/drm/sis_mm.c:97: error: 'drm_sman_mm_t' undeclared (first use in this function)

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/char/drm/sis_mm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/drm/sis_mm.c
+++ b/drivers/char/drm/sis_mm.c
@@ -94,7 +94,7 @@ static int sis_fb_init(DRM_IOCTL_ARGS)
 	mutex_lock(&dev->struct_mutex);
 #if defined(CONFIG_FB_SIS)
 	{
-		drm_sman_mm_t sman_mm;
+		struct drm_sman_mm sman_mm;
 		sman_mm.private = (void *)0xFFFFFFFF;
 		sman_mm.allocate = sis_sman_mm_allocate;
 		sman_mm.free = sis_sman_mm_free;

