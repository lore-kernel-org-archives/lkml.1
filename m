Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYCJUOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYCJUOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYCJUMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:12:25 -0400
Received: from saeurebad.de ([85.214.36.134]:47405 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbYCJUMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:12:25 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <trivial@kernel.org>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] ppc: Remove redundant display of free swap space in show_mem()
Date: Mon, 10 Mar 2008 21:10:54 +0100
Message-Id: <12051798683382-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12051798631122-git-send-email-hannes@saeurebad.de>
References: <12051798631122-git-send-email-hannes@saeurebad.de>
CC: Paul Mackerras <paulus@samba.org>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/ppc/mm/init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/ppc/mm/init.c b/arch/ppc/mm/init.c
index 7444df3..1a63711 100644
--- a/arch/ppc/mm/init.c
+++ b/arch/ppc/mm/init.c
@@ -109,7 +109,6 @@ void show_mem(void)
 
 	printk("Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	i = max_mapnr;
 	while (i-- > 0) {
 		total++;
-- 
1.5.2.2
