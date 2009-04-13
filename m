Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZDMSfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZDMSfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZDMSfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:35:44 -0400
Received: from gw.goop.org ([64.81.55.164]:38750 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbZDMSfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:35:43 -0400
Message-ID: <49E385FE.8050902@goop.org>
Date: Mon, 13 Apr 2009 11:35:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Xen bugfixes for -rc1
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this set of Xen bugfixes/cleanups for -rc[12].

Thanks,
    J

The following changes since commit 577c9c456f0e1371cbade38eaf91ae8e8a308555:
  Linus Torvalds (1):
        Linux 2.6.30-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-rc1/xen/core

Alex Nixon (1):
      Xen: Add virt_to_pfn helper function

Hannes Eder (1):
      NULL noise: arch/x86/xen/smp.c

Ian Campbell (2):
      xen: resume interrupts before system devices.
      xen: honour VCPU availability on boot

Jeremy Fitzhardinge (13):
      xen: disable preempt for leave_lazy_mmu
      xen: separate p2m allocation from setting
      xen: split construction of p2m mfn tables from registration
      xen: clean up xen_load_gdt
      xen: make xen_load_gdt simpler
      xen: remove xen_load_gdt debug
      xen: mask XSAVE from cpuid
      x86-64: remove PGE from must-have feature list
      xen/mmu: some early pagetable cleanups
      xen/mmu: weaken flush_tlb_other test
      xen: set _PAGE_NX in __supported_pte_mask before pagetable construction
      xen: clean up gate trap/interrupt constants
      xen: add FIX_TEXT_POKE to fixmap

 arch/x86/include/asm/required-features.h |    2 +-
 arch/x86/include/asm/xen/page.h          |    3 +-
 arch/x86/xen/enlighten.c                 |   89 ++++++++++++++++++-----
 arch/x86/xen/mmu.c                       |  116 +++++++++++++++++++++---------
 arch/x86/xen/mmu.h                       |    3 +
 arch/x86/xen/smp.c                       |    4 +-
 arch/x86/xen/xen-ops.h                   |    2 -
 drivers/xen/cpu_hotplug.c                |   40 ++++++++---
 drivers/xen/manage.c                     |    5 +-
 9 files changed, 193 insertions(+), 71 deletions(-)


