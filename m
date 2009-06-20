Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZFTDUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZFTDUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 23:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZFTDUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 23:20:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:5938 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZFTDUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 23:20:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,257,1243839600"; 
   d="scan'208";a="156644143"
Message-Id: <20090620031626.763180363@intel.com>
References: <20090620031608.624240019@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 20 Jun 2009 11:16:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>
Cc: Minchan Kim <minchan.kim@gmail.com>
cc: Mel Gorman <mel@csn.ul.ie>
cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 15/15] HWPOISON: FOR TESTING: Enable memory failure code unconditionally
Content-Disposition: inline; filename=hwpoison-enable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Normally the memory-failure.c code is enabled by the architecture, but
for easier testing independent of architecture changes enable it unconditionally.

This should not be merged into mainline.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- sound-2.6.orig/mm/Kconfig
+++ sound-2.6/mm/Kconfig
@@ -241,6 +241,8 @@ config KSM
 
 config MEMORY_FAILURE
 	bool
+	default y
+	depends on MMU
 
 config HWPOISON_INJECT
 	tristate "Hardware poison pages injector"

-- 

