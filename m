Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXKPSlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXKPSlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXKPSlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:41:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52846 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbXKPSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:41:10 -0500
Date: Fri, 16 Nov 2007 10:39:40 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.2
Message-ID: <20071116183940.GC9807@kroah.com>
References: <20071116183752.GA9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116183752.GA9807@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.2 kernel.
It contains a number of bugfixes for the core kernel code.

I'll also be replying to this message with a copy of the patch between
2.6.23.1 and 2.6.23.2

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Documentation/ja_JP/HOWTO |   84 ++++++++++++++++++++++++----------------------
 Makefile                  |    2 -
 block/ll_rw_blk.c         |    8 +---
 fs/locks.c                |   11 ++++++
 fs/proc/array.c           |    6 ++-
 fs/splice.c               |    2 -
 include/linux/blkdev.h    |    2 -
 include/linux/sched.h     |    1 
 kernel/fork.c             |    2 +
 kernel/futex_compat.c     |   27 ++++++++++----
 kernel/lockdep.c          |   10 ++---
 kernel/params.c           |    9 +++-
 kernel/softlockup.c       |    7 ++-
 mm/filemap.c              |   13 +------
 mm/page-writeback.c       |    4 +-
 mm/shmem.c                |   15 ++++++++
 mm/slub.c                 |   22 ------------
 17 files changed, 125 insertions(+), 100 deletions(-)

Summary of changes from v2.6.23.1 to v2.6.23.2
==============================================

Andrew Morton (1):
      writeback: don't propagate AOP_WRITEPAGE_ACTIVATE

Christoph Lameter (1):
      SLUB: Fix memory leak by not reusing cpu_slab

Dave Young (1):
      param_sysfs_builtin memchr argument fix

David Miller (1):
      Fix compat futex hangs.

Frans Pop (1):
      sched: keep utime/stime monotonic

Greg Kroah-Hartman (1):
      Linux 2.6.23.2

Gregory Haskins (1):
      lockdep: fix mismatched lockdep_depth/curr_chain_hash

Hugh Dickins (1):
      fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE

Ingo Molnar (1):
      fix the softlockup watchdog to actually work

J. Bruce Fields (1):
      locks: fix possible infinite loop in posix deadlock detection

Jan Kiszka (1):
      fix param_sysfs_builtin name length check

Jens Axboe (2):
      splice: fix double kunmap() in vmsplice copy path
      BLOCK: Fix bad sharing of tag busy list on queues with shared tag maps

Linus Torvalds (1):
      Remove broken ptrace() special-case code from file mapping

Tsugikazu Shibata (1):
      HOWTO: update ja_JP/HOWTO with latest changes

