Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZCYUqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZCYUqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZCYUqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:46:18 -0400
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:52587 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753095AbZCYUqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:46:16 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 25 Mar 2009 20:43:51 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter: trivial fix on columns alignment
Message-ID: <20090325204351.GA4168@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected columns alignment in /proc/interrupts

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 9c27543..5209486 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -63,7 +63,7 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
-	seq_printf(p, "CNT: ");
+	seq_printf(p, "%*s: ", prec, "CNT");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance counter interrupts\n");
-- 
1.6.2.1

