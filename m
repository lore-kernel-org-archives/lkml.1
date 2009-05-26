Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZEZQ1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZEZQ1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZEZQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:27:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZEZQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:27:34 -0400
Date: Tue, 26 May 2009 12:27:34 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: airlied@redhat.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, eric@anholt.net
Subject: [PATCH trivial] drm: i915: i915_modeset is signed
Message-ID: <20090526162734.GD14808@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 drivers/gpu/drm/i915/i915_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 98560e1..06600d1 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -36,7 +36,7 @@
 #include "drm_pciids.h"
 #include <linux/console.h>
 
-static unsigned int i915_modeset = -1;
+static int i915_modeset = -1;
 module_param_named(modeset, i915_modeset, int, 0400);
 
 unsigned int i915_fbpercrtc = 0;
-- 
1.6.2.2

