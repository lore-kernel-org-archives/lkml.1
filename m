Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbXH0VSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbXH0VSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbXH0VN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:57 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1164 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbXH0VN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:56 -0400
Message-Id: <20070827211351.392891000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:01 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 11/23] drm_stub.c: drm_calloc to drm_zalloc
Content-Disposition: inline; filename=drm_stub.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_stub.c | 7731 -> 7728 (-3 bytes)
 drivers/char/drm/drm_stub.o | 110301 -> 111354 (+1053 bytes)

 drivers/char/drm/drm_stub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_stub.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_stub.c
@@ -210,7 +210,7 @@ int drm_get_dev(struct pci_dev *pdev, co

 	DRM_DEBUG("\n");

-	dev = drm_calloc(1, sizeof(*dev), DRM_MEM_STUB);
+	dev = drm_zalloc(sizeof(*dev), DRM_MEM_STUB);
 	if (!dev)
 		return -ENOMEM;

--
