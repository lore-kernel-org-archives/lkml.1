Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXKOGwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXKOGwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbXKOGqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:46:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57801 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbXKOGqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:46:35 -0500
Date: Wed, 14 Nov 2007 22:43:59 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@linux.ie>
Subject: [patch 02/40] i915: fix vbl swap allocation size.
Message-ID: <20071115064359.GC19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i915-fix-vbl-swap-allocation-size.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Airlie <airlied@linux.ie>

This is upstream as 54583bf4efda79388fc13163e35c016c8bc5de81

Oops...

Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/drm/i915_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/drm/i915_irq.c
+++ b/drivers/char/drm/i915_irq.c
@@ -553,7 +553,7 @@ int i915_vblank_swap(DRM_IOCTL_ARGS)
 		return DRM_ERR(EBUSY);
 	}
 
-	vbl_swap = drm_calloc(1, sizeof(vbl_swap), DRM_MEM_DRIVER);
+	vbl_swap = drm_calloc(1, sizeof(*vbl_swap), DRM_MEM_DRIVER);
 
 	if (!vbl_swap) {
 		DRM_ERROR("Failed to allocate memory to queue swap\n");

-- 
