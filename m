Return-Path: <linux-kernel-owner+w=401wt.eu-S1763404AbXH0VQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763404AbXH0VQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXH0VNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:50 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1144 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbXH0VNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:48 -0400
Message-Id: <20070827211346.576706000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:56 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 06/23] drm_drawable.c: drm_calloc to drm_zalloc
Content-Disposition: inline; filename=drm_drawable.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_drawable.c | 5425 -> 5422 (-3 bytes)
 drivers/char/drm/drm_drawable.o | 108201 -> 107765 (-436 bytes)

 drivers/char/drm/drm_drawable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_drawable.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_drawable.c
@@ -110,7 +110,7 @@ int drm_update_drawable_info(DRM_IOCTL_A

 	info = idr_find(&dev->drw_idr, update.handle);
 	if (!info) {
-		info = drm_calloc(1, sizeof(*info), DRM_MEM_BUFS);
+		info = drm_zalloc(sizeof(*info), DRM_MEM_BUFS);
 		if (!info)
 			return -ENOMEM;
 		if (IS_ERR(idr_replace(&dev->drw_idr, info, update.handle))) {

--
