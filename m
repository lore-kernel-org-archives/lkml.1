Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZDMTmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZDMTmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZDMTlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:41:51 -0400
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:32794 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751281AbZDMTlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:41:51 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Mon, 13 Apr 2009 20:24:50 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter: alignment in /proc/interrupts
Message-ID: <20090413192449.GA3920@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial fix on columns alignment in /proc/interrupts file.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1ac5921..38287b5 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -66,7 +66,7 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance counter interrupts\n");
-	seq_printf(p, "PND: ");
+	seq_printf(p, "%*s: ", prec, "PND");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
 	seq_printf(p, "  Performance pending work\n");
-- 
1.6.2.1

