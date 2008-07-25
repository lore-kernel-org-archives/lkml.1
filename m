Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYGYGw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYGYGw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 02:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYGYGwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 02:52:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:48212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYGYGwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 02:52:20 -0400
Subject: [git pull] x86: patches for tip/x86/prototypes
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf8
Date: Fri, 25 Jul 2008 12:21:09 +0530
Message-Id: <1216968669.18082.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hello Ingo,

Please pull these patches for tip/x86/prototypes.

I have also verify that these are merge-able with tip/master and working.

﻿The following changes since commit 71e3b818431957371c7f69fa1c576d4a403c1478:
  Jaswinder Singh (1):
        x86: mach-default/setup.c declare no_broadcast before they get used

are available in the git repository at:

  git://git.infradead.org/users/jaswinder/linux-2.6-tip.git x86/prototypes-for-tip

Jaswinder Singh (6):
      x86_64: Declare new_utsname in asm-x86/syscalls.h
      X86_32: declare pt_regs_access as unsigned long
      X86_SMP: smp.c declare functions before they get used
      X86_SMP: smpboot.c declare idle_thread_array and smp_b_stepping as static
      X86_SMP: ipi.c declare functions before they get used
      X86_SMP: tlb_XX.c declare smp_invalidate_interrupt before they get used

 arch/x86/kernel/ipi.c      |    3 ++-
 arch/x86/kernel/ptrace.c   |    2 +-
 arch/x86/kernel/smpboot.c  |    4 ++--
 include/asm-x86/hw_irq.h   |   10 ++++++++++
 include/asm-x86/syscalls.h |    2 +-
 5 files changed, 16 insertions(+), 5 deletions(-)


