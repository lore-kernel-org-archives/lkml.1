Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbXLTXLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbXLTXLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXLTXLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:11:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbXLTXLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:11:36 -0500
Date: Thu, 20 Dec 2007 15:11:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1
Message-Id: <20071220151103.a873e22d.akpm@linux-foundation.org>
In-Reply-To: <476A9E97.4040105@windriver.com>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<476A9E97.4040105@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 10:55:51 -0600
Jason Wessel <jason.wessel@windriver.com> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/
> >
> > - If something goes wrong with a PCI device's probing or initialisation, try
> >   reverting pci-disable-decoding-during-sizing-of-bars.patch.
> >
> > - git-sched was dropped due to breaking suspend-to-RAM.
> >
> > - git-block has been restored after having had a few problems
> >
> > - git-newsetup.patch was dropped due to conflicts with git-x86
> >
> > - git-perfmon.patch is still dropped for the same reason
> >
> > - git-kgdb.patch is still dropped for the same reason
> >
> >   
> Andrew,
> 
> I re-based the for_mm branch at:
> http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_mm
> against the git-x86/mm branch from the x86-git tree. If there are other
> patch trees I need to pull in and patch against to allow for kgdb to be
> included into -mm please let me know.

The x86 merge worked OK.


Here's what it looks like:

