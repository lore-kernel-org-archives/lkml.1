Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbXH0VOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbXH0VOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXH0VNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:47 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1141 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbXH0VNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:47 -0400
Message-Id: <20070827211343.700523000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:53 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 03/23] drm_auth.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=drm_auth.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_auth.c | 5835 -> 5802 (-33 bytes)
 drivers/char/drm/drm_auth.o | 104968 -> 104860 (-108 bytes)

 drivers/char/drm/drm_auth.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_auth.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_auth.c
@@ -78,12 +78,11 @@ static int drm_add_magic(struct drm_devi

 	DRM_DEBUG("%d\n", magic);

-	entry = drm_alloc(sizeof(*entry), DRM_MEM_MAGIC);
+	entry = drm_zalloc(sizeof(*entry), DRM_MEM_MAGIC);
 	if (!entry)
 		return -ENOMEM;
-	memset(entry, 0, sizeof(*entry));
-	entry->priv = priv;

+	entry->priv = priv;
 	entry->hash_item.key = (unsigned long)magic;
 	mutex_lock(&dev->struct_mutex);
 	drm_ht_insert_item(&dev->magiclist, &entry->hash_item);

--
