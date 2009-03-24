Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbZCXRgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbZCXRgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZCXRgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:36:06 -0400
Received: from gw.goop.org ([64.81.55.164]:47018 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbZCXRgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:36:03 -0400
Message-ID: <49C91A00.2000000@goop.org>
Date: Tue, 24 Mar 2009 10:36:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: [GIT PULL] xen.git 2.6.30: push2/x86/paravirt: preemption in lazy
 mmu updates
References: <49C915A3.3020809@goop.org>
In-Reply-To: <49C915A3.3020809@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d9937cb8df272909407552955e26f922945cb5aa:
  Ingo Molnar (1):
        Merge branch 'x86/apic'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/x86/paravirt

Jeremy Fitzhardinge (8):
      mm: disable preemption in apply_to_pte_range
      x86/paravirt: remove lazy mode in interrupts
      x86/pvops: replace arch_enter_lazy_cpu_mode with arch_start_context_switch
      x86/paravirt: flush pending mmu updates on context switch
      x86/paravirt: finish change from lazy cpu to context switch start/end
      x86/paravirt: allow preemption with lazy mmu mode
      mm: allow preemption in apply_to_pte_range
      x86/paravirt: use percpu_ rather than __get_cpu_var

 arch/x86/include/asm/paravirt.h    |   22 +++++++-------
 arch/x86/include/asm/pgtable.h     |    2 +
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/kernel/kvm.c              |    2 +-
 arch/x86/kernel/paravirt.c         |   56 ++++++++++++++++-------------------
 arch/x86/kernel/process_32.c       |    2 +-
 arch/x86/kernel/process_64.c       |    2 +-
 arch/x86/kernel/vmi_32.c           |   20 ++++++++----
 arch/x86/lguest/boot.c             |   16 +++++++---
 arch/x86/mm/fault.c                |    6 +--
 arch/x86/mm/highmem_32.c           |    2 -
 arch/x86/mm/iomap_32.c             |    2 -
 arch/x86/mm/pageattr.c             |   14 ---------
 arch/x86/xen/enlighten.c           |   10 ++----
 arch/x86/xen/mmu.c                 |   20 +++++--------
 arch/x86/xen/xen-ops.h             |    1 -
 include/asm-frv/pgtable.h          |    4 +-
 include/asm-generic/pgtable.h      |   21 +++++++------
 kernel/sched.c                     |    2 +-


