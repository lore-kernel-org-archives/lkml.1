Return-Path: <linux-kernel-owner+w=401wt.eu-S934655AbZDIRxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655AbZDIRxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbZDIRxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:53:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758107AbZDIRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:53:23 -0400
Date: Thu, 9 Apr 2009 10:51:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
In-Reply-To: <20090409163300.22778.92061.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain>
References: <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, David Howells wrote:
>
> Move arch headers from include/asm-frv/ to arch/frv/include/asm/.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

I'm not going to apply this one either. This one at least has the deletes, 
but Christ, look at that patch!

Please use "-M" when creating diffs for sending to me, so that the diffs 
are rename diffs, and so that you can _see_ that they are renames. No, 
it's not the git default, but that's because there are still too many crap 
SCM's out there, and too many people using "patch".

When the revolution comes, and the people who haven't converted to git get 
sent to the gulags, we'll make "-M" the default. In the meantime, please 
use it when sending patches for review and for me to apply. Otherwise you 
end up with a patch from hell, wastign everybodys bandwidth and sanity.

Here's what your patch _should_ have looked like. Notice how this patch is 
just 500+ lines and 26k, as opposed to nineteen _thousand_ lines and over 
half a megabyte? But more importantly, notice how now everybody can see 
from just your email that it really is just pure renames - you can 
actually _see_ what you're doing.

(And yes, I can apply your broken patch, and I can verify that it's a 
rename-only thing - it's how I generated the replacement patch, of course. 
But I want to teach people to look at their own patches before they send 
them, and ask themselves "Is this something Linus wants to see? Could I do 
it better? Does it match what I expected?")

		Linus
---
From: David Howells <dhowells@redhat.com>
Date:   Thu Apr 9 17:33:00 2009 +0100
Subject: FRV: Move to arch/frv/include/asm/
    
Move arch headers from include/asm-frv/ to arch/frv/include/asm/.
    
Signed-off-by: David Howells <dhowells@redhat.com>
---
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
 .../asm-frv => arch/frv/include/asm}/thread_info.h |    0
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
 114 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/include/asm-frv/Kbuild b/arch/frv/include/asm/Kbuild
