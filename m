Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbXHDQeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbXHDQeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbXHDQd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:33:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43022 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbXHDQdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:33:55 -0400
Date: Sat, 4 Aug 2007 09:34:27 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.21.7
Message-ID: <20070804163427.GA21267@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.21.7 kernel.
All users of the 2.6.21 kernel series are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.21.6 and 2.6.21.7

The updated 2.6.21.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=summary

thanks,

greg k-h

---------

 Makefile                                      |    2 
 arch/i386/kernel/entry.S                      |    8 -
 arch/powerpc/kernel/signal_64.c               |   10 -
 arch/x86_64/mm/init.c                         |    2 
 drivers/ide/pci/hpt366.c                      |    8 -
 drivers/md/dm-crypt.c                         |   50 ++----
 drivers/md/raid1.c                            |   21 +-
 drivers/md/raid10.c                           |    6 
 drivers/media/video/bt8xx/bttv-driver.c       |   13 -
 drivers/media/video/cx88/cx88-blackbird.c     |    2 
 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 
 drivers/net/bnx2.c                            |   25 +--
 drivers/net/sky2.c                            |    9 +
 drivers/serial/mpsc.c                         |    3 
 include/linux/sched.h                         |    1 
 ipc/shm.c                                     |    4 
 kernel/auditfilter.c                          |    2 
 kernel/exit.c                                 |   22 ++
 kernel/futex.c                                |  205 ++++++++++++++++----------
 kernel/posix-timers.c                         |   35 ++++
 kernel/rtmutex.c                              |   24 ++-
 kernel/sched.c                                |   22 +-
 kernel/time/ntp.c                             |    2 
 mm/rmap.c                                     |   24 ---
 24 files changed, 319 insertions(+), 183 deletions(-)

Summary of changes from v2.6.21.6 to v2.6.21.7
==============================================

Adam Litke (1):
      hugetlb: fix get_policy for stacked shared memory files

Alexey Kuznetsov (1):
      pi-futex: Fix exit races and locking problems

Bob Picco (1):
      sparsemem: fix oops in x86_64 show_mem

Christoph Lameter (1):
      sched: fix next_interval determination in idle_balance()

Greg Kroah-Hartman (1):
      Linux 2.6.21.7

Hugh Dickins (1):
      mm: kill validate_anon_vma to avoid mapcount BUG

Jason Wessel (1):
      b
      i386: fix infinite loop with singlestep int80 syscalls

Jay Lubomirski (1):
      serial: clear proper MPSC interrupt cause bits

Jeff Mahoney (1):
      saa7134: fix thread shutdown handling

Jelle Foks (1):
      V4L: cx88-blackbird: fix vidioc_g_tuner never ending list of tuners

Michael Chan (1):
      BNX2: Fix netdev watchdog on 5708.

Mike Accetta (1):
      md: Fix bug in error handling during raid1 repair.

Milan Broz (1):
      dm crypt: disable barriers

NeilBrown (1):
      md: Fix two raid10 bugs.

Olaf Kirch (3):
      dm crypt: fix call to clone_init
      dm crypt: fix avoid cloned bio ref after free
      dm crypt: fix remove first_clone

Paul Mackerras (1):
      POWERPC: Fix subtle FP state corruption bug in signal return on SMP

Sergei Shtylyov (1):
      hpt366: disallow Ultra133 for HPT374

Stephen Hemminger (1):
      sky2: workaround for lost IRQ

Thomas Gleixner (5):
      rt-mutex: Fix stale return value
      rt-mutex: Fix chain walk early wakeup bug
      posix-timers: Prevent softirq starvation by small intervals and SIG_IGN
      FUTEX: Restore the dropped ERSCH fix
      NTP: remove clock_was_set() call to prevent deadlock

Tony Jones (1):
      audit: fix oops removing watch if audit disabled

Trent Piepho (1):
      V4L: bttv: fix v4l1 api usage breaking the driver

