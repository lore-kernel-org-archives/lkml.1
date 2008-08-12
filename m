Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYHLAGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYHLAGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYHLAGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:06:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYHLAGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:06:45 -0400
Date: Mon, 11 Aug 2008 17:05:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] h8300 move header files
Message-Id: <20080811170534.22f26b7e.akpm@linux-foundation.org>
In-Reply-To: <871w0wvgng.wl%ysato@users.sourceforge.jp>
References: <871w0wvgng.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 15:01:07 -0400
Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> git mv include/asm-h8300/* arch/h8300/include/asm
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
>  arch/h8300/include/asm/Kbuild              |    1 +
>  arch/h8300/include/asm/a.out.h             |   20 ++
>  arch/h8300/include/asm/atomic.h            |  144 +++++++++++
>  arch/h8300/include/asm/auxvec.h            |    4 +
>  arch/h8300/include/asm/bitops.h            |  212 ++++++++++++++++
>  arch/h8300/include/asm/bootinfo.h          |    2 +
>  arch/h8300/include/asm/bug.h               |    4 +
>  arch/h8300/include/asm/bugs.h              |   16 ++
>  arch/h8300/include/asm/byteorder.h         |   13 +
>  arch/h8300/include/asm/cache.h             |   12 +
>  arch/h8300/include/asm/cachectl.h          |   14 +
>  arch/h8300/include/asm/cacheflush.h        |   39 +++
>  arch/h8300/include/asm/checksum.h          |  102 ++++++++
>  arch/h8300/include/asm/cputime.h           |    6 +
>  arch/h8300/include/asm/current.h           |   25 ++
>  arch/h8300/include/asm/dbg.h               |    2 +
>  arch/h8300/include/asm/delay.h             |   38 +++
>  arch/h8300/include/asm/device.h            |    7 +
>  arch/h8300/include/asm/div64.h             |    1 +
>  arch/h8300/include/asm/dma.h               |   15 ++
>  arch/h8300/include/asm/elf.h               |  104 ++++++++
>  arch/h8300/include/asm/emergency-restart.h |    6 +
>  arch/h8300/include/asm/errno.h             |    6 +
>  arch/h8300/include/asm/fb.h                |   12 +
>  arch/h8300/include/asm/fcntl.h             |   11 +
>  arch/h8300/include/asm/flat.h              |   27 ++
>  arch/h8300/include/asm/fpu.h               |    1 +
>  arch/h8300/include/asm/futex.h             |    6 +
>  arch/h8300/include/asm/gpio.h              |   52 ++++
>  arch/h8300/include/asm/hardirq.h           |   28 +++
>  arch/h8300/include/asm/hw_irq.h            |    1 +
>  arch/h8300/include/asm/io.h                |  324 +++++++++++++++++++++++++
>  arch/h8300/include/asm/ioctl.h             |    1 +
>  arch/h8300/include/asm/ioctls.h            |   85 +++++++
>  arch/h8300/include/asm/ipcbuf.h            |   29 +++
>  arch/h8300/include/asm/irq.h               |   49 ++++
>  arch/h8300/include/asm/irq_regs.h          |    1 +
>  arch/h8300/include/asm/kdebug.h            |    1 +
>  arch/h8300/include/asm/kmap_types.h        |   21 ++
>  arch/h8300/include/asm/linkage.h           |    8 +
>  arch/h8300/include/asm/local.h             |    6 +
>  arch/h8300/include/asm/mc146818rtc.h       |    9 +
>  arch/h8300/include/asm/md.h                |   13 +
>  arch/h8300/include/asm/mman.h              |   17 ++
>  arch/h8300/include/asm/mmu.h               |   11 +
>  arch/h8300/include/asm/mmu_context.h       |   32 +++
>  arch/h8300/include/asm/module.h            |   13 +
>  arch/h8300/include/asm/msgbuf.h            |   31 +++
>  arch/h8300/include/asm/mutex.h             |    9 +
>  arch/h8300/include/asm/page.h              |   78 ++++++
>  arch/h8300/include/asm/page_offset.h       |    3 +
>  arch/h8300/include/asm/param.h             |   20 ++
>  arch/h8300/include/asm/pci.h               |   25 ++
>  arch/h8300/include/asm/percpu.h            |    6 +
>  arch/h8300/include/asm/pgalloc.h           |    8 +
>  arch/h8300/include/asm/pgtable.h           |   73 ++++++
>  arch/h8300/include/asm/poll.h              |   11 +
>  arch/h8300/include/asm/posix_types.h       |   60 +++++
>  arch/h8300/include/asm/processor.h         |  140 +++++++++++
>  arch/h8300/include/asm/ptrace.h            |   64 +++++
>  arch/h8300/include/asm/regs267x.h          |  336 +++++++++++++++++++++++++
>  arch/h8300/include/asm/regs306x.h          |  212 ++++++++++++++++
>  arch/h8300/include/asm/resource.h          |    6 +
>  arch/h8300/include/asm/scatterlist.h       |   18 ++
>  arch/h8300/include/asm/sections.h          |    6 +
>  arch/h8300/include/asm/segment.h           |   49 ++++
>  arch/h8300/include/asm/sembuf.h            |   25 ++
>  arch/h8300/include/asm/setup.h             |    6 +
>  arch/h8300/include/asm/sh_bios.h           |   29 +++
>  arch/h8300/include/asm/shm.h               |   31 +++
>  arch/h8300/include/asm/shmbuf.h            |   42 ++++
>  arch/h8300/include/asm/shmparam.h          |    6 +
>  arch/h8300/include/asm/sigcontext.h        |   18 ++
>  arch/h8300/include/asm/siginfo.h           |    6 +
>  arch/h8300/include/asm/signal.h            |  161 ++++++++++++
>  arch/h8300/include/asm/smp.h               |    1 +
>  arch/h8300/include/asm/socket.h            |   57 +++++
>  arch/h8300/include/asm/sockios.h           |   13 +
>  arch/h8300/include/asm/spinlock.h          |    6 +
>  arch/h8300/include/asm/stat.h              |   78 ++++++
>  arch/h8300/include/asm/statfs.h            |    6 +
>  arch/h8300/include/asm/string.h            |   44 ++++
>  arch/h8300/include/asm/system.h            |  158 ++++++++++++
>  arch/h8300/include/asm/target_time.h       |    4 +
>  arch/h8300/include/asm/termbits.h          |  200 +++++++++++++++
>  arch/h8300/include/asm/termios.h           |   92 +++++++
>  arch/h8300/include/asm/thread_info.h       |  104 ++++++++
>  arch/h8300/include/asm/timex.h             |   19 ++
>  arch/h8300/include/asm/tlb.h               |   23 ++
>  arch/h8300/include/asm/tlbflush.h          |   55 +++++
>  arch/h8300/include/asm/topology.h          |    6 +
>  arch/h8300/include/asm/traps.h             |   37 +++
>  arch/h8300/include/asm/types.h             |   33 +++
>  arch/h8300/include/asm/uaccess.h           |  162 ++++++++++++
>  arch/h8300/include/asm/ucontext.h          |   12 +
>  arch/h8300/include/asm/unaligned.h         |   11 +
>  arch/h8300/include/asm/unistd.h            |  364 ++++++++++++++++++++++++++++
>  arch/h8300/include/asm/user.h              |   75 ++++++
>  arch/h8300/include/asm/virtconvert.h       |   20 ++
>  include/asm-h8300/Kbuild                   |    1 -
>  include/asm-h8300/a.out.h                  |   20 --
>  include/asm-h8300/atomic.h                 |  144 -----------
>  include/asm-h8300/auxvec.h                 |    4 -
>  include/asm-h8300/bitops.h                 |  212 ----------------
>  include/asm-h8300/bootinfo.h               |    2 -
>  include/asm-h8300/bug.h                    |    4 -
>  include/asm-h8300/bugs.h                   |   16 --
>  include/asm-h8300/byteorder.h              |   13 -
>  include/asm-h8300/cache.h                  |   12 -
>  include/asm-h8300/cachectl.h               |   14 -
>  include/asm-h8300/cacheflush.h             |   39 ---
>  include/asm-h8300/checksum.h               |  102 --------
>  include/asm-h8300/cputime.h                |    6 -
>  include/asm-h8300/current.h                |   25 --
>  include/asm-h8300/dbg.h                    |    2 -
>  include/asm-h8300/delay.h                  |   38 ---
>  include/asm-h8300/device.h                 |    7 -
>  include/asm-h8300/div64.h                  |    1 -
>  include/asm-h8300/dma.h                    |   15 --
>  include/asm-h8300/elf.h                    |  104 --------
>  include/asm-h8300/emergency-restart.h      |    6 -
>  include/asm-h8300/errno.h                  |    6 -
>  include/asm-h8300/fb.h                     |   12 -
>  include/asm-h8300/fcntl.h                  |   11 -
>  include/asm-h8300/flat.h                   |   27 --
>  include/asm-h8300/fpu.h                    |    1 -
>  include/asm-h8300/futex.h                  |    6 -
>  include/asm-h8300/gpio.h                   |   52 ----
>  include/asm-h8300/hardirq.h                |   28 ---
>  include/asm-h8300/hw_irq.h                 |    1 -
>  include/asm-h8300/io.h                     |  324 -------------------------
>  include/asm-h8300/ioctl.h                  |    1 -
>  include/asm-h8300/ioctls.h                 |   85 -------
>  include/asm-h8300/ipcbuf.h                 |   29 ---
>  include/asm-h8300/irq.h                    |   49 ----
>  include/asm-h8300/irq_regs.h               |    1 -
>  include/asm-h8300/kdebug.h                 |    1 -
>  include/asm-h8300/kmap_types.h             |   21 --
>  include/asm-h8300/linkage.h                |    8 -
>  include/asm-h8300/local.h                  |    6 -
>  include/asm-h8300/mc146818rtc.h            |    9 -
>  include/asm-h8300/md.h                     |   13 -
>  include/asm-h8300/mman.h                   |   17 --
>  include/asm-h8300/mmu.h                    |   11 -
>  include/asm-h8300/mmu_context.h            |   32 ---
>  include/asm-h8300/module.h                 |   13 -
>  include/asm-h8300/msgbuf.h                 |   31 ---
>  include/asm-h8300/mutex.h                  |    9 -
>  include/asm-h8300/page.h                   |   78 ------
>  include/asm-h8300/page_offset.h            |    3 -
>  include/asm-h8300/param.h                  |   20 --
>  include/asm-h8300/pci.h                    |   25 --
>  include/asm-h8300/percpu.h                 |    6 -
>  include/asm-h8300/pgalloc.h                |    8 -
>  include/asm-h8300/pgtable.h                |   73 ------
>  include/asm-h8300/poll.h                   |   11 -
>  include/asm-h8300/posix_types.h            |   60 -----
>  include/asm-h8300/processor.h              |  140 -----------
>  include/asm-h8300/ptrace.h                 |   64 -----
>  include/asm-h8300/regs267x.h               |  336 -------------------------
>  include/asm-h8300/regs306x.h               |  212 ----------------
>  include/asm-h8300/resource.h               |    6 -
>  include/asm-h8300/scatterlist.h            |   18 --
>  include/asm-h8300/sections.h               |    6 -
>  include/asm-h8300/segment.h                |   49 ----
>  include/asm-h8300/sembuf.h                 |   25 --
>  include/asm-h8300/setup.h                  |    6 -
>  include/asm-h8300/sh_bios.h                |   29 ---
>  include/asm-h8300/shm.h                    |   31 ---
>  include/asm-h8300/shmbuf.h                 |   42 ----
>  include/asm-h8300/shmparam.h               |    6 -
>  include/asm-h8300/sigcontext.h             |   18 --
>  include/asm-h8300/siginfo.h                |    6 -
>  include/asm-h8300/signal.h                 |  161 ------------
>  include/asm-h8300/smp.h                    |    1 -
>  include/asm-h8300/socket.h                 |   57 -----
>  include/asm-h8300/sockios.h                |   13 -
>  include/asm-h8300/spinlock.h               |    6 -
>  include/asm-h8300/stat.h                   |   78 ------
>  include/asm-h8300/statfs.h                 |    6 -
>  include/asm-h8300/string.h                 |   44 ----
>  include/asm-h8300/system.h                 |  158 ------------
>  include/asm-h8300/target_time.h            |    4 -
>  include/asm-h8300/termbits.h               |  200 ---------------
>  include/asm-h8300/termios.h                |   92 -------
>  include/asm-h8300/thread_info.h            |  104 --------
>  include/asm-h8300/timex.h                  |   19 --
>  include/asm-h8300/tlb.h                    |   23 --
>  include/asm-h8300/tlbflush.h               |   55 -----
>  include/asm-h8300/topology.h               |    6 -
>  include/asm-h8300/traps.h                  |   37 ---
>  include/asm-h8300/types.h                  |   33 ---
>  include/asm-h8300/uaccess.h                |  162 ------------
>  include/asm-h8300/ucontext.h               |   12 -
>  include/asm-h8300/unaligned.h              |   11 -
>  include/asm-h8300/unistd.h                 |  364 ----------------------------
>  include/asm-h8300/user.h                   |   75 ------
>  include/asm-h8300/virtconvert.h            |   20 --

This patch will cause me some pain, because people will occasionally
change those headers and the plain-old-patch will break.

Some better options are

a) merge it into Sam's git tree, then he merges it into 2.6.28-rc1

b) you resend the pull request into Linus during the 2.6.28-rc1 merge window

c) merge it into mainline immediately

Sam, any suggestions here?
