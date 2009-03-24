Return-Path: <linux-kernel-owner+w=401wt.eu-S1763752AbZCXRhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763752AbZCXRhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZCXRho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:37:44 -0400
Received: from gw.goop.org ([64.81.55.164]:37565 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbZCXRhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:37:42 -0400
Message-ID: <49C91A64.7040407@goop.org>
Date: Tue, 24 Mar 2009 10:37:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: [GIT PULL] xen.git 2.6.30: core Xen updates
References: <49C915A3.3020809@goop.org>
In-Reply-To: <49C915A3.3020809@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8d336ed83a87149bcae6b872fff1aed8be268342:
  Jeremy Fitzhardinge (1):
        x86/paravirt: use percpu_ rather than __get_cpu_var

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/xen/core

Alex Nixon (1):
      Xen: Add virt_to_pfn helper function

Hannes Eder (1):
      NULL noise: arch/x86/xen/smp.c

Jeremy Fitzhardinge (15):
      xen: disable preempt for leave_lazy_mmu
      xen: separate p2m allocation from setting
      xen: dynamically allocate p2m tables
      xen: split construction of p2m mfn tables from registration
      xen: clean up xen_load_gdt
      xen: make xen_load_gdt simpler
      xen: remove xen_load_gdt debug
      xen: reserve i386 Xen pagetables
      xen: mask XSAVE from cpuid
      xen: add FIX_TEXT_POKE to fixmap
      x86-64: remove PGE from must-have feature list
      x86-64: non-paravirt systems always has PSE and PGE
      xen/mmu: some early pagetable cleanups
      Revert "x86: create a non-zero sized bm_pte only when needed"
      xen/mmu: weaken flush_tlb_other test

 arch/x86/include/asm/required-features.h |    8 ++-
 arch/x86/include/asm/xen/page.h          |    3 +-
 arch/x86/mm/ioremap.c                    |   19 +---
 arch/x86/xen/enlighten.c                 |   76 +++++++++++---
 arch/x86/xen/mmu.c                       |  160 ++++++++++++++++++++++--------
 arch/x86/xen/mmu.h                       |    3 +
 arch/x86/xen/smp.c                       |    4 +-
 arch/x86/xen/xen-ops.h                   |    2 -
 8 files changed, 196 insertions(+), 79 deletions(-)


