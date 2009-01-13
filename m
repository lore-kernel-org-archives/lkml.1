Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZAMBoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZAMBoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZAMBn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:43:59 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40578 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755499AbZAMBn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:43:58 -0500
Message-ID: <496BF1DC.2080009@sgi.com>
Date: Mon, 12 Jan 2009 17:43:56 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PULL]: please pull changes for tip/cpus4096
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

This is the same as the previous pull request except that I added Yinghai's
vast improvement to probing for nr_irqs.  Big difference in runtime memory
allocated.

Thanks,
Mike
--- 

The following changes since commit 28e08861b9afab4168b758fb7b95aa7a4da0f668:
  Christophe Saout (1):
        xen: fix too early kmalloc call

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

Mike Travis (1):
      irq: update all arches for new irq_desc

Yinghai Lu (1):
      x86: arch_probe_nr_irqs

 arch/alpha/kernel/irq.c               |    2 +-
 arch/arm/kernel/irq.c                 |   18 ++++++++++++------
 arch/arm/oprofile/op_model_mpcore.c   |    2 +-
 arch/blackfin/kernel/irqchip.c        |    5 +++++
 arch/ia64/kernel/iosapic.c            |    2 +-
 arch/ia64/kernel/irq.c                |    4 ++--
 arch/ia64/kernel/msi_ia64.c           |    4 ++--
 arch/ia64/sn/kernel/msi_sn.c          |    2 +-
 arch/mips/include/asm/irq.h           |    2 +-
 arch/mips/kernel/irq-gic.c            |    2 +-
 arch/mips/kernel/smtc.c               |    2 +-
 arch/mips/mti-malta/malta-smtc.c      |    5 +++--
 arch/parisc/kernel/irq.c              |    8 ++++----
 arch/powerpc/kernel/irq.c             |    2 +-
 arch/powerpc/platforms/pseries/xics.c |    5 +++--
 arch/powerpc/sysdev/mpic.c            |    3 ++-
 arch/sparc/kernel/irq_64.c            |    5 +++--
 arch/x86/include/asm/irq_vectors.h    |    7 ++-----
 arch/x86/kernel/io_apic.c             |   16 ++++++++++++++++
 include/linux/interrupt.h             |    1 +
 kernel/irq/handle.c                   |    9 ++-------
 kernel/softirq.c                      |    5 +++++
 22 files changed, 70 insertions(+), 41 deletions(-)

