Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXEBEaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXEBEaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992738AbXEBE3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:29:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992729AbXEBE24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:28:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=flif3psiQCakb4LA7K7gCpqh6UP0d1yic2rp57Y6pvB+zWPoI9LRbgp5e3mYNNy/n
	ERPJ6mNaeoKvDup7UytbQ==
Date: Tue, 1 May 2007 21:28:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: [patch 08/10] mips: tlbex: use __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705012122480.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012123330.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012122120.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012122480.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace function instances of __attribute__((unused)) with
__attribute_unused__.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/mips/mm/tlbex.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -35,24 +35,24 @@
 #include <asm/smp.h>
 #include <asm/war.h>
 
-static __init int __attribute__((unused)) r45k_bvahwbug(void)
+static __init int __attribute_unused__ r45k_bvahwbug(void)
 {
 	/* XXX: We should probe for the presence of this bug, but we don't. */
 	return 0;
 }
 
-static __init int __attribute__((unused)) r4k_250MHZhwbug(void)
+static __init int __attribute_unused__ r4k_250MHZhwbug(void)
 {
 	/* XXX: We should probe for the presence of this bug, but we don't. */
 	return 0;
 }
 
-static __init int __attribute__((unused)) bcm1250_m3_war(void)
+static __init int __attribute_unused__ bcm1250_m3_war(void)
 {
 	return BCM1250_M3_WAR;
 }
 
-static __init int __attribute__((unused)) r10000_llsc_war(void)
+static __init int __attribute_unused__ r10000_llsc_war(void)
 {
 	return R10000_LLSC_WAR;
 }
@@ -511,18 +511,18 @@ L_LA(_r3000_write_probe_fail)
 #define i_ehb(buf) i_sll(buf, 0, 0, 3)
 
 #ifdef CONFIG_64BIT
-static __init int __attribute__((unused)) in_compat_space_p(long addr)
+static __init int __attribute_unused__ in_compat_space_p(long addr)
 {
 	/* Is this address in 32bit compat space? */
 	return (((addr) & 0xffffffff00000000L) == 0xffffffff00000000L);
 }
 
-static __init int __attribute__((unused)) rel_highest(long val)
+static __init int __attribute_unused__ rel_highest(long val)
 {
 	return ((((val + 0x800080008000L) >> 48) & 0xffff) ^ 0x8000) - 0x8000;
 }
 
-static __init int __attribute__((unused)) rel_higher(long val)
+static __init int __attribute_unused__ rel_higher(long val)
 {
 	return ((((val + 0x80008000L) >> 32) & 0xffff) ^ 0x8000) - 0x8000;
 }
@@ -556,8 +556,8 @@ static __init void i_LA_mostly(u32 **buf, unsigned int rs, long addr)
 		i_lui(buf, rs, rel_hi(addr));
 }
 
-static __init void __attribute__((unused)) i_LA(u32 **buf, unsigned int rs,
-						long addr)
+static __init void __attribute_unused__ i_LA(u32 **buf, unsigned int rs,
+					     long addr)
 {
 	i_LA_mostly(buf, rs, addr);
 	if (rel_lo(addr))
@@ -636,8 +636,8 @@ static __init void copy_handler(struct reloc *rel, struct label *lab,
 	move_labels(lab, first, end, off);
 }
 
-static __init int __attribute__((unused)) insn_has_bdelay(struct reloc *rel,
-							  u32 *addr)
+static __init int __attribute_unused__ insn_has_bdelay(struct reloc *rel,
+						       u32 *addr)
 {
 	for (; rel->lab != label_invalid; rel++) {
 		if (rel->addr == addr
@@ -650,15 +650,15 @@ static __init int __attribute__((unused)) insn_has_bdelay(struct reloc *rel,
 }
 
 /* convenience functions for labeled branches */
-static void __init __attribute__((unused))
+static void __init __attribute_unused__
 	il_bltz(u32 **p, struct reloc **r, unsigned int reg, enum label_id l)
 {
 	r_mips_pc16(r, *p, l);
 	i_bltz(p, reg, 0);
 }
 
-static void __init __attribute__((unused)) il_b(u32 **p, struct reloc **r,
-					 enum label_id l)
+static void __init __attribute_unused__ il_b(u32 **p, struct reloc **r,
+					     enum label_id l)
 {
 	r_mips_pc16(r, *p, l);
 	i_b(p, 0);
@@ -671,7 +671,7 @@ static void __init il_beqz(u32 **p, struct reloc **r, unsigned int reg,
 	i_beqz(p, reg, 0);
 }
 
-static void __init __attribute__((unused))
+static void __init __attribute_unused__
 il_beqzl(u32 **p, struct reloc **r, unsigned int reg, enum label_id l)
 {
 	r_mips_pc16(r, *p, l);
@@ -692,7 +692,7 @@ static void __init il_bgezl(u32 **p, struct reloc **r, unsigned int reg,
 	i_bgezl(p, reg, 0);
 }
 
-static void __init __attribute__((unused))
+static void __init __attribute_unused__
 il_bgez(u32 **p, struct reloc **r, unsigned int reg, enum label_id l)
 {
 	r_mips_pc16(r, *p, l);
@@ -810,7 +810,7 @@ static __initdata u32 final_handler[64];
  *
  * As if we MIPS hackers wouldn't know how to nop pipelines happy ...
  */
-static __init void __attribute__((unused)) build_tlb_probe_entry(u32 **p)
+static __init void __attribute_unused__ build_tlb_probe_entry(u32 **p)
 {
 	switch (current_cpu_data.cputype) {
 	/* Found by experiment: R4600 v2.0 needs this, too.  */
@@ -1098,7 +1098,7 @@ build_get_pgd_vmalloc64(u32 **p, struct label **l, struct reloc **r,
  * TMP and PTR are scratch.
  * TMP will be clobbered, PTR will hold the pgd entry.
  */
-static __init void __attribute__((unused))
+static __init void __attribute_unused__
 build_get_pgde32(u32 **p, unsigned int tmp, unsigned int ptr)
 {
 	long pgdc = (long)pgd_current;