patching file Documentation/DocBook/Makefile
Hunk #1 FAILED at 11.
1 out of 1 hunk FAILED -- saving rejects to file Documentation/DocBook/Makefile.rej
patching file Documentation/DocBook/kgdb.tmpl
patching file Documentation/kernel-parameters.txt
Hunk #1 succeeded at 816 (offset 7 lines).
patching file MAINTAINERS
Hunk #1 succeeded at 2279 (offset 52 lines).
patching file Makefile
patching file arch/arm/kernel/Makefile
patching file arch/arm/kernel/kgdb-jmp.S
patching file arch/arm/kernel/kgdb.c
patching file arch/arm/kernel/setup.c
patching file arch/arm/kernel/traps.c
patching file arch/arm/mach-ixp2000/core.c
patching file arch/arm/mach-ixp2000/ixdp2x01.c
patching file arch/arm/mach-ixp4xx/coyote-setup.c
patching file arch/arm/mach-ixp4xx/ixdp425-setup.c
patching file arch/arm/mach-omap1/serial.c
patching file arch/arm/mach-omap2/serial.c
patching file arch/arm/mach-pnx4008/core.c
patching file arch/arm/mach-pxa/Makefile
Hunk #1 FAILED at 43.
1 out of 1 hunk FAILED -- saving rejects to file arch/arm/mach-pxa/Makefile.rej
patching file arch/arm/mach-pxa/kgdb-serial.c
patching file arch/arm/mach-versatile/core.c
patching file arch/arm/mm/extable.c
patching file arch/ia64/kernel/Makefile
patching file arch/ia64/kernel/kgdb-jmp.S
patching file arch/ia64/kernel/kgdb.c
patching file arch/ia64/kernel/smp.c
patching file arch/ia64/kernel/traps.c
Hunk #1 FAILED at 155.
1 out of 1 hunk FAILED -- saving rejects to file arch/ia64/kernel/traps.c.rej
patching file arch/ia64/mm/extable.c
patching file arch/ia64/mm/fault.c
patching file arch/mips/Kconfig
Hunk #2 succeeded at 323 (offset -6 lines).
Hunk #4 succeeded at 419 (offset -7 lines).
Hunk #5 succeeded at 531 (offset 21 lines).
Hunk #6 succeeded at 608 (offset -21 lines).
Hunk #7 succeeded at 670 (offset 21 lines).
Hunk #8 succeeded at 914 (offset -24 lines).
patching file arch/mips/Kconfig.debug
patching file arch/mips/au1000/common/Makefile
patching file arch/mips/au1000/common/dbg_io.c
patching file arch/mips/basler/excite/Makefile
patching file arch/mips/basler/excite/excite_dbg_io.c
patching file arch/mips/basler/excite/excite_irq.c
patching file arch/mips/basler/excite/excite_setup.c
patching file arch/mips/jmr3927/rbhma3100/Makefile
patching file arch/mips/jmr3927/rbhma3100/kgdb_io.c
patching file arch/mips/kernel/Makefile
patching file arch/mips/kernel/gdb-low.S
patching file arch/mips/kernel/gdb-stub.c
patching file arch/mips/kernel/irq.c
patching file arch/mips/kernel/kgdb-jmp.c
patching file arch/mips/kernel/kgdb-setjmp.S
patching file arch/mips/kernel/kgdb.c
patching file arch/mips/kernel/kgdb_handler.S
patching file arch/mips/kernel/traps.c
patching file arch/mips/mips-boards/atlas/Makefile
patching file arch/mips/mips-boards/atlas/atlas_gdb.c
patching file arch/mips/mips-boards/atlas/atlas_setup.c
patching file arch/mips/mips-boards/generic/Makefile
patching file arch/mips/mips-boards/generic/gdb_hook.c
patching file arch/mips/mips-boards/generic/init.c
patching file arch/mips/mips-boards/malta/malta_setup.c
patching file arch/mips/mm/extable.c
patching file arch/mips/pci/fixup-atlas.c
patching file arch/mips/philips/pnx8550/common/Makefile
patching file arch/mips/philips/pnx8550/common/gdb_hook.c
patching file arch/mips/philips/pnx8550/common/setup.c
patching file arch/mips/pmc-sierra/yosemite/Makefile
patching file arch/mips/pmc-sierra/yosemite/dbg_io.c
patching file arch/mips/pmc-sierra/yosemite/irq.c
patching file arch/mips/sgi-ip22/ip22-setup.c
patching file arch/mips/sgi-ip27/Makefile
patching file arch/mips/sgi-ip27/ip27-dbgio.c
patching file arch/mips/sibyte/bcm1480/irq.c
patching file arch/mips/sibyte/cfe/setup.c
Hunk #3 succeeded at 298 (offset -3 lines).
patching file arch/mips/sibyte/sb1250/irq.c
patching file arch/mips/sibyte/sb1250/kgdb_sibyte.c
patching file arch/mips/sibyte/swarm/Makefile
patching file arch/mips/sibyte/swarm/dbg_io.c
patching file arch/mips/tx4927/common/Makefile
Hunk #1 succeeded at 9 with fuzz 1.
patching file arch/mips/tx4927/common/tx4927_dbgio.c
patching file arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
Hunk #1 FAILED at 77.
Hunk #2 succeeded at 863 (offset -29 lines).
Hunk #4 succeeded at 891 (offset -29 lines).
1 out of 4 hunks FAILED -- saving rejects to file arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c.rej
patching file arch/mips/tx4938/common/Makefile
Hunk #1 FAILED at 7.
1 out of 1 hunk FAILED -- saving rejects to file arch/mips/tx4938/common/Makefile.rej
patching file arch/mips/tx4938/common/dbgio.c
patching file arch/mips/tx4938/toshiba_rbtx4938/setup.c
Hunk #1 FAILED at 31.
Hunk #2 succeeded at 871 (offset -2 lines).
1 out of 3 hunks FAILED -- saving rejects to file arch/mips/tx4938/toshiba_rbtx4938/setup.c.rej
patching file arch/powerpc/Kconfig.debug
patching file arch/powerpc/kernel/Makefile
patching file arch/powerpc/kernel/kgdb.c
patching file arch/powerpc/kernel/kgdb_setjmp32.S
patching file arch/powerpc/kernel/kgdb_setjmp64.S
patching file arch/powerpc/kernel/legacy_serial.c
patching file arch/powerpc/kernel/setup_32.c
patching file arch/powerpc/mm/fault.c
patching file arch/powerpc/platforms/powermac/setup.c
Hunk #1 succeeded at 97 (offset -1 lines).
patching file arch/powerpc/sysdev/mv64x60_dev.c
patching file arch/ppc/Kconfig.debug
patching file arch/ppc/kernel/Makefile
patching file arch/ppc/kernel/kgdb.c
patching file arch/ppc/kernel/kgdb_setjmp32.S
patching file arch/ppc/kernel/ppc-stub.c
patching file arch/ppc/kernel/setup.c
Hunk #1 succeeded at 46 (offset -1 lines).
patching file arch/ppc/mm/fault.c
patching file arch/ppc/platforms/4xx/bamboo.c
patching file arch/ppc/platforms/4xx/bubinga.c
patching file arch/ppc/platforms/4xx/ebony.c
patching file arch/ppc/platforms/4xx/luan.c
patching file arch/ppc/platforms/4xx/ocotea.c
patching file arch/ppc/platforms/4xx/taishan.c
patching file arch/ppc/platforms/4xx/xilinx_ml300.c
patching file arch/ppc/platforms/4xx/xilinx_ml403.c
patching file arch/ppc/platforms/4xx/yucca.c
patching file arch/ppc/platforms/83xx/mpc834x_sys.c
Hunk #3 succeeded at 316 (offset -20 lines).
patching file arch/ppc/platforms/85xx/mpc8540_ads.c
patching file arch/ppc/platforms/85xx/mpc8560_ads.c
patching file arch/ppc/platforms/85xx/mpc85xx_cds_common.c
patching file arch/ppc/platforms/85xx/sbc8560.c
patching file arch/ppc/platforms/85xx/tqm85xx.c
Hunk #4 succeeded at 379 (offset -21 lines).
patching file arch/ppc/platforms/chestnut.c
patching file arch/ppc/platforms/ev64260.c
patching file arch/ppc/platforms/hdpu.c
patching file arch/ppc/platforms/lopec.c
patching file arch/ppc/platforms/pplus.c
patching file arch/ppc/platforms/radstone_ppc7d.c
patching file arch/ppc/platforms/sandpoint.c
patching file arch/ppc/platforms/spruce.c
patching file arch/ppc/syslib/Makefile
patching file arch/ppc/syslib/gen550.h
patching file arch/ppc/syslib/gen550_kgdb.c
patching file arch/ppc/syslib/ibm44x_common.c
patching file arch/ppc/syslib/mv64x60.c
patching file arch/ppc/syslib/mv64x60_dbg.c
patching file arch/ppc/syslib/ppc4xx_setup.c
patching file arch/ppc/syslib/ppc83xx_setup.c
Hunk #2 succeeded at 43 with fuzz 1 (offset -1 lines).
Hunk #4 succeeded at 103 (offset -1 lines).
patching file arch/ppc/syslib/ppc85xx_setup.c
patching file arch/sh/Kconfig.debug
Hunk #1 FAILED at 94.
1 out of 1 hunk FAILED -- saving rejects to file arch/sh/Kconfig.debug.rej
patching file arch/sh/kernel/Makefile
Hunk #1 FAILED at 13.
1 out of 1 hunk FAILED -- saving rejects to file arch/sh/kernel/Makefile.rej
patching file arch/sh/kernel/kgdb-jmp.S
patching file arch/sh/kernel/kgdb.c
patching file arch/sh/kernel/kgdb_jmp.S
patching file arch/sh/kernel/kgdb_stub.c
can't find file to patch at input line 12787
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
|index a3a67d1..484bd0b 100644
|--- a/arch/sh/kernel/time.c
|+++ b/arch/sh/kernel/time.c
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
patching file arch/sh/kernel/traps.c
Hunk #1 FAILED at 25.
Hunk #2 FAILED at 85.
Hunk #3 FAILED at 697.
Hunk #4 FAILED at 770.
4 out of 4 hunks FAILED -- saving rejects to file arch/sh/kernel/traps.c.rej
can't find file to patch at input line 12860
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/arch/sh/mm/extable.c b/arch/sh/mm/extable.c
|index c1cf446..88e34ff 100644
|--- a/arch/sh/mm/extable.c
|+++ b/arch/sh/mm/extable.c
--------------------------
No file to patch.  Skipping patch.
2 out of 2 hunks ignored
can't find file to patch at input line 12885
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/arch/sh/mm/fault.c b/arch/sh/mm/fault.c
|index 60d74f7..7619c01 100644
|--- a/arch/sh/mm/fault.c
|+++ b/arch/sh/mm/fault.c
--------------------------
No file to patch.  Skipping patch.
4 out of 4 hunks ignored
patching file arch/x86/kernel/Makefile_32
Hunk #1 succeeded at 48 (offset 7 lines).
patching file arch/x86/kernel/Makefile_64
Hunk #1 succeeded at 43 (offset 7 lines).
patching file arch/x86/kernel/kgdb-jmp_32.S
patching file arch/x86/kernel/kgdb-jmp_64.S
patching file arch/x86/kernel/kgdb_32.c
patching file arch/x86/kernel/kgdb_64.c
patching file arch/x86/kernel/setup_32.c
patching file arch/x86/kernel/traps_32.c
Hunk #1 succeeded at 886 (offset 1 line).
Hunk #3 succeeded at 1128 (offset 1 line).
patching file arch/x86/kernel/traps_64.c
Hunk #1 succeeded at 549 (offset 1 line).
patching file arch/x86/mm/fault_32.c
patching file arch/x86/mm/fault_64.c
patching file drivers/char/keyboard.c
patching file drivers/net/Makefile
Hunk #1 succeeded at 244 (offset 3 lines).
patching file drivers/net/kgdboe.c
patching file drivers/serial/8250.c
patching file drivers/serial/8250_kgdb.c
patching file drivers/serial/Kconfig
patching file drivers/serial/Makefile
Hunk #2 succeeded at 53 (offset 1 line).
patching file drivers/serial/amba-pl011.c
patching file drivers/serial/cpm_uart/Makefile
patching file drivers/serial/cpm_uart/cpm_uart.h
patching file drivers/serial/cpm_uart/cpm_uart_core.c
patching file drivers/serial/cpm_uart/cpm_uart_cpm1.c
Hunk #1 succeeded at 60 (offset -4 lines).
Hunk #3 succeeded at 222 (offset -4 lines).
patching file drivers/serial/cpm_uart/cpm_uart_cpm2.c
Hunk #1 succeeded at 298 (offset -6 lines).
patching file drivers/serial/cpm_uart/cpm_uart_kgdb.c
patching file drivers/serial/mpsc_kgdb.c
patching file drivers/serial/pl011_kgdb.c
patching file drivers/serial/pxa.c
patching file drivers/serial/serial_core.c
Hunk #5 succeeded at 2179 (offset 1 line).
patching file drivers/serial/serial_txx9.c
patching file drivers/serial/serial_txx9_kgdb.c
patching file drivers/serial/sh-sci.c
patching file include/asm-arm/kgdb.h
patching file include/asm-generic/kgdb.h
patching file include/asm-ia64/kdebug.h
patching file include/asm-ia64/kgdb.h
patching file include/asm-mips/asmmacro-32.h
patching file include/asm-mips/asmmacro-64.h
patching file include/asm-mips/kdebug.h
patching file include/asm-mips/kgdb.h
patching file include/asm-mips/ptrace.h
patching file include/asm-powerpc/kgdb.h
patching file include/asm-ppc/kgdb.h
patching file include/asm-ppc/machdep.h
patching file include/asm-ppc/mv64x60.h
patching file include/asm-ppc/mv64x60_defs.h
patching file include/asm-sh/kgdb.h
patching file include/asm-x86/kdebug.h
patching file include/asm-x86/kgdb.h
patching file include/asm-x86/kgdb_32.h
patching file include/asm-x86/kgdb_64.h
patching file include/asm-x86/system.h
patching file include/linux/clocksource.h
patching file include/linux/kgdb.h
patching file include/linux/module.h
patching file include/linux/netpoll.h
patching file include/linux/serial_8250.h
patching file kernel/Makefile
patching file kernel/kgdb.c
patching file kernel/module.c
Hunk #1 succeeded at 64 (offset -2 lines).
Hunk #3 succeeded at 728 (offset -2 lines).
Hunk #5 succeeded at 1313 (offset -8 lines).
Hunk #7 succeeded at 2027 (offset -8 lines).
Hunk #8 FAILED at 2098.
Hunk #9 succeeded at 2185 (offset 3 lines).
1 out of 9 hunks FAILED -- saving rejects to file kernel/module.c.rej
patching file kernel/sched.c
Hunk #1 succeeded at 61 (offset 2 lines).
Hunk #2 succeeded at 6955 (offset 109 lines).
patching file kernel/softlockup.c
Hunk #1 succeeded at 15 (offset 1 line).
Hunk #3 succeeded at 109 (offset -3 lines).
patching file kernel/time/clocksource.c
patching file lib/Kconfig.debug
patching file lib/Kconfig.kgdb
patching file net/core/netpoll.c
Hunk #1 succeeded at 528 (offset -7 lines).
Failed to apply git-kgdb

Conflicts with the arm, ia64, mips, sh and driver trees (at least).  I
fixed most of them but gave up on sh, where there has been major code
motion.

> I would like to submit another review request for kgdb into the mainline
> as well as resolve the issues with the -mm tree + kgdb.

Please do - just email out the patches with carefully-chosen cc's.  It's
not a hugely productive time of year and responses may be spotty and slow
but you should just persist - send them every couple of weeks and let's
drive this nail home.

