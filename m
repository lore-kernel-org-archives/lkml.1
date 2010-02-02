Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0BBHW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:22:29 -0500
Received: from mail.perches.com ([173.55.12.10]:1767 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab0BBHWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:22 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net
Subject: [PATCH 03/10] drivers/gpu/drm/i915/intel_bios.c: Fix continuation line formats
Date: Mon,  1 Feb 2010 23:22:09 -0800
Message-Id: <1a334602cf3ee78ab6eda665c594b3afd332a7b7.1265095094.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1265095093.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/i915/intel_bios.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 15fbc1b..fe14cde 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -416,8 +416,7 @@ parse_edp(struct drm_i915_private *dev_priv, struct bdb_header *bdb)
 	edp = find_section(bdb, BDB_EDP);
 	if (!edp) {
 		if (SUPPORTS_EDP(dev_priv->dev) && dev_priv->edp_support) {
-			DRM_DEBUG_KMS("No eDP BDB found but eDP panel supported,\
-				       assume 18bpp panel color depth.\n");
+			DRM_DEBUG_KMS("No eDP BDB found but eDP panel supported, assume 18bpp panel color depth.\n");
 			dev_priv->edp_bpp = 18;
 		}
 		return;
-- 
1.6.6.rc0.57.gad7a

