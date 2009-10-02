Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZJBBdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZJBBdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbZJBBdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:21 -0400
Received: from kroah.org ([198.145.64.141]:33184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbZJBBdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:15 2009
Message-Id: <20091002012415.468827225@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [060/136] drm/i915: Fix typo for wrong LVDS clock setting on IGDNG
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-fix-typo-for-wrong-lvds-clock-setting-on-igdng.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit b09aea7fb38f328c02e9f9b79617cabed02455e4 upstream.

New register for PCH LVDS on IGDNG should be used.
This is a copy-n-paste typo. This fixes possible dual
channel LVDS panel failure on IGDNG.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -818,7 +818,7 @@ intel_igdng_find_best_PLL(const intel_li
 					       refclk, best_clock);
 
 	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
-		if ((I915_READ(LVDS) & LVDS_CLKB_POWER_MASK) ==
+		if ((I915_READ(PCH_LVDS) & LVDS_CLKB_POWER_MASK) ==
 		    LVDS_CLKB_POWER_UP)
 			clock.p2 = limit->p2.p2_fast;
 		else


