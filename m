Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYCJUPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYCJUPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYCJUM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:12:27 -0400
Received: from saeurebad.de ([85.214.36.134]:47411 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYCJUM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:12:26 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <trivial@kernel.org>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] x86: Remove redundant display of free swap space in show_mem()
Date: Mon, 10 Mar 2008 21:10:57 +0100
Message-Id: <12051798701357-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12051798631122-git-send-email-hannes@saeurebad.de>
References: <12051798631122-git-send-email-hannes@saeurebad.de>
CC: Thomas Gleixner <tglx@linuxtronix.de>, Ingo Molnar <mingo@elte.hu>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/x86/mm/init_64.c    |    3 ---
 arch/x86/mm/pgtable_32.c |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a02a14f..37b688d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -69,9 +69,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-		nr_swap_pages << (PAGE_SHIFT-10));
-
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
 			/*
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 73aba71..21b7543 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -36,7 +36,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	for_each_online_pgdat(pgdat) {
 		pgdat_resize_lock(pgdat, &flags);
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
-- 
1.5.2.2
