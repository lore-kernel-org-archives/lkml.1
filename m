Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYLRXG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYLRXG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYLRXGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:06:17 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49632 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYLRXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:06:16 -0500
Message-ID: <494ad5d2.190c660a.55a0.ffff96ff@mx.google.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 18 Dec 2008 15:09:00 +0100
Subject: [PATCH 1/6] drm/i915: fix sparse warnings: declare one-bit bitfield as unsigned
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/gpu/drm/i915/i915_drv.h:169:22: error: dubious one-bit signed bitfield
  drivers/gpu/drm/i915/i915_drv.h:169:22: warning: dubious bitfield without explicit `signed' or `unsigned'
  drivers/gpu/drm/i915/i915_drv.h:170:19: error: dubious one-bit signed bitfield
  drivers/gpu/drm/i915/i915_drv.h:170:19: warning: dubious bitfield without explicit `signed' or `unsigned'
  drivers/gpu/drm/i915/i915_drv.h:171:16: error: dubious one-bit signed bitfield
  drivers/gpu/drm/i915/i915_drv.h:171:16: warning: dubious bitfield without explicit `signed' or `unsigned'
  drivers/gpu/drm/i915/i915_drv.h:172:23: error: dubious one-bit signed bitfield
  drivers/gpu/drm/i915/i915_drv.h:172:23: warning: dubious bitfield without explicit `signed' or `unsigned'

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/i915/i915_drv.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 467572a..a640bcf 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -166,10 +166,10 @@ typedef struct drm_i915_private {
 	struct drm_display_mode *vbt_mode; /* if any */
 
 	/* Feature bits from the VBIOS */
-	int int_tv_support:1;
-	int lvds_dither:1;
-	int lvds_vbt:1;
-	int int_crt_support:1;
+	unsigned int int_tv_support:1;
+	unsigned int lvds_dither:1;
+	unsigned int lvds_vbt:1;
+	unsigned int int_crt_support:1;
 
 	struct drm_i915_fence_reg fence_regs[16]; /* assume 965 */
 	int fence_reg_start; /* 4 if userland hasn't ioctl'd us yet */
-- 
1.5.6.3

