Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbZFMVEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbZFMVEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759687AbZFMVER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:04:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:48425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbZFMVEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:04:16 -0400
Date: Sat, 13 Jun 2009 21:03:55 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, tglx@linutronix.de, jaswinderrajput@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, tglx@linutronix.de, jaswinderrajput@gmail.com
In-Reply-To: <1244921390.11733.30.camel@ht.satnam>
References: <1244921390.11733.30.camel@ht.satnam>
Subject: [tip:x86/cpu] x86, cpu: cpu/proc.c display cache alignment and address sizes for 32 bit
Message-ID: <tip-c64b04fe6e0cb7c78e01751a44ef56cf20344e87@git.kernel.org>
Git-Commit-ID: c64b04fe6e0cb7c78e01751a44ef56cf20344e87
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 21:03:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c64b04fe6e0cb7c78e01751a44ef56cf20344e87
Gitweb:     http://git.kernel.org/tip/c64b04fe6e0cb7c78e01751a44ef56cf20344e87
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sun, 14 Jun 2009 00:59:50 +0530
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 13 Jun 2009 14:00:49 -0700

x86, cpu: cpu/proc.c display cache alignment and address sizes for 32 bit

32 bits can also access x86_cache_alignment, x86_phys_bits and
x86_virt_bits, make them available to user space just as on 64 bits.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
LKML-Reference: <1244921390.11733.30.camel@ht.satnam>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


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
