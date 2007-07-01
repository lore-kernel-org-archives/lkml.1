Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbXGAU03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbXGAU03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbXGAUWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:22:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46875 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759363AbXGAUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:22:44 -0400
Date: Sun, 1 Jul 2007 22:23:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [-mm patch] make cpuidle_replace_governor() static
Message-ID: <20070701202310.GR10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
> +cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
>...
>  cpuidle updates
>...


This patch makes the needlessly global cpuidle_replace_governor() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/cpuidle/governor.c.old	2007-06-30 03:37:06.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/cpuidle/governor.c	2007-06-30 03:37:14.000000000 +0200
@@ -147,7 +147,7 @@
  * @exclude_rating: the rating that will be skipped while looking for
  * new governor.
  */
-struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
+static struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
 {
 	struct cpuidle_governor *gov;
 	struct cpuidle_governor *ret_gov = NULL;

