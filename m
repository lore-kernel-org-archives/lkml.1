Return-Path: <linux-kernel-owner+w=401wt.eu-S936432AbZLQE0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936432AbZLQE0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935716AbZLQEEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:55 -0500
Received: from kroah.org ([198.145.64.141]:55705 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935662AbZLQEEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:53 2009
Message-Id: <20091217035653.632115849@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>
Subject: [083/151] drm/i915: Add the missing clonemask for display port on Ironlake
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 652af9d74e1a3a10bb10f0d8e8f42ddac26bbc1a upstream.

Add the missing clonemask for display port on Ironlake.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_dp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1254,11 +1254,11 @@ intel_dp_init(struct drm_device *dev, in
 	else
 		intel_output->type = INTEL_OUTPUT_DISPLAYPORT;
 
-	if (output_reg == DP_B)
+	if (output_reg == DP_B || output_reg == PCH_DP_B)
 		intel_output->clone_mask = (1 << INTEL_DP_B_CLONE_BIT);
-	else if (output_reg == DP_C)
+	else if (output_reg == DP_C || output_reg == PCH_DP_C)
 		intel_output->clone_mask = (1 << INTEL_DP_C_CLONE_BIT);
-	else if (output_reg == DP_D)
+	else if (output_reg == DP_D || output_reg == PCH_DP_D)
 		intel_output->clone_mask = (1 << INTEL_DP_D_CLONE_BIT);
 
 	if (IS_eDP(intel_output)) {


