Return-Path: <linux-kernel-owner+w=401wt.eu-S1161569AbXD2XqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569AbXD2XqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161579AbXD2XqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:41920 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161569AbXD2XqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:14 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/26] i386: Remove unneeded externs in nmi.c
Message-Id: <20070429234612.ED1E6151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


All were already in some header
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/nmi.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -75,9 +75,6 @@ static DEFINE_PER_CPU(struct nmi_watchdo
 /* local prototypes */
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
 
-extern void show_registers(struct pt_regs *regs);
-extern int unknown_nmi_panic;
-
 /* converts an msr to an appropriate reservation bit */
 static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
 {
