Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbZINUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbZINUJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbZINUJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54174 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933649AbZINUJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 59/72] Blackfin: fix spelling in a few comments
Date: Mon, 14 Sep 2009 16:08:03 -0400
Message-Id: <1252958896-25150-60-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index ce02f98..369535b 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -112,7 +112,7 @@ void __cpuinit bfin_setup_caches(unsigned int cpu)
 	/*
 	 * In cache coherence emulation mode, we need to have the
 	 * D-cache enabled before running any atomic operation which
-	 * might invove cache invalidation (i.e. spinlock, rwlock).
+	 * might involve cache invalidation (i.e. spinlock, rwlock).
 	 * So printk's are deferred until then.
 	 */
 #ifdef CONFIG_BFIN_ICACHE
@@ -699,7 +699,7 @@ static __init void setup_bootmem_allocator(void)
 	sanitize_memmap(bfin_memmap.map, &bfin_memmap.nr_map);
 	print_memory_map("boot memmap");
 
-	/* intialize globals in linux/bootmem.h */
+	/* initialize globals in linux/bootmem.h */
 	find_min_max_pfn();
 	/* pfn of the last usable page frame */
 	if (max_pfn > memory_end >> PAGE_SHIFT)
-- 
1.6.4.2

