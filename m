Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYLDTmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYLDTmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYLDTmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:42:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbYLDTmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:42:13 -0500
Date: Thu, 4 Dec 2008 20:41:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fix
Message-ID: <20081204194158.GA32140@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Mahesh Salgaonkar (1):
      sched: don't export sched_mc_power_savings in laptops


 arch/x86/include/asm/topology.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 4850e4b..ff386ff 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -239,7 +239,7 @@ struct pci_bus;
 void set_pci_bus_resources_arch_default(struct pci_bus *b);
 
 #ifdef CONFIG_SMP
-#define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
+#define mc_capable()	(cpus_weight(per_cpu(cpu_core_map, 0)) != nr_cpu_ids)
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
