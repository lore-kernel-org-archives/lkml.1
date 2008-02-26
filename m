Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbYBZBEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbYBZBEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 20:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYBZBDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 20:03:51 -0500
Received: from ns1.suse.de ([195.135.220.2]:47707 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYBZBDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 20:03:51 -0500
Date: Mon, 25 Feb 2008 17:03:41 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.17
Message-ID: <20080226010341.GB26912@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.17
kernel.

It fixes a number of different bugs and all users of the 2.6.23 series
are encouraged to upgrade.

This should be the last release of the .23 kernel series, all users are
encouraged to move to the .24 kernel series at this time.

I'll also be replying to this message with a copy of the patch between
2.6.23.16 and 2.6.23.17

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                                  |    2 -
 arch/powerpc/platforms/powermac/feature.c |   11 +++++++-
 arch/x86_64/mm/pageattr.c                 |    2 -
 drivers/macintosh/smu.c                   |   25 ++++++++++++++++++-
 drivers/scsi/sd.c                         |   34 ++++++++++++--------------
 fs/nfs/write.c                            |   20 +++++++++++++--
 include/asm-powerpc/pmac_feature.h        |    8 ++++++
 include/linux/ktime.h                     |    2 +
 kernel/futex.c                            |    2 -
 kernel/futex_compat.c                     |    2 -
 kernel/hrtimer.c                          |   38 ++++++++++++++++--------------
 kernel/irq/chip.c                         |   20 +++++++++++++++
 kernel/posix-timers.c                     |    8 +++---
 mm/memory.c                               |    2 +
 net/netfilter/nf_conntrack_proto_tcp.c    |   33 ++++++++++++++++++++------
 15 files changed, 154 insertions(+), 55 deletions(-)

Summary of changes from v2.6.23.16 to v2.6.23.17
================================================

Benjamin Herrenschmidt (1):
      Disable G5 NAP mode during SMU commands on U3

Greg Kroah-Hartman (1):
      Linux 2.6.23.17

Ingo Molnar (1):
      x86_64: CPA, fix cache attribute inconsistency bug

James Bottomley (1):
      SCSI: sd: handle bad lba in sense information

Jonathan Corbet (1):
      Be more robust about bad arguments in get_user_pages()

Jozsef Kadlecsik (1):
      NETFILTER: nf_conntrack_tcp: conntrack reopening fix

Thomas Gleixner (2):
      hrtimer: check relative timeouts for overflow
      genirq: do not leave interupts enabled on free_irq

Trond Myklebust (1):
      NFS: Fix a potential file corruption issue when writing

