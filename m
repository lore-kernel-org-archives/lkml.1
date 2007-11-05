Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbXKESMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbXKESMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXKESMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:12:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59226 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbXKESMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:12:47 -0500
Date: Mon, 5 Nov 2007 10:07:37 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.12
Message-ID: <20071105180736.GA28562@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.12 kernel.
It fixes a number of reported bugs, and any user of the 2.6.22 series is
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.11 and 2.6.22.12

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                             |    2 -
 arch/i386/kernel/io_apic.c           |    7 +++--
 arch/x86_64/kernel/io_apic.c         |    7 +++--
 arch/x86_64/mm/init.c                |    5 ---
 arch/x86_64/mm/pageattr.c            |    9 +++++-
 drivers/infiniband/core/uverbs_cmd.c |    8 ++++-
 drivers/md/dm-exception-store.c      |   48 +++++++++++++++++++++++++++++++----
 fs/minix/itree_v1.c                  |    9 +++++-
 fs/minix/itree_v2.c                  |    9 +++++-
 include/linux/bootmem.h              |    1 
 kernel/irq/chip.c                    |    5 ---
 kernel/irq/resend.c                  |    7 ++++-
 kernel/params.c                      |    8 +++++
 mm/sparse.c                          |   11 --------
 14 files changed, 95 insertions(+), 41 deletions(-)

Summary of changes from v2.6.22.11 to v2.6.22.12
================================================

Dave Young (1):
      param_sysfs_builtin memchr argument fix

Eric Sandeen (1):
      minixfs: limit minixfs printks on corrupted dir i_size (CVE-2006-6058)

Greg Kroah-Hartman (1):
      Linux 2.6.22.12

Ingo Molnar (1):
      x86: fix global_flush_tlb() bug

Linus Torvalds (1):
      Revert "x86_64: allocate sparsemem memmap above 4G"

Milan Broz (1):
      dm snapshot: fix invalidation deadlock

Roland Dreier (1):
      IB/uverbs: Fix checking of userspace object ownership

Thomas Gleixner (3):
      genirq: cleanup mismerge artifact
      genirq: suppress resend of level interrupts
      genirq: mark io_apic level interrupts to avoid resend

