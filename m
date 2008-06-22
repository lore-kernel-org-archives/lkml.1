Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbYFVFg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbYFVFg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 01:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYFVFgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 01:36:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYFVFgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 01:36:17 -0400
Date: Sat, 21 Jun 2008 22:33:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.8
Message-ID: <20080622053334.GA13674@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.8 kernel.

It contains a number of assorted bugfixes all over the tree.  Users are
encouraged to update.

I'll also be replying to this message with a copy of the patch between
2.6.25.7 and 2.6.25.8

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                               |    2 +-
 arch/x86/kernel/process_32.c           |   23 +++++++++++++++++++++--
 arch/x86/kernel/process_64.c           |   24 +++++++++++++++++++++---
 arch/x86/lib/copy_user_64.S            |   25 +++++++++++--------------
 arch/x86/lib/copy_user_nocache_64.S    |   25 +++++++++++--------------
 drivers/acpi/tables/tbinstal.c         |   18 +++++++-----------
 drivers/ide/pci/opti621.c              |   23 ++++-------------------
 drivers/net/virtio_net.c               |    8 +++++---
 drivers/net/wireless/b43/b43.h         |    1 -
 drivers/net/wireless/b43/dma.c         |    2 +-
 drivers/net/wireless/b43/main.c        |   16 ++++++++++------
 drivers/scsi/hosts.c                   |    5 +++--
 drivers/scsi/sr.c                      |    3 +++
 drivers/serial/8250.c                  |    4 +++-
 net/netfilter/nf_conntrack_core.c      |    3 +--
 net/netfilter/nf_conntrack_h323_main.c |   22 +++++++++++++++-------
 16 files changed, 117 insertions(+), 87 deletions(-)


Alan Cox (1):
      Fix tty speed handling on 8250

Bartlomiej Zolnierkiewicz (2):
      opti621: disable read prefetch
      opti621: remove DMA support

Bob Moore (1):
      ACPICA: Ignore ACPI table signature for Load() operator

Greg Kroah-Hartman (1):
      Linux 2.6.25.8

Ingo Molnar (1):
      x86: remove mwait capability C-state check

James Bottomley (1):
      SCSI: sr: fix corrupt CD data after media change and delay

Linus Torvalds (1):
      x86-64: Fix "bytes left to copy" return value for copy_from_user()

Mark McLoughlin (1):
      virtio_net: Fix skb->csum_start computation

Michael Buesch (2):
      b43: Fix noise calculation WARN_ON
      b43: Fix possible NULL pointer dereference in DMA code

Mike Christie (1):
      scsi_host regression: fix scsi host leak

Patrick McHardy (3):
      nf_conntrack: fix ctnetlink related crash in nf_nat_setup_info()
      nf_conntrack_h323: fix module unload crash
      nf_conntrack_h323: fix memory leak in module initialization error path

Thomas Gleixner (1):
      x86: disable mwait for AMD family 10H/11H CPUs

