Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYCJUOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYCJUOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYCJUM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:12:27 -0400
Received: from saeurebad.de ([85.214.36.134]:47409 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbYCJUM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:12:26 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <trivial@kernel.org>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] sh: Remove redundant display of free swap space in show_mem()
Date: Mon, 10 Mar 2008 21:10:56 +0100
Message-Id: <12051798692170-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12051798631122-git-send-email-hannes@saeurebad.de>
References: <12051798631122-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/sh/mm/init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 53dde06..409e4f0 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -55,7 +55,6 @@ void show_mem(void)
 		pgdat_resize_unlock(pgdat, &flags);
 	}
 
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	printk("%d pages of RAM\n", total);
 	printk("%d free pages\n", free);
 	printk("%d reserved pages\n", reserved);
-- 
1.5.2.2
