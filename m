Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZFQHWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZFQHWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZFQHWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:22:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59122 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZFQHWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:22:04 -0400
From: Dave Airlie <airlied@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH] drm/radeon/kms: remove the _DRM_DRIVER from the KMS paths.
Date: Wed, 17 Jun 2009 17:21:13 +1000
Message-Id: <1245223273-16207-1-git-send-email-airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>

This causes an issue since we fixed the drm mappings to do the right thing,
so its just a copy and pasto.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index b0ce44b..64f42b1 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -176,7 +176,7 @@ int radeon_master_create_kms(struct drm_device *dev, struct drm_master *master)
 	/* prebuild the SAREA */
 	sareapage = max_t(unsigned long, SAREA_MAX, PAGE_SIZE);
 	ret = drm_addmap(dev, 0, sareapage, _DRM_SHM,
-			 _DRM_CONTAINS_LOCK|_DRM_DRIVER,
+			 _DRM_CONTAINS_LOCK,
 			 &master_priv->sarea);
 	if (ret) {
 		DRM_ERROR("SAREA setup failed\n");
-- 
1.6.2.2

