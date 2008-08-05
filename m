Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYHEJ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYHEJ6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbYHEJ5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:57:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:58619 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbYHEJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:57:43 -0400
Date: Tue, 5 Aug 2008 19:57:41 +1000
From: Simon Horman <horms@verge.net.au>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Subject: [patch] IA64: make rsvd_region and num_rsvd_regions static
Message-ID: <20080805095739.GA12078@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rsvd_region and num_rsvd_regions are only accessed in
arch/ia64/kernel/setup.c, so they should be static.

Signed-off-by: Simon Horman <horms@verge.net.au>


Index: linux-2.6/arch/ia64/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/setup.c	2008-08-02 17:38:02.000000000 +1000
+++ linux-2.6/arch/ia64/kernel/setup.c	2008-08-02 17:38:20.000000000 +1000
@@ -132,8 +132,8 @@ EXPORT_SYMBOL(ia64_max_iommu_merge_mask)
 /*
  * We use a special marker for the end of memory and it uses the extra (+1) slot
  */
-struct rsvd_region rsvd_region[IA64_MAX_RSVD_REGIONS + 1] __initdata;
-int num_rsvd_regions __initdata;
+static struct rsvd_region rsvd_region[IA64_MAX_RSVD_REGIONS + 1] __initdata;
+static int num_rsvd_regions __initdata;
 
 
 /*
