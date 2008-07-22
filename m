Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYGVM3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYGVM3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYGVM25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:28:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:50720 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYGVM25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:28:57 -0400
Subject: [git pull] x86: declaration fixes - version 2
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 17:57:53 +0530
Message-Id: <1216729673.5338.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Here is updated patches for x86-tip.

The following changes since commit 087115517d43c25e7286a62bf4d458becef5a244:
  Ingo Molnar (1):
        Merge branch 'xen-64bit'

are available in the git repository at:

  git://git.infradead.org/users/jaswinder/linux-2.6-tip.git master

Jaswinder Singh (13):
      x86: Introducing asm/syscalls.h
      x86: process_32.c declare cpu_number before they get used
      x86: signal_XX.c declare do_notify_resume before they get used
      x86: time_XX.c declare functions before they get used
      x86: setup.c declare saved_video_mode before they get used
      x86: e820.c declare pci_mem_start before they get used
      x86: pci-dma.c declare iommu_bio_merge before they get used
      x86: pci-nommu.c declare nommu_dma_ops before they get used
      x86: i387.c declare dump_fpu() before they get used
      x86: ptrace.c declare functions before they get used
      x86: proc.c declare cpuinfo_op before they get used
      x86: common.c declare idle_regs before they get used
      x86: mtrr/main.c declare range_state as static

 arch/x86/kernel/cpu/mtrr/main.c |    2 +-
 arch/x86/kernel/ioport.c        |    1 +
 arch/x86/kernel/ldt.c           |    1 +
 arch/x86/kernel/process_32.c    |    2 +
 arch/x86/kernel/process_64.c    |    1 +
 arch/x86/kernel/signal_32.c     |    1 +
 arch/x86/kernel/signal_64.c     |    1 +
 arch/x86/kernel/sys_i386_32.c   |    2 +
 arch/x86/kernel/sys_x86_64.c    |    1 +
 arch/x86/kernel/time_32.c       |    1 +
 arch/x86/kernel/tls.c           |    1 +
 arch/x86/kernel/vm86_32.c       |    1 +
 include/asm-x86/dma-mapping.h   |    1 +
 include/asm-x86/e820.h          |    1 +
 include/asm-x86/i387.h          |    1 +
 include/asm-x86/io.h            |    2 +
 include/asm-x86/io_64.h         |    1 -
 include/asm-x86/processor.h     |    4 ++
 include/asm-x86/ptrace.h        |    3 +
 include/asm-x86/setup.h         |    1 +
 include/asm-x86/signal.h        |    3 +
 include/asm-x86/smp.h           |    4 +-
 include/asm-x86/syscalls.h      |   90 +++++++++++++++++++++++++++++++++++++++
 include/asm-x86/time.h          |    2 +
 include/asm-x86/timer.h         |    5 ++-
 25 files changed, 129 insertions(+), 4 deletions(-)
 create mode 100644 include/asm-x86/syscalls.h


