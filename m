Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYCJUNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYCJUNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYCJUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:12:23 -0400
Received: from saeurebad.de ([85.214.36.134]:47396 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYCJUMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:12:22 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <trivial@kernel.org>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] m68k: Remove redundant display of free swap space in show_mem()
Date: Mon, 10 Mar 2008 21:10:51 +0100
Message-Id: <12051798652856-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12051798631122-git-send-email-hannes@saeurebad.de>
References: <12051798631122-git-send-email-hannes@saeurebad.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/m68k/mm/init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index f42caa7..a2bb01f 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -79,7 +79,6 @@ void show_mem(void)
 
 	printk("\nMem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < pgdat->node_spanned_pages; i++) {
 			struct page *page = pgdat->node_mem_map + i;
-- 
1.5.2.2
