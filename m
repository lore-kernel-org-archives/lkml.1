Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZBLKQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZBLKQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbZBLKPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:15:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41541
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757476AbZBLKPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:15:45 -0500
Date: Thu, 12 Feb 2009 02:15:39 -0800 (PST)
Message-Id: <20090212.021539.265736838.davem@davemloft.net>
To: airlied@linux.ie
CC: benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5]: drm: radeon: Fix RADEON_*_EMITED defines.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are not supposed to be booleans, they are
supposed to be bit masks.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpu/drm/radeon/radeon_drv.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
index a253cf0..9b60a26 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -219,8 +219,8 @@ struct radeon_virt_surface {
 	struct drm_file *file_priv;
 };
 
-#define RADEON_FLUSH_EMITED	(1 < 0)
-#define RADEON_PURGE_EMITED	(1 < 1)
+#define RADEON_FLUSH_EMITED	(1 << 0)
+#define RADEON_PURGE_EMITED	(1 << 1)
 
 struct drm_radeon_master_private {
 	drm_local_map_t *sarea;
-- 
1.6.1.2.350.g88cc

