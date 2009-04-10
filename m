Return-Path: <linux-kernel-owner+w=401wt.eu-S1765323AbZDJBIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765323AbZDJBIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbZDJBIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:08:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47158 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbZDJBIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:08:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904091645010.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091645010.4583@localhost.localdomain> <alpine.LFD.2.00.0904091628580.4583@localhost.localdomain> <20090409232152.13220.28141.stgit@warthog.procyon.org.uk> <20090409232157.13220.63863.stgit@warthog.procyon.org.uk> <13476.1239320297@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
Date: Fri, 10 Apr 2009 02:06:49 +0100
Message-ID: <15445.1239325609@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > I think I'd probably better off sticking this in a GIT tree and getting
> > you to pull it.
> 
> Heh. Yes, then you can use the "git request-pull" script that does it all 
> for you.

Okay...  Tried that.  It's giving an incomprehensible warning:

	warn:   e69cc92: FRV: Move to arch/frv/include/asm/

and:

	warn: No branch of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-frv.git is at:
	warn: Are you sure you pushed HEAD there?

and:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-frv.git ..BRANCH.NOT.VERIFIED..

Running 'git show' in the remote repository, and that shows the patches I've
committed on the master branch as expected, as does 'git log'.

Is this due to the web server taking its time to register the changes to the
git repositories?  git-ls-remote says:

	warthog>git-ls-remote git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-frv.git master
	62b8e680e61d3f48f2a12ee248ca03ea8f376926        refs/heads/master

but this is not true according to the data in the repo.

Anyway...  I've attached a pull request.

David
---
The following changes since commit 62b8e680e61d3f48f2a12ee248ca03ea8f376926:
  David Howells (1):
        MN10300: Kill MN10300's own profiling Kconfig

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-frv.git ..BRANCH.NOT.VERIFIED..

