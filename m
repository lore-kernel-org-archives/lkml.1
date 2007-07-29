Return-Path: <linux-kernel-owner+w=401wt.eu-S1764544AbXG2O7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764544AbXG2O7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764132AbXG2O5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:57:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47768 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763886AbXG2O5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:57:17 -0400
Date: Sun, 29 Jul 2007 16:56:53 +0200
From: Adrian Bunk <bunk@stusta.de>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] radeon_driver_vblank_do_wait() static
Message-ID: <20070729145653.GI16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

radeon_driver_vblank_do_wait() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/char/drm/radeon_irq.c.old	2007-07-26 08:49:12.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/char/drm/radeon_irq.c	2007-07-26 08:49:46.000000000 +0200
@@ -144,8 +144,8 @@
 	return ret;
 }
 
-int radeon_driver_vblank_do_wait(struct drm_device * dev, unsigned int *sequence,
-				 int crtc)
+static int radeon_driver_vblank_do_wait(struct drm_device * dev,
+					unsigned int *sequence, int crtc)
 {
 	drm_radeon_private_t *dev_priv =
 	    (drm_radeon_private_t *) dev->dev_private;

