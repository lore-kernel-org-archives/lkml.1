Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYDUXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYDUXh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYDUXhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:37:16 -0400
Received: from rex.snapgear.com ([203.143.235.140]:57951 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753947AbYDUXhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:37:13 -0400
Message-ID: <480D2522.1020302@snapgear.com>
Date: Tue, 22 Apr 2008 09:37:06 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Miles Bader <miles@gnu.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove the v850 port
References: <20080421213321.GD2633@cs181133002.pp.htv.fi>
In-Reply-To: <20080421213321.GD2633@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adrian Bunk wrote:
> Trying to compile the v850 port brings many compile errors, one of
> them exists since at least kernel 2.6.19.
> 
> There also seems to be noone willing to bring this port back into a
> usable state.
> 
> This patch therefore removes the v850 port.
> 
> If anyone ever decides to revive the v850 port the code will still be
> available from older kernels, and it wouldn't be impossible for the port
> to reenter the kernel if it would become actively maintained again.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
> 
> This patch has been sent on:
> - 14 Apr 2008
> - 31 Mar 2008
> - 3 Mar 2008
> - 27 Feb 2008
> - 13 Feb 2008
> - 29 Jan 2008
> 
> Due to it's size, the patch is attached compressed.
> 
>  MAINTAINERS                            |    3 
>  arch/v850/Kconfig                      |  353 -------
>  arch/v850/Kconfig.debug                |   10 
>  arch/v850/Makefile                     |   54 -
>  arch/v850/README                       |   44 
>  arch/v850/configs/rte-ma1-cb_defconfig |  617 -------------
>  arch/v850/configs/rte-me2-cb_defconfig |  462 ----------
>  arch/v850/configs/sim_defconfig        |  451 ----------
>  arch/v850/kernel/Makefile              |   40 
>  arch/v850/kernel/anna-rom.ld           |   16 
>  arch/v850/kernel/anna.c                |  202 ----
>  arch/v850/kernel/anna.ld               |   20 
>  arch/v850/kernel/as85ep1-rom.ld        |   21 
>  arch/v850/kernel/as85ep1.c             |  234 -----
>  arch/v850/kernel/as85ep1.ld            |   49 -
>  arch/v850/kernel/asm-offsets.c         |   61 -
>  arch/v850/kernel/bug.c                 |  142 ---
>  arch/v850/kernel/entry.S               | 1121 -------------------------
>  arch/v850/kernel/fpga85e2c.c           |  167 ---
>  arch/v850/kernel/fpga85e2c.ld          |   62 -
>  arch/v850/kernel/gbus_int.c            |  271 ------
>  arch/v850/kernel/head.S                |  128 --
>  arch/v850/kernel/highres_timer.c       |  132 --
>  arch/v850/kernel/init_task.c           |   49 -
>  arch/v850/kernel/intv.S                |   87 -
>  arch/v850/kernel/irq.c                 |  123 --
>  arch/v850/kernel/ma.c                  |   69 -
>  arch/v850/kernel/mach.c                |   17 
>  arch/v850/kernel/mach.h                |   56 -
>  arch/v850/kernel/me2.c                 |   73 -
>  arch/v850/kernel/memcons.c             |  135 ---
>  arch/v850/kernel/module.c              |  237 -----
>  arch/v850/kernel/process.c             |  217 ----
>  arch/v850/kernel/procfs.c              |   67 -
>  arch/v850/kernel/ptrace.c              |  235 -----
>  arch/v850/kernel/rte_cb.c              |  193 ----
>  arch/v850/kernel/rte_cb_leds.c         |  137 ---
>  arch/v850/kernel/rte_cb_multi.c        |  121 --
>  arch/v850/kernel/rte_ma1_cb-rom.ld     |   14 
>  arch/v850/kernel/rte_ma1_cb.c          |  107 --
>  arch/v850/kernel/rte_ma1_cb.ld         |   57 -
>  arch/v850/kernel/rte_mb_a_pci.c        |  819 ------------------
>  arch/v850/kernel/rte_me2_cb.c          |  298 ------
>  arch/v850/kernel/rte_me2_cb.ld         |   30 
>  arch/v850/kernel/rte_nb85e_cb-multi.ld |   57 -
>  arch/v850/kernel/rte_nb85e_cb.c        |   81 -
>  arch/v850/kernel/rte_nb85e_cb.ld       |   22 
>  arch/v850/kernel/setup.c               |  330 -------
>  arch/v850/kernel/signal.c              |  523 -----------
>  arch/v850/kernel/sim.c                 |  172 ---
>  arch/v850/kernel/sim.ld                |   13 
>  arch/v850/kernel/sim85e2.c             |  195 ----
>  arch/v850/kernel/sim85e2.ld            |   36 
>  arch/v850/kernel/simcons.c             |  161 ---
>  arch/v850/kernel/syscalls.c            |  214 ----
>  arch/v850/kernel/teg.c                 |   62 -
>  arch/v850/kernel/time.c                |  106 --
>  arch/v850/kernel/v850_ksyms.c          |   51 -
>  arch/v850/kernel/v850e2_cache.c        |  127 --
>  arch/v850/kernel/v850e_cache.c         |  174 ---
>  arch/v850/kernel/v850e_intc.c          |  104 --
>  arch/v850/kernel/v850e_timer_d.c       |   54 -
>  arch/v850/kernel/v850e_utils.c         |   62 -
>  arch/v850/kernel/vmlinux.lds.S         |  306 ------
>  arch/v850/lib/Makefile                 |    6 
>  arch/v850/lib/ashldi3.c                |   62 -
>  arch/v850/lib/ashrdi3.c                |   63 -
>  arch/v850/lib/checksum.c               |  155 ---
>  arch/v850/lib/lshrdi3.c                |   62 -
>  arch/v850/lib/memcpy.c                 |   92 --
>  arch/v850/lib/memset.c                 |   68 -
>  arch/v850/lib/muldi3.c                 |   61 -
>  arch/v850/lib/negdi2.c                 |   25 
>  drivers/serial/Kconfig                 |   16 
>  drivers/serial/v850e_uart.c            |  548 ------------
>  drivers/watchdog/Kconfig               |    2 
>  drivers/watchdog/Makefile              |    2 
>  include/asm-v850/Kbuild                |    1 
>  include/asm-v850/a.out.h               |   21 
>  include/asm-v850/anna.h                |  137 ---
>  include/asm-v850/as85ep1.h             |  152 ---
>  include/asm-v850/asm.h                 |   32 
>  include/asm-v850/atomic.h              |  131 --
>  include/asm-v850/auxvec.h              |    4 
>  include/asm-v850/bitops.h              |  161 ---
>  include/asm-v850/bug.h                 |   25 
>  include/asm-v850/bugs.h                |   16 
>  include/asm-v850/byteorder.h           |   48 -
>  include/asm-v850/cache.h               |   26 
>  include/asm-v850/cacheflush.h          |   70 -
>  include/asm-v850/checksum.h            |  112 --
>  include/asm-v850/clinkage.h            |   26 
>  include/asm-v850/cputime.h             |    6 
>  include/asm-v850/current.h             |   47 -
>  include/asm-v850/delay.h               |   47 -
>  include/asm-v850/device.h              |    7 
>  include/asm-v850/div64.h               |    1 
>  include/asm-v850/dma-mapping.h         |   11 
>  include/asm-v850/dma.h                 |   18 
>  include/asm-v850/elf.h                 |   99 --
>  include/asm-v850/emergency-restart.h   |    6 
>  include/asm-v850/entry.h               |  113 --
>  include/asm-v850/errno.h               |    6 
>  include/asm-v850/fb.h                  |   12 
>  include/asm-v850/fcntl.h               |   11 
>  include/asm-v850/flat.h                |  133 --
>  include/asm-v850/fpga85e2c.h           |   82 -
>  include/asm-v850/futex.h               |    6 
>  include/asm-v850/gbus_int.h            |   97 --
>  include/asm-v850/hardirq.h             |   28 
>  include/asm-v850/highres_timer.h       |   44 
>  include/asm-v850/hw_irq.h              |    4 
>  include/asm-v850/io.h                  |  142 ---
>  include/asm-v850/ioctl.h               |    1 
>  include/asm-v850/ioctls.h              |   84 -
>  include/asm-v850/ipcbuf.h              |   29 
>  include/asm-v850/irq.h                 |   55 -
>  include/asm-v850/irq_regs.h            |    1 
>  include/asm-v850/kdebug.h              |    1 
>  include/asm-v850/kmap_types.h          |   19 
>  include/asm-v850/kvm.h                 |    6 
>  include/asm-v850/linkage.h             |    8 
>  include/asm-v850/local.h               |    6 
>  include/asm-v850/ma.h                  |  101 --
>  include/asm-v850/ma1.h                 |   50 -
>  include/asm-v850/machdep.h             |   60 -
>  include/asm-v850/macrology.h           |   17 
>  include/asm-v850/me2.h                 |  182 ----
>  include/asm-v850/mman.h                |   15 
>  include/asm-v850/mmu.h                 |   11 
>  include/asm-v850/mmu_context.h         |   13 
>  include/asm-v850/module.h              |   62 -
>  include/asm-v850/msgbuf.h              |   31 
>  include/asm-v850/mutex.h               |    9 
>  include/asm-v850/namei.h               |   17 
>  include/asm-v850/page.h                |  128 --
>  include/asm-v850/param.h               |   31 
>  include/asm-v850/pci.h                 |  119 --
>  include/asm-v850/percpu.h              |   14 
>  include/asm-v850/pgalloc.h             |   22 
>  include/asm-v850/pgtable.h             |   59 -
>  include/asm-v850/poll.h                |    9 
>  include/asm-v850/posix_types.h         |   72 -
>  include/asm-v850/processor.h           |  120 --
>  include/asm-v850/ptrace.h              |  121 --
>  include/asm-v850/resource.h            |    6 
>  include/asm-v850/rte_cb.h              |   78 -
>  include/asm-v850/rte_ma1_cb.h          |  128 --
>  include/asm-v850/rte_mb_a_pci.h        |   56 -
>  include/asm-v850/rte_me2_cb.h          |  202 ----
>  include/asm-v850/rte_nb85e_cb.h        |  111 --
>  include/asm-v850/scatterlist.h         |   31 
>  include/asm-v850/sections.h            |    6 
>  include/asm-v850/segment.h             |   36 
>  include/asm-v850/semaphore.h           |    1 
>  include/asm-v850/sembuf.h              |   25 
>  include/asm-v850/serial.h              |   56 -
>  include/asm-v850/setup.h               |    6 
>  include/asm-v850/shmbuf.h              |   42 
>  include/asm-v850/shmparam.h            |    6 
>  include/asm-v850/sigcontext.h          |   25 
>  include/asm-v850/siginfo.h             |    6 
>  include/asm-v850/signal.h              |  168 ---
>  include/asm-v850/sim.h                 |   47 -
>  include/asm-v850/sim85e2.h             |   69 -
>  include/asm-v850/sim85e2c.h            |   26 
>  include/asm-v850/sim85e2s.h            |   28 
>  include/asm-v850/simsyscall.h          |   99 --
>  include/asm-v850/socket.h              |   57 -
>  include/asm-v850/sockios.h             |   13 
>  include/asm-v850/stat.h                |   73 -
>  include/asm-v850/statfs.h              |    6 
>  include/asm-v850/string.h              |   25 
>  include/asm-v850/system.h              |  123 --
>  include/asm-v850/teg.h                 |  101 --
>  include/asm-v850/termbits.h            |  200 ----
>  include/asm-v850/termios.h             |   90 --
>  include/asm-v850/thread_info.h         |  129 --
>  include/asm-v850/timex.h               |   18 
>  include/asm-v850/tlb.h                 |   21 
>  include/asm-v850/tlbflush.h            |   64 -
>  include/asm-v850/topology.h            |    6 
>  include/asm-v850/types.h               |   66 -
>  include/asm-v850/uaccess.h             |  159 ---
>  include/asm-v850/ucontext.h            |   14 
>  include/asm-v850/unaligned.h           |  130 --
>  include/asm-v850/unistd.h              |  244 -----
>  include/asm-v850/user.h                |   52 -
>  include/asm-v850/v850e.h               |   21 
>  include/asm-v850/v850e2.h              |   69 -
>  include/asm-v850/v850e2_cache.h        |   75 -
>  include/asm-v850/v850e_cache.h         |   48 -
>  include/asm-v850/v850e_intc.h          |  133 --
>  include/asm-v850/v850e_timer_c.h       |   48 -
>  include/asm-v850/v850e_timer_d.h       |   62 -
>  include/asm-v850/v850e_uart.h          |   76 -
>  include/asm-v850/v850e_uarta.h         |  278 ------
>  include/asm-v850/v850e_uartb.h         |  262 -----
>  include/asm-v850/v850e_utils.h         |   35 
>  include/linux/audit.h                  |    1 
>  include/linux/module.h                 |    2 
>  include/linux/serial_core.h            |    3 
>  include/linux/syscalls.h               |    2 
>  scripts/genksyms/genksyms.c            |    3 
>  scripts/mod/file2alias.c               |    2 
>  scripts/mod/mk_elfconfig.c             |    2 
>  206 files changed, 5 insertions(+), 19134 deletions(-)
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
