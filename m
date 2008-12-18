Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYLRXAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYLRXAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYLRW7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:59:49 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64087 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbYLRW7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:59:48 -0500
Message-ID: <494ad5e1.02a1660a.77b3.5036@mx.google.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 18 Dec 2008 21:25:51 +0100
Subject: [PATCH 5/6] drm/i915: comment out unused function 'i915_driver_firstopen'
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this warning:

  drivers/gpu/drm/i915/i915_dma.c:1011: warning: 'i915_driver_firstopen' defined but not used

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/i915/i915_dma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 36a6884..10f3fe6 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1007,12 +1007,14 @@ void i915_master_destroy(struct drm_device *dev, struct drm_master *master)
 }
 
 
+#ifdef UNUSED
 static int i915_driver_firstopen(struct drm_device *dev)
 {
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		return 0;
 	return 0;
 }
+#endif /* UNUSED */
 
 /**
  * i915_driver_load - setup chip and create an initial config
-- 
1.5.6.3

