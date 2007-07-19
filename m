Return-Path: <linux-kernel-owner+w=401wt.eu-S938898AbXGSOD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938898AbXGSOD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbXGSNtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762287AbXGSNtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:01 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: da-x@monatomic.org, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [30/48] x86_64: arch/x86_64/kernel/e820.c lower printk severity
Message-Id: <20070719134900.746B214E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:49:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/e820.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/e820.c
===================================================================
--- linux.orig/arch/x86_64/kernel/e820.c
+++ linux/arch/x86_64/kernel/e820.c
@@ -361,7 +361,7 @@ void __init e820_print_map(char *who)
 	int i;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		printk(" %s: %016Lx - %016Lx ", who,
+		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
 			(unsigned long long) e820.map[i].addr,
 			(unsigned long long) (e820.map[i].addr + e820.map[i].size));
 		switch (e820.map[i].type) {
