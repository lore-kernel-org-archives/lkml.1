Return-Path: <linux-kernel-owner+w=401wt.eu-S1764463AbXH0VYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764463AbXH0VYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760220AbXH0VOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:15 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1170 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759844AbXH0VOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:12 -0400
Message-Id: <20070827211402.604442000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:13 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 23/23] via_map.c: drm_calloc to drm_zalloc
Content-Disposition: inline; filename=via_map.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/via_map.c | 3449 -> 3439 (-10 bytes)
 drivers/char/drm/via_map.o | 110028 -> 110488 (+460 bytes)

 drivers/char/drm/via_map.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/via_map.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/via_map.c
@@ -100,8 +100,8 @@ int via_driver_load(struct drm_device *d
 	drm_via_private_t *dev_priv;
 	int ret = 0;

-	dev_priv = drm_calloc(1, sizeof(drm_via_private_t), DRM_MEM_DRIVER);
-	if (dev_priv == NULL)
+	dev_priv = drm_zalloc(sizeof(drm_via_private_t), DRM_MEM_DRIVER);
+	if (!dev_priv)
 		return DRM_ERR(ENOMEM);

 	dev->dev_private = (void *)dev_priv;

--
