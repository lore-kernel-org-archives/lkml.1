Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYLRXA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYLRXA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbYLRW7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:59:53 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:30246 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYLRW7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:59:51 -0500
Message-ID: <494ad5e4.0baa660a.04de.7bb4@mx.google.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 18 Dec 2008 22:32:22 +0100
Subject: [PATCH 6/6] drm/i915: add prototype for 'intelfb_panic' to header file
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:

  drivers/gpu/drm/i915/intel_fb.c:417:5: warning: symbol 'intelfb_panic' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/i915/intel_drv.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 407edd5..b8ae5ce 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -135,6 +135,8 @@ extern void intel_sdvo_set_hotplug(struct drm_connector *connector, int enable);
 extern int intelfb_probe(struct drm_device *dev);
 extern int intelfb_remove(struct drm_device *dev, struct drm_framebuffer *fb);
 extern int intelfb_resize(struct drm_device *dev, struct drm_crtc *crtc);
+extern int intelfb_panic(struct notifier_block *n, unsigned long ununsed,
+			 void *panic_str);
 extern void intelfb_restore(void);
 extern void intel_crtc_fb_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
 				    u16 blue, int regno);
-- 
1.5.6.3

