Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbZF1Qcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbZF1Qcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZF1Q1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:32 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1103 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbZF1Q13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:29 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net
Subject: [PATCH 17/62] drivers/gpu/drm: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:22 -0700
Message-Id: <e679417bd347f9abd86e1e20a1a7a01cfc6ae6c0.1246173681.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    2 +-
 drivers/gpu/drm/radeon/r300.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 8f8d37d..5359f59 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -211,7 +211,7 @@ intel_dp_aux_ch(struct intel_output *intel_output,
 	for (try = 0; try < 5; try++) {
 		/* Load the send data into the aux channel data registers */
 		for (i = 0; i < send_bytes; i += 4) {
-			uint32_t    d = pack_aux(send + i, send_bytes - i);;
+			uint32_t    d = pack_aux(send + i, send_bytes - i);
 	
 			I915_WRITE(ch_data + i, d);
 		}
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index e2ed5bc..e471a9c 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1276,11 +1276,11 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 	case 0x443C:
 		/* TX_FILTER0_[0-15] */
 		i = (reg - 0x4400) >> 2;
-		tmp = ib_chunk->kdata[idx] & 0x7;;
+		tmp = ib_chunk->kdata[idx] & 0x7;
 		if (tmp == 2 || tmp == 4 || tmp == 6) {
 			track->textures[i].roundup_w = false;
 		}
-		tmp = (ib_chunk->kdata[idx] >> 3) & 0x7;;
+		tmp = (ib_chunk->kdata[idx] >> 3) & 0x7;
 		if (tmp == 2 || tmp == 4 || tmp == 6) {
 			track->textures[i].roundup_h = false;
 		}
-- 
1.6.3.1.10.g659a0.dirty

