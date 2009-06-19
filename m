Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbZFSDr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbZFSDr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZFSDrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:47:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46394 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZFSDrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:47:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git
Date: Thu, 18 Jun 2009 23:47:37 -0400
Message-Id: <1245383257-23882-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0732f87761dbe417cb6e084b712d07e879e876ef:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Mike Frysinger (14):
      Blackfin: use common test_bit() rather than __test_bit()
      Blackfin: pull in asm/io.h in ksyms for prototypes
      Blackfin: only build irqpanic.c when needed
      Blackfin: convert asm/ioctls.h to asm-generic/ioctls.h
      Blackfin: convert shm/sysv/ipc to asm-generic
      Blackfin: convert user/elf to asm-generic
      Blackfin: convert socket/poll to asm-generic
      Blackfin: convert simple headers to asm-generic
      Blackfin: convert termios to asm-generic
      Blackfin: convert locking primitives to asm-generic
      Blackfin: convert signal/mmap to asm-generic
      Blackfin: convert irq/process to asm-generic
      Blackfin: convert types to asm-generic
      Blackfin: convert page/tlb to asm-generic

 arch/blackfin/include/asm/atomic.h            |  109 +-------------
 arch/blackfin/include/asm/auxvec.h            |    5 +-
 arch/blackfin/include/asm/bitops.h            |  198 +-----------------------
 arch/blackfin/include/asm/bugs.h              |   17 +--
 arch/blackfin/include/asm/cputime.h           |    5 -
 arch/blackfin/include/asm/current.h           |   24 +---
 arch/blackfin/include/asm/device.h            |    6 -
 arch/blackfin/include/asm/elf.h               |    2 +-
 arch/blackfin/include/asm/emergency-restart.h |    5 -
 arch/blackfin/include/asm/errno.h             |    7 +-
 arch/blackfin/include/asm/fb.h                |   13 +--
 arch/blackfin/include/asm/futex.h             |    5 -
 arch/blackfin/include/asm/hardirq.h           |   42 +-----
 arch/blackfin/include/asm/hw_irq.h            |    7 +-
 arch/blackfin/include/asm/io.h                |    1 -
 arch/blackfin/include/asm/ioctls.h            |   84 +----------
 arch/blackfin/include/asm/ipcbuf.h            |   31 +----
 arch/blackfin/include/asm/irq.h               |    5 +-
 arch/blackfin/include/asm/kmap_types.h        |    5 -
 arch/blackfin/include/asm/local.h             |    5 -
 arch/blackfin/include/asm/mman.h              |   44 +------
 arch/blackfin/include/asm/msgbuf.h            |   32 +----
 arch/blackfin/include/asm/mutex.h             |    2 +-
 arch/blackfin/include/asm/page.h              |   85 +----------
 arch/blackfin/include/asm/param.h             |   23 +---
 arch/blackfin/include/asm/percpu.h            |    5 -
 arch/blackfin/include/asm/pgalloc.h           |    9 +-
 arch/blackfin/include/asm/poll.h              |   21 +---
 arch/blackfin/include/asm/posix_types.h       |   56 ++------
 arch/blackfin/include/asm/processor.h         |   35 +----
 arch/blackfin/include/asm/resource.h          |    5 -
 arch/blackfin/include/asm/sembuf.h            |   26 +---
 arch/blackfin/include/asm/serial.h            |    6 +-
 arch/blackfin/include/asm/setup.h             |   18 +--
 arch/blackfin/include/asm/shmbuf.h            |   43 +-----
 arch/blackfin/include/asm/shmparam.h          |    7 +-
 arch/blackfin/include/asm/signal.h            |  159 +-------------------
 arch/blackfin/include/asm/socket.h            |   60 +--------
 arch/blackfin/include/asm/sockios.h           |   14 +--
 arch/blackfin/include/asm/spinlock.h          |    6 +
 arch/blackfin/include/asm/statfs.h            |    5 -
 arch/blackfin/include/asm/swab.h              |    6 +-
 arch/blackfin/include/asm/termbits.h          |  199 +------------------------
 arch/blackfin/include/asm/termios.h           |   95 +------------
 arch/blackfin/include/asm/tlbflush.h          |   57 +-------
 arch/blackfin/include/asm/topology.h          |    5 -
 arch/blackfin/include/asm/types.h             |   37 +-----
 arch/blackfin/include/asm/ucontext.h          |   18 +--
 arch/blackfin/include/asm/unaligned.h         |   12 +--
 arch/blackfin/include/asm/user.h              |   90 +-----------
 arch/blackfin/kernel/bfin_ksyms.c             |    1 +
 arch/blackfin/kernel/process.c                |   23 +++
 arch/blackfin/mach-common/Makefile            |    3 +-
 arch/blackfin/mach-common/ints-priority.c     |    4 +-
 arch/blackfin/mach-common/irqpanic.c          |   11 +-
 55 files changed, 108 insertions(+), 1690 deletions(-)
