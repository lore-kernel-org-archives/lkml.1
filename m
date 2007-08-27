Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbXH0VQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbXH0VQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXH0VNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:51 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1148 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbXH0VNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:50 -0400
Message-Id: <20070827211347.146259000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:57 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 07/23] drm_fops.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=drm_fops.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_fops.c | 11849 -> 11817 (-32 bytes)
 drivers/char/drm/drm_fops.o | 115963 -> 115177 (-786 bytes)

 drivers/char/drm/drm_fops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_fops.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_fops.c
@@ -236,11 +236,10 @@ static int drm_open_helper(struct inode

 	DRM_DEBUG("pid = %d, minor = %d\n", current->pid, minor);

-	priv = drm_alloc(sizeof(*priv), DRM_MEM_FILES);
+	priv = drm_zalloc(sizeof(*priv), DRM_MEM_FILES);
 	if (!priv)
 		return -ENOMEM;

-	memset(priv, 0, sizeof(*priv));
 	filp->private_data = priv;
 	priv->uid = current->euid;
 	priv->pid = current->pid;

--
