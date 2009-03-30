Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZC3AL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZC3AL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 20:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZC3ALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 20:11:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53077
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753735AbZC3ALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 20:11:16 -0400
Date: Sun, 29 Mar 2009 17:11:04 -0700 (PDT)
Message-Id: <20090329.171104.142031534.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this bug fix, and a set of cpumask updates
from Rusty.

Thanks!

The following changes since commit 07d43ba98621f08e252a48c96b258b4d572b0257:
  Linus Torvalds (1):
        Merge branch 'i2c-for-linus' of git://jdelvare.pck.nerim.net/jdelvare-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Fix reset hangs on Niagara systems.
      Merge branch 'master' of ssh://master.kernel.org/home/ftp/.../rusty/linux-2.6-cpumask-for-sparc

Rusty Russell (10):
      cpumask: Use smp_call_function_many(): sparc64
      cpumask: arch_send_call_function_ipi_mask: sparc
      cpumask: Use accessors code: sparc
      cpumask: Use accessors code.: sparc64
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc64
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc
      cpumask: remove cpu_coregroup_map: sparc
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): sparc
      cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: sparc
      cpumask: use mm_cpumask() wrapper: sparc

 arch/sparc/include/asm/mmu_context_64.h |    8 +++---
 arch/sparc/include/asm/smp_64.h         |    3 +-
 arch/sparc/include/asm/system_32.h      |    2 +-
 arch/sparc/include/asm/topology_64.h    |    7 +-----
 arch/sparc/kernel/ds.c                  |    2 +-
 arch/sparc/kernel/irq_64.c              |    4 +-
 arch/sparc/kernel/mdesc.c               |    2 +-
 arch/sparc/kernel/nmi.c                 |   23 +++++++++++++++++++-
 arch/sparc/kernel/prom_64.c             |    4 +-
 arch/sparc/kernel/smp_32.c              |   36 +++++++++++++++---------------
 arch/sparc/kernel/smp_64.c              |   14 ++++++------
 arch/sparc/kernel/sun4d_smp.c           |   11 ++++-----
 arch/sparc/kernel/sun4m_smp.c           |   10 +++-----
 arch/sparc/mm/init_64.c                 |    2 +-
 arch/sparc/mm/srmmu.c                   |    2 +-
 15 files changed, 72 insertions(+), 58 deletions(-)
