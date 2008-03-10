Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYCJUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYCJUMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYCJUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:12:21 -0400
Received: from saeurebad.de ([85.214.36.134]:47385 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYCJUMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:12:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <trivial@kernel.org>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] arm: Remove redundant display of free swap space in show_mem()
Date: Mon, 10 Mar 2008 21:10:48 +0100
Message-Id: <12051798631122-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
CC: Russell King <rmk@arm.linux.org.uk>,
       Lennert Buytenhek <kernel@wantstofly.org>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/arm/mm/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index ec00f26..b657f17 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -48,8 +48,6 @@ void show_mem(void)
 
 	printk("Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-
 	for_each_online_node(node) {
 		pg_data_t *n = NODE_DATA(node);
 		struct page *map = n->node_mem_map - n->node_start_pfn;
-- 
1.5.2.2
