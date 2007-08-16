Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbXHPFoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbXHPFoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbXHPFoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:44:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:36509 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbXHPFoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:44:02 -0400
Date: Thu, 16 Aug 2007 05:43:57 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Linux 2.6.20.16
Message-ID: <20070816054357.GA22242@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.6.20.16. This version catches up with 2.6.21.7.
I hope to issue newer releases soon with next batches of pending patches.

I'll also be replying to this message with a copy of the patch between
2.6.20.15 and 2.6.20.16.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.16.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.16

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git

Willy

-------

 Makefile                                      |    2 
 arch/i386/kernel/entry.S                      |    8 -
 arch/i386/oprofile/nmi_int.c                  |    9 +
 arch/powerpc/kernel/signal_64.c               |   10 -
 arch/x86_64/mm/init.c                         |    8 +
 drivers/char/cyclades.c                       |    1 
 drivers/md/bitmap.c                           |   17 +-
 drivers/md/dm-crypt.c                         |   50 ++----
 drivers/md/raid0.c                            |    3 
 drivers/md/raid1.c                            |   21 +-
 drivers/md/raid10.c                           |    6 
 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 
 drivers/net/e1000/e1000_main.c                |   11 -
 drivers/net/sky2.c                            |    9 +
 drivers/serial/mpsc.c                         |    3 
 include/linux/bootmem.h                       |    1 
 include/linux/pci_ids.h                       |    4 
 include/linux/raid/bitmap.h                   |    1 
 include/linux/sched.h                         |    1 
 include/linux/workqueue.h                     |    2 
 kernel/auditfilter.c                          |    2 
 kernel/exit.c                                 |   22 ++
 kernel/futex.c                                |  205 ++++++++++++++++----------
 kernel/rtmutex.c                              |   24 ++-
 kernel/sched.c                                |   22 +-
 mm/rmap.c                                     |   24 ---
 mm/sparse.c                                   |   11 +
 27 files changed, 307 insertions(+), 172 deletions(-)

Summary of changes from 2.6.20.15 to 2.6.20.16
============================================

Alexey Kuznetsov (1):
      pi-futex: Fix exit races and locking problems

Andi Kleen (1):
      i386: Fix K8/core2 oprofile on multiple CPUs

Auke Kok (1):
      e1000: disable polling before registering netdevice

Bob Picco (1):
      sparsemem: fix oops in x86_64 show_mem

Christoph Lameter (1):
      sched: fix next_interval determination in idle_balance()

Hugh Dickins (1):
      mm: kill validate_anon_vma to avoid mapcount BUG

Jason Gaston (1):
      pci_ids: update patch for Intel ICH9M

Jason Wessel (1):
      i386: fix infinite loop with singlestep int80 syscalls

Jay Lubomirski (1):
      serial: clear proper MPSC interrupt cause bits

Jeff Mahoney (1):
      saa7134: fix thread shutdown handling

Jiri Slaby (1):
      Char: cyclades, fix deadlock

Mike Accetta (1):
      md: Fix bug in error handling during raid1 repair.

Milan Broz (1):
      dm crypt: disable barriers

NeilBrown (3):
      md: Avoid overflow in raid0 calculation with large components.
      md: Don't write more than is required of the last page of a bitmap
      md: Fix two raid10 bugs.

Olaf Kirch (3):
      dm crypt: fix call to clone_init
      dm crypt: fix avoid cloned bio ref after free
      dm crypt: fix remove first_clone

Oleg Nesterov (1):
      make freezeable workqueues singlethread

Paul Mackerras (1):
      POWERPC: Fix subtle FP state corruption bug in signal return on SMP

Stephen Hemminger (1):
      sky2: workaround for lost IRQ

Thomas Gleixner (3):
      rt-mutex: Fix stale return value
      rt-mutex: Fix chain walk early wakeup bug
      FUTEX: Restore the dropped ERSCH fix

Tony Jones (1):
      audit: fix oops removing watch if audit disabled

Willy Tarreau (1):
      Linux 2.6.20.16

Zou Nan hai (1):
      x86_64: allocate sparsemem memmap above 4G

