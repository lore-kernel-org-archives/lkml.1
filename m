Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYCJUQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYCJUQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYCJUMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:12:30 -0400
Received: from saeurebad.de ([85.214.36.134]:47413 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbYCJUM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:12:28 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <trivial@kernel.org>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] um: Remove redundant display of free swap space in show_mem()
Date: Mon, 10 Mar 2008 21:11:00 +0100
Message-Id: <12051798724181-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12051798631122-git-send-email-hannes@saeurebad.de>
References: <12051798631122-git-send-email-hannes@saeurebad.de>
CC: Jeff Dike <jdike@addtoit.com>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/um/kernel/mem.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 2eea1ff..6a961b9 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -304,8 +304,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-	       nr_swap_pages<<(PAGE_SHIFT-10));
 	pfn = max_mapnr;
 	while (pfn-- > 0) {
 		page = pfn_to_page(pfn);
-- 
1.5.2.2
