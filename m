Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbYETXEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbYETXEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYETXE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:04:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41604
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYETXEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:04:25 -0400
Date: Tue, 20 May 2008 16:04:20 -0700 (PDT)
Message-Id: <20080520.160420.193705980.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two things going on here:

1) Add a "sysrq y" global register dumping facility that
   works even when CPUs are stuck with interrupts disabled.
   I've used this often enough myself, and given it to
   users to debug problems, that it deserves to be upstream.

2) Patches from Adrian Bunk to delete all the old CVS Id
   tags, I've been doing them gradually when touching specific
   files, but it's just as good to kill them all if he's done
   the work already.

Please pull, thanks a lot!

The following changes since commit 8033c6e9736c29cce5f0d0abbca9a44dffb20c39:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../drzeus/mmc

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Adrian Bunk (2):
      sparc64: remove CVS keywords
      sparc: remove CVS keywords

David S. Miller (1):
      sparc64: Add global register dumping facility.

 arch/sparc/Kconfig                   |    1 -
 arch/sparc/boot/Makefile             |    1 -
 arch/sparc/boot/btfixupprep.c        |    2 +-
 arch/sparc/boot/piggyback.c          |    2 +-
 arch/sparc/kernel/ebus.c             |    2 +-
 arch/sparc/kernel/etrap.S            |    2 +-
 arch/sparc/kernel/head.S             |    2 +-
 arch/sparc/kernel/idprom.c           |    2 +-
 arch/sparc/kernel/ioport.c           |    2 +-
 arch/sparc/kernel/irq.c              |    2 +-
 arch/sparc/kernel/muldiv.c           |    2 +-
 arch/sparc/kernel/rtrap.S            |    2 +-
 arch/sparc/kernel/setup.c            |    2 +-
 arch/sparc/kernel/sparc_ksyms.c      |    2 +-
 arch/sparc/kernel/sun4d_irq.c        |    2 +-
 arch/sparc/kernel/trampoline.S       |    2 +-
 arch/sparc/kernel/traps.c            |    2 +-
 arch/sparc/kernel/unaligned.c        |    2 +-
 arch/sparc/kernel/wof.S              |    2 +-
 arch/sparc/kernel/wuf.S              |    2 +-
 arch/sparc/lib/Makefile              |    1 -
 arch/sparc/lib/ashldi3.S             |    2 +-
 arch/sparc/lib/ashrdi3.S             |    2 +-
 arch/sparc/lib/blockops.S            |    2 +-
 arch/sparc/lib/locks.S               |    2 +-
 arch/sparc/lib/lshrdi3.S             |    1 -
 arch/sparc/lib/memscan.S             |    2 +-
 arch/sparc/lib/mul.S                 |    2 +-
 arch/sparc/lib/rem.S                 |    2 +-
 arch/sparc/lib/rwsem.S               |    2 +-
 arch/sparc/lib/sdiv.S                |    2 +-
 arch/sparc/lib/strncmp.S             |    2 +-
 arch/sparc/lib/udiv.S                |    2 +-
 arch/sparc/lib/umul.S                |    2 +-
 arch/sparc/lib/urem.S                |    2 +-
 arch/sparc/math-emu/ashldi3.S        |    2 +-
 arch/sparc/mm/Makefile               |    1 -
 arch/sparc/mm/fault.c                |    2 +-
 arch/sparc/mm/generic.c              |    2 +-
 arch/sparc/mm/hypersparc.S           |    2 +-
 arch/sparc/mm/init.c                 |    2 +-
 arch/sparc/mm/io-unit.c              |    2 +-
 arch/sparc/mm/loadmmu.c              |    2 +-
 arch/sparc/mm/nosrmmu.c              |    2 +-
 arch/sparc/mm/nosun4c.c              |    2 +-
 arch/sparc/mm/swift.S                |    2 +-
 arch/sparc/mm/tsunami.S              |    2 +-
 arch/sparc/mm/viking.S               |    2 +-
 arch/sparc/prom/Makefile             |    1 -
 arch/sparc/prom/bootstr.c            |    2 +-
 arch/sparc/prom/console.c            |    2 +-
 arch/sparc/prom/devmap.c             |    2 +-
 arch/sparc/prom/devops.c             |    2 +-
 arch/sparc/prom/init.c               |    2 +-
 arch/sparc/prom/misc.c               |    2 +-
 arch/sparc/prom/mp.c                 |    2 +-
 arch/sparc/prom/palloc.c             |    2 +-
 arch/sparc/prom/ranges.c             |    2 +-
 arch/sparc/prom/segment.c            |    2 +-
 arch/sparc/prom/tree.c               |    2 +-
 arch/sparc64/Makefile                |    1 -
 arch/sparc64/boot/Makefile           |    1 -
 arch/sparc64/boot/piggyback.c        |    2 +-
 arch/sparc64/kernel/dtlb_prot.S      |    2 +-
 arch/sparc64/kernel/ebus.c           |    2 +-
 arch/sparc64/kernel/etrap.S          |    2 +-
 arch/sparc64/kernel/idprom.c         |    2 +-
 arch/sparc64/kernel/process.c        |  117 +++++++++++++++++++++++++++++++++-
 arch/sparc64/kernel/rtrap.S          |    2 +-
 arch/sparc64/kernel/sbus.c           |    2 +-
 arch/sparc64/kernel/setup.c          |    2 +-
 arch/sparc64/kernel/signal.c         |    2 +-
 arch/sparc64/kernel/smp.c            |   10 +++
 arch/sparc64/kernel/starfire.c       |    2 +-
 arch/sparc64/kernel/sys32.S          |    2 +-
 arch/sparc64/kernel/trampoline.S     |    2 +-
 arch/sparc64/kernel/unaligned.c      |    2 +-
 arch/sparc64/lib/PeeCeeI.c           |    2 +-
 arch/sparc64/lib/VISsave.S           |    2 +-
 arch/sparc64/lib/memcmp.S            |    2 +-
 arch/sparc64/lib/memscan.S           |    2 +-
 arch/sparc64/lib/strncmp.S           |    2 +-
 arch/sparc64/lib/strncpy_from_user.S |    2 +-
 arch/sparc64/math-emu/math.c         |    2 +-
 arch/sparc64/math-emu/sfp-util.h     |    2 +-
 arch/sparc64/mm/Makefile             |    1 -
 arch/sparc64/mm/fault.c              |    2 +-
 arch/sparc64/mm/generic.c            |    2 +-
 arch/sparc64/mm/init.c               |    2 +-
 arch/sparc64/mm/ultra.S              |   31 ++++++++-
 arch/sparc64/prom/Makefile           |    1 -
 arch/sparc64/prom/bootstr.c          |    2 +-
 arch/sparc64/prom/devops.c           |    2 +-
 arch/sparc64/prom/init.c             |    2 +-
 arch/sparc64/prom/misc.c             |    2 +-
 arch/sparc64/prom/p1275.c            |    2 +-
 arch/sparc64/prom/tree.c             |    2 +-
 drivers/char/sysrq.c                 |    1 +
 include/asm-sparc/asi.h              |    1 -
 include/asm-sparc/auxio.h            |    2 +-
 include/asm-sparc/bitops.h           |    2 +-
 include/asm-sparc/btfixup.h          |    2 +-
 include/asm-sparc/checksum.h         |    1 -
 include/asm-sparc/clock.h            |    2 +-
 include/asm-sparc/contregs.h         |    1 -
 include/asm-sparc/cypress.h          |    2 +-
 include/asm-sparc/delay.h            |    2 +-
 include/asm-sparc/ebus.h             |    2 +-
 include/asm-sparc/ecc.h              |    2 +-
 include/asm-sparc/eeprom.h           |    2 +-
 include/asm-sparc/elf.h              |    1 -
 include/asm-sparc/fcntl.h            |    1 -
 include/asm-sparc/head.h             |    1 -
 include/asm-sparc/idprom.h           |    2 +-
 include/asm-sparc/io.h               |    3 -
 include/asm-sparc/ioctl.h            |    1 -
 include/asm-sparc/kdebug.h           |    2 +-
 include/asm-sparc/machines.h         |    2 +-
 include/asm-sparc/mbus.h             |    2 +-
 include/asm-sparc/memreg.h           |    1 -
 include/asm-sparc/mman.h             |    1 -
 include/asm-sparc/mostek.h           |    2 +-
 include/asm-sparc/mpmbox.h           |    2 +-
 include/asm-sparc/msi.h              |    2 +-
 include/asm-sparc/mxcc.h             |    2 +-
 include/asm-sparc/namei.h            |    2 +-
 include/asm-sparc/obio.h             |    2 +-
 include/asm-sparc/openprom.h         |    1 -
 include/asm-sparc/oplib.h            |    2 +-
 include/asm-sparc/page.h             |    2 +-
 include/asm-sparc/param.h            |    1 -
 include/asm-sparc/pbm.h              |    2 +-
 include/asm-sparc/pcic.h             |    2 +-
 include/asm-sparc/pgalloc.h          |    1 -
 include/asm-sparc/pgtable.h          |    1 -
 include/asm-sparc/pgtsrmmu.h         |    2 +-
 include/asm-sparc/pgtsun4.h          |    2 +-
 include/asm-sparc/pgtsun4c.h         |    2 +-
 include/asm-sparc/psr.h              |    2 +-
 include/asm-sparc/ptrace.h           |    1 -
 include/asm-sparc/resource.h         |    2 +-
 include/asm-sparc/ross.h             |    2 +-
 include/asm-sparc/rtc.h              |    3 +-
 include/asm-sparc/sbi.h              |    2 +-
 include/asm-sparc/sbus.h             |    2 +-
 include/asm-sparc/scatterlist.h      |    1 -
 include/asm-sparc/shmparam.h         |    1 -
 include/asm-sparc/sigcontext.h       |    1 -
 include/asm-sparc/siginfo.h          |    4 -
 include/asm-sparc/signal.h           |    1 -
 include/asm-sparc/smpprim.h          |    2 +-
 include/asm-sparc/socket.h           |    1 -
 include/asm-sparc/stat.h             |    1 -
 include/asm-sparc/statfs.h           |    1 -
 include/asm-sparc/string.h           |    2 +-
 include/asm-sparc/sun4paddr.h        |    2 +-
 include/asm-sparc/sunbpp.h           |    2 +-
 include/asm-sparc/sysen.h            |    2 +-
 include/asm-sparc/termios.h          |    1 -
 include/asm-sparc/timer.h            |    2 +-
 include/asm-sparc/traps.h            |    2 +-
 include/asm-sparc/tsunami.h          |    2 +-
 include/asm-sparc/turbosparc.h       |    2 +-
 include/asm-sparc/types.h            |    1 -
 include/asm-sparc/uaccess.h          |    2 +-
 include/asm-sparc/vac-ops.h          |    1 -
 include/asm-sparc/vaddrs.h           |    1 -
 include/asm-sparc/viking.h           |    2 +-
 include/asm-sparc/winmacro.h         |    2 +-
 include/asm-sparc64/apb.h            |    2 +-
 include/asm-sparc64/asi.h            |    1 -
 include/asm-sparc64/auxio.h          |    2 +-
 include/asm-sparc64/bbc.h            |    2 +-
 include/asm-sparc64/bitops.h         |    2 +-
 include/asm-sparc64/chafsr.h         |    1 -
 include/asm-sparc64/checksum.h       |    1 -
 include/asm-sparc64/chmctrl.h        |    1 -
 include/asm-sparc64/dcr.h            |    1 -
 include/asm-sparc64/display7seg.h    |    2 +-
 include/asm-sparc64/dma.h            |    2 +-
 include/asm-sparc64/ebus.h           |    2 +-
 include/asm-sparc64/elf.h            |    1 -
 include/asm-sparc64/envctrl.h        |    2 +-
 include/asm-sparc64/estate.h         |    1 -
 include/asm-sparc64/fcntl.h          |    1 -
 include/asm-sparc64/fhc.h            |    2 +-
 include/asm-sparc64/head.h           |    1 -
 include/asm-sparc64/ide.h            |    2 +-
 include/asm-sparc64/idprom.h         |    2 +-
 include/asm-sparc64/ioctl.h          |    1 -
 include/asm-sparc64/ioctls.h         |    1 -
 include/asm-sparc64/lsu.h            |    1 -
 include/asm-sparc64/mman.h           |    1 -
 include/asm-sparc64/mmu_context.h    |    1 -
 include/asm-sparc64/namei.h          |    2 +-
 include/asm-sparc64/openprom.h       |    1 -
 include/asm-sparc64/page.h           |    2 -
 include/asm-sparc64/pgalloc.h        |    1 -
 include/asm-sparc64/pgtable.h        |    2 +-
 include/asm-sparc64/pil.h            |    1 -
 include/asm-sparc64/processor.h      |    2 +-
 include/asm-sparc64/psrcompat.h      |    1 -
 include/asm-sparc64/pstate.h         |    1 -
 include/asm-sparc64/ptrace.h         |   21 ++++++
 include/asm-sparc64/reg.h            |    2 +-
 include/asm-sparc64/resource.h       |    2 +-
 include/asm-sparc64/rtc.h            |    3 +-
 include/asm-sparc64/rwsem.h          |    2 +-
 include/asm-sparc64/scatterlist.h    |    1 -
 include/asm-sparc64/shmparam.h       |    1 -
 include/asm-sparc64/sigcontext.h     |    1 -
 include/asm-sparc64/signal.h         |    1 -
 include/asm-sparc64/smp.h            |    5 +-
 include/asm-sparc64/socket.h         |    1 -
 include/asm-sparc64/starfire.h       |    2 +-
 include/asm-sparc64/stat.h           |    1 -
 include/asm-sparc64/statfs.h         |    1 -
 include/asm-sparc64/string.h         |    2 +-
 include/asm-sparc64/sunbpp.h         |    2 +-
 include/asm-sparc64/termios.h        |    1 -
 include/asm-sparc64/ttable.h         |    1 -
 include/asm-sparc64/types.h          |    1 -
 include/asm-sparc64/uaccess.h        |    1 -
 include/asm-sparc64/uctx.h           |    2 +-
 include/asm-sparc64/utrap.h          |    2 +-
 include/asm-sparc64/watchdog.h       |    2 +-
 226 files changed, 333 insertions(+), 232 deletions(-)