David Howells (2):
      FRV: Fix indentation errors to keep git-am happy when moving arch header files
      FRV: Move to arch/frv/include/asm/

 {include/asm-frv => arch/frv/include/asm}/Kbuild   |    0
 {include/asm-frv => arch/frv/include/asm}/atomic.h |    0
 {include/asm-frv => arch/frv/include/asm}/auxvec.h |    0
 .../asm-frv => arch/frv/include/asm}/ax88796.h     |    0
 {include/asm-frv => arch/frv/include/asm}/bitops.h |    0
 {include/asm-frv => arch/frv/include/asm}/bug.h    |    0
 {include/asm-frv => arch/frv/include/asm}/bugs.h   |    0
 .../asm-frv => arch/frv/include/asm}/busctl-regs.h |    0
 .../asm-frv => arch/frv/include/asm}/byteorder.h   |    0
 {include/asm-frv => arch/frv/include/asm}/cache.h  |    0
 .../asm-frv => arch/frv/include/asm}/cacheflush.h  |    0
 .../asm-frv => arch/frv/include/asm}/checksum.h    |    0
 .../asm-frv => arch/frv/include/asm}/cpu-irqs.h    |    0
 .../asm-frv => arch/frv/include/asm}/cpumask.h     |    0
 .../asm-frv => arch/frv/include/asm}/cputime.h     |    0
 .../asm-frv => arch/frv/include/asm}/current.h     |    0
 {include/asm-frv => arch/frv/include/asm}/delay.h  |    0
 {include/asm-frv => arch/frv/include/asm}/device.h |    0
 {include/asm-frv => arch/frv/include/asm}/div64.h  |    0
 {include/asm-frv => arch/frv/include/asm}/dm9000.h |    0
 .../asm-frv => arch/frv/include/asm}/dma-mapping.h |    0
 {include/asm-frv => arch/frv/include/asm}/dma.h    |    0
 {include/asm-frv => arch/frv/include/asm}/elf.h    |    0
 .../frv/include/asm}/emergency-restart.h           |    0
 {include/asm-frv => arch/frv/include/asm}/errno.h  |    0
 {include/asm-frv => arch/frv/include/asm}/fb.h     |    0
 {include/asm-frv => arch/frv/include/asm}/fcntl.h  |    0
 {include/asm-frv => arch/frv/include/asm}/fpu.h    |    0
 {include/asm-frv => arch/frv/include/asm}/ftrace.h |    0
 {include/asm-frv => arch/frv/include/asm}/futex.h  |    0
 .../asm-frv => arch/frv/include/asm}/gdb-stub.h    |    0
 .../asm-frv => arch/frv/include/asm}/gpio-regs.h   |    0
 .../asm-frv => arch/frv/include/asm}/hardirq.h     |    0
 .../asm-frv => arch/frv/include/asm}/highmem.h     |    0
 {include/asm-frv => arch/frv/include/asm}/hw_irq.h |    0
 {include/asm-frv => arch/frv/include/asm}/init.h   |    0
 {include/asm-frv => arch/frv/include/asm}/io.h     |    0
 {include/asm-frv => arch/frv/include/asm}/ioctl.h  |    0
 {include/asm-frv => arch/frv/include/asm}/ioctls.h |    0
 {include/asm-frv => arch/frv/include/asm}/ipcbuf.h |    0
 .../asm-frv => arch/frv/include/asm}/irc-regs.h    |    0
 {include/asm-frv => arch/frv/include/asm}/irq.h    |    0
 .../asm-frv => arch/frv/include/asm}/irq_regs.h    |    0
 {include/asm-frv => arch/frv/include/asm}/kdebug.h |    0
 .../asm-frv => arch/frv/include/asm}/kmap_types.h  |    0
 .../asm-frv => arch/frv/include/asm}/linkage.h     |    0
 {include/asm-frv => arch/frv/include/asm}/local.h  |    0
 .../asm-frv => arch/frv/include/asm}/math-emu.h    |    0
 .../asm-frv => arch/frv/include/asm}/mb-regs.h     |    0
 .../asm-frv => arch/frv/include/asm}/mb86943a.h    |    0
 .../frv/include/asm}/mb93091-fpga-irqs.h           |    0
 .../frv/include/asm}/mb93093-fpga-irqs.h           |    0
 .../frv/include/asm}/mb93493-irqs.h                |    0
 .../frv/include/asm}/mb93493-regs.h                |    0
 .../asm-frv => arch/frv/include/asm}/mc146818rtc.h |    0
 .../asm-frv => arch/frv/include/asm}/mem-layout.h  |    0
 {include/asm-frv => arch/frv/include/asm}/mman.h   |    0
 {include/asm-frv => arch/frv/include/asm}/mmu.h    |    0
 .../asm-frv => arch/frv/include/asm}/mmu_context.h |    0
 {include/asm-frv => arch/frv/include/asm}/module.h |    0
 {include/asm-frv => arch/frv/include/asm}/msgbuf.h |    0
 {include/asm-frv => arch/frv/include/asm}/mutex.h  |    0
 {include/asm-frv => arch/frv/include/asm}/page.h   |    0
 {include/asm-frv => arch/frv/include/asm}/param.h  |    0
 {include/asm-frv => arch/frv/include/asm}/pci.h    |    0
 {include/asm-frv => arch/frv/include/asm}/percpu.h |    0
 .../asm-frv => arch/frv/include/asm}/pgalloc.h     |    0
 .../asm-frv => arch/frv/include/asm}/pgtable.h     |    0
 {include/asm-frv => arch/frv/include/asm}/poll.h   |    0
 .../asm-frv => arch/frv/include/asm}/posix_types.h |    0
 .../asm-frv => arch/frv/include/asm}/processor.h   |    0
 {include/asm-frv => arch/frv/include/asm}/ptrace.h |    0
 .../asm-frv => arch/frv/include/asm}/registers.h   |    0
 .../asm-frv => arch/frv/include/asm}/resource.h    |    0
 .../asm-frv => arch/frv/include/asm}/scatterlist.h |    0
 .../asm-frv => arch/frv/include/asm}/sections.h    |    0
 .../asm-frv => arch/frv/include/asm}/segment.h     |    0
 {include/asm-frv => arch/frv/include/asm}/sembuf.h |    0
 .../asm-frv => arch/frv/include/asm}/serial-regs.h |    0
 {include/asm-frv => arch/frv/include/asm}/serial.h |    0
 {include/asm-frv => arch/frv/include/asm}/setup.h  |    0
 {include/asm-frv => arch/frv/include/asm}/shmbuf.h |    0
 .../asm-frv => arch/frv/include/asm}/shmparam.h    |    0
 .../asm-frv => arch/frv/include/asm}/sigcontext.h  |    0
 .../asm-frv => arch/frv/include/asm}/siginfo.h     |    0
 {include/asm-frv => arch/frv/include/asm}/signal.h |    0
 {include/asm-frv => arch/frv/include/asm}/smp.h    |    0
 {include/asm-frv => arch/frv/include/asm}/socket.h |    0
 .../asm-frv => arch/frv/include/asm}/sockios.h     |    0
 .../asm-frv => arch/frv/include/asm}/spinlock.h    |    0
 .../asm-frv => arch/frv/include/asm}/spr-regs.h    |    0
 {include/asm-frv => arch/frv/include/asm}/stat.h   |    0
 {include/asm-frv => arch/frv/include/asm}/statfs.h |    0
 {include/asm-frv => arch/frv/include/asm}/string.h |    0
 .../asm-frv => arch/frv/include/asm}/suspend.h     |    0
 {include/asm-frv => arch/frv/include/asm}/swab.h   |    0
 {include/asm-frv => arch/frv/include/asm}/system.h |    0
 .../asm-frv => arch/frv/include/asm}/termbits.h    |    0
 .../asm-frv => arch/frv/include/asm}/termios.h     |    0
 .../asm-frv => arch/frv/include/asm}/thread_info.h |    6 +++---
 .../asm-frv => arch/frv/include/asm}/timer-regs.h  |    0
 {include/asm-frv => arch/frv/include/asm}/timex.h  |    0
 {include/asm-frv => arch/frv/include/asm}/tlb.h    |    0
 .../asm-frv => arch/frv/include/asm}/tlbflush.h    |    0
 .../asm-frv => arch/frv/include/asm}/topology.h    |    0
 {include/asm-frv => arch/frv/include/asm}/types.h  |    0
 .../asm-frv => arch/frv/include/asm}/uaccess.h     |    0
 .../asm-frv => arch/frv/include/asm}/ucontext.h    |    0
 .../asm-frv => arch/frv/include/asm}/unaligned.h   |    0
 {include/asm-frv => arch/frv/include/asm}/unistd.h |    0
 {include/asm-frv => arch/frv/include/asm}/user.h   |    0
 {include/asm-frv => arch/frv/include/asm}/vga.h    |    0
 .../asm-frv => arch/frv/include/asm}/virtconvert.h |    0
 {include/asm-frv => arch/frv/include/asm}/xor.h    |    0
 114 files changed, 3 insertions(+), 3 deletions(-)
 rename {include/asm-frv => arch/frv/include/asm}/Kbuild (100%)
 rename {include/asm-frv => arch/frv/include/asm}/atomic.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/auxvec.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ax88796.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/bitops.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/bug.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/bugs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/busctl-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/byteorder.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cache.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cacheflush.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/checksum.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cpu-irqs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cpumask.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cputime.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/current.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/delay.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/device.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/div64.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/dm9000.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/dma-mapping.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/dma.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/elf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/emergency-restart.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/errno.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/fb.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/fcntl.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/fpu.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ftrace.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/futex.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/gdb-stub.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/gpio-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/hardirq.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/highmem.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/hw_irq.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/init.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/io.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ioctl.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ioctls.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ipcbuf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/irc-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/irq.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/irq_regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/kdebug.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/kmap_types.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/linkage.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/local.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/math-emu.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb86943a.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb93091-fpga-irqs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb93093-fpga-irqs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb93493-irqs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb93493-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mem-layout.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mman.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mmu.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mmu_context.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/module.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/msgbuf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mutex.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/page.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/param.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/pci.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/percpu.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/pgalloc.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/pgtable.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/poll.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/posix_types.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/processor.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ptrace.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/registers.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/resource.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/scatterlist.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/sections.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/segment.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/sembuf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/serial-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/serial.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/setup.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/shmbuf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/shmparam.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/sigcontext.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/siginfo.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/signal.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/smp.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/socket.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/sockios.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/spinlock.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/spr-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/stat.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/statfs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/string.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/suspend.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/swab.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/system.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/termbits.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/termios.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/thread_info.h (97%)
 rename {include/asm-frv => arch/frv/include/asm}/timer-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/timex.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/tlb.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/tlbflush.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/topology.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/types.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/uaccess.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ucontext.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/unaligned.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/unistd.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/user.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/vga.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/virtconvert.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/xor.h (100%)