similarity index 100%
rename from include/asm-frv/Kbuild
rename to arch/frv/include/asm/Kbuild
diff --git a/include/asm-frv/atomic.h b/arch/frv/include/asm/atomic.h
similarity index 100%
rename from include/asm-frv/atomic.h
rename to arch/frv/include/asm/atomic.h
diff --git a/include/asm-frv/auxvec.h b/arch/frv/include/asm/auxvec.h
similarity index 100%
rename from include/asm-frv/auxvec.h
rename to arch/frv/include/asm/auxvec.h
diff --git a/include/asm-frv/ax88796.h b/arch/frv/include/asm/ax88796.h
similarity index 100%
rename from include/asm-frv/ax88796.h
rename to arch/frv/include/asm/ax88796.h
diff --git a/include/asm-frv/bitops.h b/arch/frv/include/asm/bitops.h
similarity index 100%
rename from include/asm-frv/bitops.h
rename to arch/frv/include/asm/bitops.h
diff --git a/include/asm-frv/bug.h b/arch/frv/include/asm/bug.h
similarity index 100%
rename from include/asm-frv/bug.h
rename to arch/frv/include/asm/bug.h
diff --git a/include/asm-frv/bugs.h b/arch/frv/include/asm/bugs.h
similarity index 100%
rename from include/asm-frv/bugs.h
rename to arch/frv/include/asm/bugs.h
diff --git a/include/asm-frv/busctl-regs.h b/arch/frv/include/asm/busctl-regs.h
similarity index 100%
rename from include/asm-frv/busctl-regs.h
rename to arch/frv/include/asm/busctl-regs.h
diff --git a/include/asm-frv/byteorder.h b/arch/frv/include/asm/byteorder.h
similarity index 100%
rename from include/asm-frv/byteorder.h
rename to arch/frv/include/asm/byteorder.h
diff --git a/include/asm-frv/cache.h b/arch/frv/include/asm/cache.h
similarity index 100%
rename from include/asm-frv/cache.h
rename to arch/frv/include/asm/cache.h
diff --git a/include/asm-frv/cacheflush.h b/arch/frv/include/asm/cacheflush.h
similarity index 100%
rename from include/asm-frv/cacheflush.h
rename to arch/frv/include/asm/cacheflush.h
diff --git a/include/asm-frv/checksum.h b/arch/frv/include/asm/checksum.h
similarity index 100%
rename from include/asm-frv/checksum.h
rename to arch/frv/include/asm/checksum.h
diff --git a/include/asm-frv/cpu-irqs.h b/arch/frv/include/asm/cpu-irqs.h
similarity index 100%
rename from include/asm-frv/cpu-irqs.h
rename to arch/frv/include/asm/cpu-irqs.h
diff --git a/include/asm-frv/cpumask.h b/arch/frv/include/asm/cpumask.h
similarity index 100%
rename from include/asm-frv/cpumask.h
rename to arch/frv/include/asm/cpumask.h
diff --git a/include/asm-frv/cputime.h b/arch/frv/include/asm/cputime.h
similarity index 100%
rename from include/asm-frv/cputime.h
rename to arch/frv/include/asm/cputime.h
diff --git a/include/asm-frv/current.h b/arch/frv/include/asm/current.h
similarity index 100%
rename from include/asm-frv/current.h
rename to arch/frv/include/asm/current.h
diff --git a/include/asm-frv/delay.h b/arch/frv/include/asm/delay.h
similarity index 100%
rename from include/asm-frv/delay.h
rename to arch/frv/include/asm/delay.h
diff --git a/include/asm-frv/device.h b/arch/frv/include/asm/device.h
similarity index 100%
rename from include/asm-frv/device.h
rename to arch/frv/include/asm/device.h
diff --git a/include/asm-frv/div64.h b/arch/frv/include/asm/div64.h
similarity index 100%
rename from include/asm-frv/div64.h
rename to arch/frv/include/asm/div64.h
diff --git a/include/asm-frv/dm9000.h b/arch/frv/include/asm/dm9000.h
similarity index 100%
rename from include/asm-frv/dm9000.h
rename to arch/frv/include/asm/dm9000.h
diff --git a/include/asm-frv/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
similarity index 100%
rename from include/asm-frv/dma-mapping.h
rename to arch/frv/include/asm/dma-mapping.h
diff --git a/include/asm-frv/dma.h b/arch/frv/include/asm/dma.h
similarity index 100%
rename from include/asm-frv/dma.h
rename to arch/frv/include/asm/dma.h
diff --git a/include/asm-frv/elf.h b/arch/frv/include/asm/elf.h
similarity index 100%
rename from include/asm-frv/elf.h
rename to arch/frv/include/asm/elf.h
diff --git a/include/asm-frv/emergency-restart.h b/arch/frv/include/asm/emergency-restart.h
similarity index 100%
rename from include/asm-frv/emergency-restart.h
rename to arch/frv/include/asm/emergency-restart.h
diff --git a/include/asm-frv/errno.h b/arch/frv/include/asm/errno.h
similarity index 100%
rename from include/asm-frv/errno.h
rename to arch/frv/include/asm/errno.h
diff --git a/include/asm-frv/fb.h b/arch/frv/include/asm/fb.h
similarity index 100%
rename from include/asm-frv/fb.h
rename to arch/frv/include/asm/fb.h
diff --git a/include/asm-frv/fcntl.h b/arch/frv/include/asm/fcntl.h
similarity index 100%
rename from include/asm-frv/fcntl.h
rename to arch/frv/include/asm/fcntl.h
diff --git a/include/asm-frv/fpu.h b/arch/frv/include/asm/fpu.h
similarity index 100%
rename from include/asm-frv/fpu.h
rename to arch/frv/include/asm/fpu.h
diff --git a/include/asm-frv/ftrace.h b/arch/frv/include/asm/ftrace.h
similarity index 100%
rename from include/asm-frv/ftrace.h
rename to arch/frv/include/asm/ftrace.h
diff --git a/include/asm-frv/futex.h b/arch/frv/include/asm/futex.h
similarity index 100%
rename from include/asm-frv/futex.h
rename to arch/frv/include/asm/futex.h
diff --git a/include/asm-frv/gdb-stub.h b/arch/frv/include/asm/gdb-stub.h
similarity index 100%
rename from include/asm-frv/gdb-stub.h
rename to arch/frv/include/asm/gdb-stub.h
diff --git a/include/asm-frv/gpio-regs.h b/arch/frv/include/asm/gpio-regs.h
similarity index 100%
rename from include/asm-frv/gpio-regs.h
rename to arch/frv/include/asm/gpio-regs.h
diff --git a/include/asm-frv/hardirq.h b/arch/frv/include/asm/hardirq.h
similarity index 100%
rename from include/asm-frv/hardirq.h
rename to arch/frv/include/asm/hardirq.h
diff --git a/include/asm-frv/highmem.h b/arch/frv/include/asm/highmem.h
similarity index 100%
rename from include/asm-frv/highmem.h
rename to arch/frv/include/asm/highmem.h
diff --git a/include/asm-frv/hw_irq.h b/arch/frv/include/asm/hw_irq.h
similarity index 100%
rename from include/asm-frv/hw_irq.h
rename to arch/frv/include/asm/hw_irq.h
diff --git a/include/asm-frv/init.h b/arch/frv/include/asm/init.h
similarity index 100%
rename from include/asm-frv/init.h
rename to arch/frv/include/asm/init.h
diff --git a/include/asm-frv/io.h b/arch/frv/include/asm/io.h
similarity index 100%
rename from include/asm-frv/io.h
rename to arch/frv/include/asm/io.h
diff --git a/include/asm-frv/ioctl.h b/arch/frv/include/asm/ioctl.h
similarity index 100%
rename from include/asm-frv/ioctl.h
rename to arch/frv/include/asm/ioctl.h
diff --git a/include/asm-frv/ioctls.h b/arch/frv/include/asm/ioctls.h
similarity index 100%
rename from include/asm-frv/ioctls.h
rename to arch/frv/include/asm/ioctls.h
diff --git a/include/asm-frv/ipcbuf.h b/arch/frv/include/asm/ipcbuf.h
similarity index 100%
rename from include/asm-frv/ipcbuf.h
rename to arch/frv/include/asm/ipcbuf.h
diff --git a/include/asm-frv/irc-regs.h b/arch/frv/include/asm/irc-regs.h
similarity index 100%
rename from include/asm-frv/irc-regs.h
rename to arch/frv/include/asm/irc-regs.h
diff --git a/include/asm-frv/irq.h b/arch/frv/include/asm/irq.h
similarity index 100%
rename from include/asm-frv/irq.h
rename to arch/frv/include/asm/irq.h
diff --git a/include/asm-frv/irq_regs.h b/arch/frv/include/asm/irq_regs.h
similarity index 100%
rename from include/asm-frv/irq_regs.h
rename to arch/frv/include/asm/irq_regs.h
diff --git a/include/asm-frv/kdebug.h b/arch/frv/include/asm/kdebug.h
similarity index 100%
rename from include/asm-frv/kdebug.h
rename to arch/frv/include/asm/kdebug.h
diff --git a/include/asm-frv/kmap_types.h b/arch/frv/include/asm/kmap_types.h
similarity index 100%
rename from include/asm-frv/kmap_types.h
rename to arch/frv/include/asm/kmap_types.h
diff --git a/include/asm-frv/linkage.h b/arch/frv/include/asm/linkage.h
similarity index 100%
rename from include/asm-frv/linkage.h
rename to arch/frv/include/asm/linkage.h
diff --git a/include/asm-frv/local.h b/arch/frv/include/asm/local.h
similarity index 100%
rename from include/asm-frv/local.h
rename to arch/frv/include/asm/local.h
diff --git a/include/asm-frv/math-emu.h b/arch/frv/include/asm/math-emu.h
similarity index 100%
rename from include/asm-frv/math-emu.h
rename to arch/frv/include/asm/math-emu.h
diff --git a/include/asm-frv/mb-regs.h b/arch/frv/include/asm/mb-regs.h
similarity index 100%
rename from include/asm-frv/mb-regs.h
rename to arch/frv/include/asm/mb-regs.h
diff --git a/include/asm-frv/mb86943a.h b/arch/frv/include/asm/mb86943a.h
similarity index 100%
rename from include/asm-frv/mb86943a.h
rename to arch/frv/include/asm/mb86943a.h
diff --git a/include/asm-frv/mb93091-fpga-irqs.h b/arch/frv/include/asm/mb93091-fpga-irqs.h
similarity index 100%
rename from include/asm-frv/mb93091-fpga-irqs.h
rename to arch/frv/include/asm/mb93091-fpga-irqs.h
diff --git a/include/asm-frv/mb93093-fpga-irqs.h b/arch/frv/include/asm/mb93093-fpga-irqs.h
similarity index 100%
rename from include/asm-frv/mb93093-fpga-irqs.h
rename to arch/frv/include/asm/mb93093-fpga-irqs.h
diff --git a/include/asm-frv/mb93493-irqs.h b/arch/frv/include/asm/mb93493-irqs.h
similarity index 100%
rename from include/asm-frv/mb93493-irqs.h
rename to arch/frv/include/asm/mb93493-irqs.h
diff --git a/include/asm-frv/mb93493-regs.h b/arch/frv/include/asm/mb93493-regs.h
similarity index 100%
rename from include/asm-frv/mb93493-regs.h
rename to arch/frv/include/asm/mb93493-regs.h
diff --git a/include/asm-frv/mc146818rtc.h b/arch/frv/include/asm/mc146818rtc.h
similarity index 100%
rename from include/asm-frv/mc146818rtc.h
rename to arch/frv/include/asm/mc146818rtc.h
diff --git a/include/asm-frv/mem-layout.h b/arch/frv/include/asm/mem-layout.h
similarity index 100%
rename from include/asm-frv/mem-layout.h
rename to arch/frv/include/asm/mem-layout.h
diff --git a/include/asm-frv/mman.h b/arch/frv/include/asm/mman.h
similarity index 100%
rename from include/asm-frv/mman.h
rename to arch/frv/include/asm/mman.h
diff --git a/include/asm-frv/mmu.h b/arch/frv/include/asm/mmu.h
similarity index 100%
rename from include/asm-frv/mmu.h
rename to arch/frv/include/asm/mmu.h
diff --git a/include/asm-frv/mmu_context.h b/arch/frv/include/asm/mmu_context.h
similarity index 100%
rename from include/asm-frv/mmu_context.h
rename to arch/frv/include/asm/mmu_context.h
diff --git a/include/asm-frv/module.h b/arch/frv/include/asm/module.h
similarity index 100%
rename from include/asm-frv/module.h
rename to arch/frv/include/asm/module.h
diff --git a/include/asm-frv/msgbuf.h b/arch/frv/include/asm/msgbuf.h
similarity index 100%
rename from include/asm-frv/msgbuf.h
rename to arch/frv/include/asm/msgbuf.h
diff --git a/include/asm-frv/mutex.h b/arch/frv/include/asm/mutex.h
similarity index 100%
rename from include/asm-frv/mutex.h
rename to arch/frv/include/asm/mutex.h
diff --git a/include/asm-frv/page.h b/arch/frv/include/asm/page.h
similarity index 100%
rename from include/asm-frv/page.h
rename to arch/frv/include/asm/page.h
diff --git a/include/asm-frv/param.h b/arch/frv/include/asm/param.h
similarity index 100%
rename from include/asm-frv/param.h
rename to arch/frv/include/asm/param.h
diff --git a/include/asm-frv/pci.h b/arch/frv/include/asm/pci.h
similarity index 100%
rename from include/asm-frv/pci.h
rename to arch/frv/include/asm/pci.h
diff --git a/include/asm-frv/percpu.h b/arch/frv/include/asm/percpu.h
similarity index 100%
rename from include/asm-frv/percpu.h
rename to arch/frv/include/asm/percpu.h
diff --git a/include/asm-frv/pgalloc.h b/arch/frv/include/asm/pgalloc.h
similarity index 100%
rename from include/asm-frv/pgalloc.h
rename to arch/frv/include/asm/pgalloc.h
diff --git a/include/asm-frv/pgtable.h b/arch/frv/include/asm/pgtable.h
similarity index 100%
rename from include/asm-frv/pgtable.h
rename to arch/frv/include/asm/pgtable.h
diff --git a/include/asm-frv/poll.h b/arch/frv/include/asm/poll.h
similarity index 100%
rename from include/asm-frv/poll.h
rename to arch/frv/include/asm/poll.h
diff --git a/include/asm-frv/posix_types.h b/arch/frv/include/asm/posix_types.h
similarity index 100%
rename from include/asm-frv/posix_types.h
rename to arch/frv/include/asm/posix_types.h
diff --git a/include/asm-frv/processor.h b/arch/frv/include/asm/processor.h
similarity index 100%
rename from include/asm-frv/processor.h
rename to arch/frv/include/asm/processor.h
diff --git a/include/asm-frv/ptrace.h b/arch/frv/include/asm/ptrace.h
similarity index 100%
rename from include/asm-frv/ptrace.h
rename to arch/frv/include/asm/ptrace.h
diff --git a/include/asm-frv/registers.h b/arch/frv/include/asm/registers.h
similarity index 100%
rename from include/asm-frv/registers.h
rename to arch/frv/include/asm/registers.h
diff --git a/include/asm-frv/resource.h b/arch/frv/include/asm/resource.h
similarity index 100%
rename from include/asm-frv/resource.h
rename to arch/frv/include/asm/resource.h
diff --git a/include/asm-frv/scatterlist.h b/arch/frv/include/asm/scatterlist.h
similarity index 100%
rename from include/asm-frv/scatterlist.h
rename to arch/frv/include/asm/scatterlist.h
diff --git a/include/asm-frv/sections.h b/arch/frv/include/asm/sections.h
similarity index 100%
rename from include/asm-frv/sections.h
rename to arch/frv/include/asm/sections.h
diff --git a/include/asm-frv/segment.h b/arch/frv/include/asm/segment.h
similarity index 100%
rename from include/asm-frv/segment.h
rename to arch/frv/include/asm/segment.h
diff --git a/include/asm-frv/sembuf.h b/arch/frv/include/asm/sembuf.h
similarity index 100%
rename from include/asm-frv/sembuf.h
rename to arch/frv/include/asm/sembuf.h
diff --git a/include/asm-frv/serial-regs.h b/arch/frv/include/asm/serial-regs.h
similarity index 100%
rename from include/asm-frv/serial-regs.h
rename to arch/frv/include/asm/serial-regs.h
diff --git a/include/asm-frv/serial.h b/arch/frv/include/asm/serial.h
similarity index 100%
rename from include/asm-frv/serial.h
rename to arch/frv/include/asm/serial.h
diff --git a/include/asm-frv/setup.h b/arch/frv/include/asm/setup.h
similarity index 100%
rename from include/asm-frv/setup.h
rename to arch/frv/include/asm/setup.h
diff --git a/include/asm-frv/shmbuf.h b/arch/frv/include/asm/shmbuf.h
similarity index 100%
rename from include/asm-frv/shmbuf.h
rename to arch/frv/include/asm/shmbuf.h
diff --git a/include/asm-frv/shmparam.h b/arch/frv/include/asm/shmparam.h
similarity index 100%
rename from include/asm-frv/shmparam.h
rename to arch/frv/include/asm/shmparam.h
diff --git a/include/asm-frv/sigcontext.h b/arch/frv/include/asm/sigcontext.h
similarity index 100%
rename from include/asm-frv/sigcontext.h
rename to arch/frv/include/asm/sigcontext.h
diff --git a/include/asm-frv/siginfo.h b/arch/frv/include/asm/siginfo.h
similarity index 100%
rename from include/asm-frv/siginfo.h
rename to arch/frv/include/asm/siginfo.h
diff --git a/include/asm-frv/signal.h b/arch/frv/include/asm/signal.h
similarity index 100%
rename from include/asm-frv/signal.h
rename to arch/frv/include/asm/signal.h
diff --git a/include/asm-frv/smp.h b/arch/frv/include/asm/smp.h
similarity index 100%
rename from include/asm-frv/smp.h
rename to arch/frv/include/asm/smp.h
diff --git a/include/asm-frv/socket.h b/arch/frv/include/asm/socket.h
similarity index 100%
rename from include/asm-frv/socket.h
rename to arch/frv/include/asm/socket.h
diff --git a/include/asm-frv/sockios.h b/arch/frv/include/asm/sockios.h
similarity index 100%
rename from include/asm-frv/sockios.h
rename to arch/frv/include/asm/sockios.h
diff --git a/include/asm-frv/spinlock.h b/arch/frv/include/asm/spinlock.h
similarity index 100%
rename from include/asm-frv/spinlock.h
rename to arch/frv/include/asm/spinlock.h
diff --git a/include/asm-frv/spr-regs.h b/arch/frv/include/asm/spr-regs.h
similarity index 100%
rename from include/asm-frv/spr-regs.h
rename to arch/frv/include/asm/spr-regs.h
diff --git a/include/asm-frv/stat.h b/arch/frv/include/asm/stat.h
similarity index 100%
rename from include/asm-frv/stat.h
rename to arch/frv/include/asm/stat.h
diff --git a/include/asm-frv/statfs.h b/arch/frv/include/asm/statfs.h
similarity index 100%
rename from include/asm-frv/statfs.h
rename to arch/frv/include/asm/statfs.h
diff --git a/include/asm-frv/string.h b/arch/frv/include/asm/string.h
similarity index 100%
rename from include/asm-frv/string.h
rename to arch/frv/include/asm/string.h
diff --git a/include/asm-frv/suspend.h b/arch/frv/include/asm/suspend.h
similarity index 100%
rename from include/asm-frv/suspend.h
rename to arch/frv/include/asm/suspend.h
diff --git a/include/asm-frv/swab.h b/arch/frv/include/asm/swab.h
similarity index 100%
rename from include/asm-frv/swab.h
rename to arch/frv/include/asm/swab.h
diff --git a/include/asm-frv/system.h b/arch/frv/include/asm/system.h
similarity index 100%
rename from include/asm-frv/system.h
rename to arch/frv/include/asm/system.h
diff --git a/include/asm-frv/termbits.h b/arch/frv/include/asm/termbits.h
similarity index 100%
rename from include/asm-frv/termbits.h
rename to arch/frv/include/asm/termbits.h
diff --git a/include/asm-frv/termios.h b/arch/frv/include/asm/termios.h
similarity index 100%
rename from include/asm-frv/termios.h
rename to arch/frv/include/asm/termios.h
diff --git a/include/asm-frv/thread_info.h b/arch/frv/include/asm/thread_info.h
similarity index 100%
rename from include/asm-frv/thread_info.h
rename to arch/frv/include/asm/thread_info.h
diff --git a/include/asm-frv/timer-regs.h b/arch/frv/include/asm/timer-regs.h
similarity index 100%
rename from include/asm-frv/timer-regs.h
rename to arch/frv/include/asm/timer-regs.h
diff --git a/include/asm-frv/timex.h b/arch/frv/include/asm/timex.h
similarity index 100%
rename from include/asm-frv/timex.h
rename to arch/frv/include/asm/timex.h
diff --git a/include/asm-frv/tlb.h b/arch/frv/include/asm/tlb.h
similarity index 100%
rename from include/asm-frv/tlb.h
rename to arch/frv/include/asm/tlb.h
diff --git a/include/asm-frv/tlbflush.h b/arch/frv/include/asm/tlbflush.h
similarity index 100%
rename from include/asm-frv/tlbflush.h
rename to arch/frv/include/asm/tlbflush.h
diff --git a/include/asm-frv/topology.h b/arch/frv/include/asm/topology.h
similarity index 100%
rename from include/asm-frv/topology.h
rename to arch/frv/include/asm/topology.h
diff --git a/include/asm-frv/types.h b/arch/frv/include/asm/types.h
similarity index 100%
rename from include/asm-frv/types.h
rename to arch/frv/include/asm/types.h
diff --git a/include/asm-frv/uaccess.h b/arch/frv/include/asm/uaccess.h
similarity index 100%
rename from include/asm-frv/uaccess.h
rename to arch/frv/include/asm/uaccess.h
diff --git a/include/asm-frv/ucontext.h b/arch/frv/include/asm/ucontext.h
similarity index 100%
rename from include/asm-frv/ucontext.h
rename to arch/frv/include/asm/ucontext.h
diff --git a/include/asm-frv/unaligned.h b/arch/frv/include/asm/unaligned.h
similarity index 100%
rename from include/asm-frv/unaligned.h
rename to arch/frv/include/asm/unaligned.h
diff --git a/include/asm-frv/unistd.h b/arch/frv/include/asm/unistd.h
similarity index 100%
rename from include/asm-frv/unistd.h
rename to arch/frv/include/asm/unistd.h
diff --git a/include/asm-frv/user.h b/arch/frv/include/asm/user.h
similarity index 100%
rename from include/asm-frv/user.h
rename to arch/frv/include/asm/user.h
diff --git a/include/asm-frv/vga.h b/arch/frv/include/asm/vga.h
similarity index 100%
rename from include/asm-frv/vga.h
rename to arch/frv/include/asm/vga.h
diff --git a/include/asm-frv/virtconvert.h b/arch/frv/include/asm/virtconvert.h
similarity index 100%
rename from include/asm-frv/virtconvert.h
rename to arch/frv/include/asm/virtconvert.h
diff --git a/include/asm-frv/xor.h b/arch/frv/include/asm/xor.h
similarity index 100%
rename from include/asm-frv/xor.h
rename to arch/frv/include/asm/xor.h
