Return-Path: <linux-kernel-owner+w=401wt.eu-S1764721AbXH0VYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721AbXH0VYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbXH0VOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:16 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1173 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618AbXH0VOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:11 -0400
Message-Id: <20070827211401.804376000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:12 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 22/23] sis_drv.c: drm_calloc to drm_zalloc
Content-Disposition: inline; filename=sis_drv.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/sis_drv.c | 3249 -> 3239 (-10 bytes)
 drivers/char/drm/sis_drv.o | 104756 -> 105460 (+704 bytes)

 drivers/char/drm/sis_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/sis_drv.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/sis_drv.c
@@ -40,8 +40,8 @@ static int sis_driver_load(struct drm_de
 	drm_sis_private_t *dev_priv;
 	int ret;

-	dev_priv = drm_calloc(1, sizeof(drm_sis_private_t), DRM_MEM_DRIVER);
-	if (dev_priv == NULL)
+	dev_priv = drm_zalloc(sizeof(drm_sis_private_t), DRM_MEM_DRIVER);
+	if (!dev_priv)
 		return DRM_ERR(ENOMEM);

 	dev->dev_private = (void *)dev_priv;

--
