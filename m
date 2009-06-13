Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZFMTaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZFMTaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 15:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZFMTaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 15:30:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:47462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZFMTaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 15:30:13 -0400
Subject: [PATCH -tip] x86: cpu/proc.c allow access to cache alignment and
 address sizes for 32 bit
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 00:59:50 +0530
Message-Id: <1244921390.11733.30.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


32 bit can also access x86_cache_alignment, x86_phys_bits and x86_virt_bits

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/proc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index d5e3039..f82706a 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -116,11 +116,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		seq_printf(m, "TLB size\t: %d 4K pages\n", c->x86_tlbsize);
 #endif
 	seq_printf(m, "clflush size\t: %u\n", c->x86_clflush_size);
-#ifdef CONFIG_X86_64
 	seq_printf(m, "cache_alignment\t: %d\n", c->x86_cache_alignment);
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
-#endif
 
 	seq_printf(m, "power management:");
 	for (i = 0; i < 32; i++) {
-- 
1.6.0.6



