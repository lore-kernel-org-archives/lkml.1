Return-Path: <linux-kernel-owner+w=401wt.eu-S1763951AbXH0VW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763951AbXH0VW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbXH0VOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:08 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1173 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbXH0VOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:07 -0400
Message-Id: <20070827211358.413481000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:09 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 19/23] radeon_cp.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=radeon_cp.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/radeon_cp.c | 62519 -> 62461 (-58 bytes)
 drivers/char/drm/radeon_cp.o | 160564 -> 160596 (+32 bytes)

 drivers/char/drm/radeon_cp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/radeon_cp.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/radeon_cp.c
@@ -2239,11 +2239,10 @@ int radeon_driver_load(struct drm_device
 	drm_radeon_private_t *dev_priv;
 	int ret = 0;

-	dev_priv = drm_alloc(sizeof(drm_radeon_private_t), DRM_MEM_DRIVER);
-	if (dev_priv == NULL)
+	dev_priv = drm_zalloc(sizeof(drm_radeon_private_t), DRM_MEM_DRIVER);
+	if (!dev_priv)
 		return DRM_ERR(ENOMEM);

-	memset(dev_priv, 0, sizeof(drm_radeon_private_t));
 	dev->dev_private = (void *)dev_priv;
 	dev_priv->flags = flags;

--
