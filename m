Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYCJUM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYCJUM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYCJUMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:12:22 -0400
Received: from saeurebad.de ([85.214.36.134]:47393 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYCJUMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:12:21 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <trivial@kernel.org>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] m32r: Remove redundant display of free swap space in show_mem()
Date: Mon, 10 Mar 2008 21:10:50 +0100
Message-Id: <12051798652912-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12051798631122-git-send-email-hannes@saeurebad.de>
References: <12051798631122-git-send-email-hannes@saeurebad.de>
CC: Hirokazu Takata <takata@linux-m32r.org>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/m32r/mm/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/m32r/mm/init.c b/arch/m32r/mm/init.c
index bbd97c8..a08ac3e 100644
--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -47,7 +47,6 @@ void show_mem(void)
 
 	printk("Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n",nr_swap_pages<<(PAGE_SHIFT-10));
 	for_each_online_pgdat(pgdat) {
 		unsigned long flags;
 		pgdat_resize_lock(pgdat, &flags);
@@ -252,4 +251,3 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 	printk (KERN_INFO "Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
 }
 #endif
-
-- 
1.5.2.2
