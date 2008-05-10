Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYEJFNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYEJFNQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 01:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYEJFNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 01:13:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59696 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYEJFND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 01:13:03 -0400
Date: Fri, 9 May 2008 22:08:48 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.3
Message-ID: <20080510050848.GA31127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.3 kernel.

Yes, its a few hours earlier than originally expected, but there are two
security bugs fixed in here that just recently were made public, so we
figured we would err on the safe side.  All users of the 2.6.25 series
are strongly encouraged to upgrade, and anyone running 2.6.24 should
also move up to 2.6.25 at this time if possible.

I'll also be replying to this message with a copy of the patch between
2.6.25.2 and 2.6.25.3

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                         |    2 -
 arch/arm/kernel/kprobes-decode.c |    2 -
 arch/arm/kernel/kprobes.c        |    2 -
 arch/sparc/kernel/sys_sparc.c    |    3 -
 arch/sparc64/kernel/sys_sparc.c  |    4 +-
 arch/x86/pci/common.c            |    7 ++--
 arch/x86/pci/init.c              |    2 +
 arch/x86/pci/pci.h               |    2 +
 crypto/authenc.c                 |    5 +-
 crypto/cryptd.c                  |    4 +-
 crypto/eseqiv.c                  |    3 +
 drivers/acpi/processor_idle.c    |    4 ++
 drivers/md/md.c                  |    2 -
 drivers/net/wireless/b43/b43.h   |    4 ++
 drivers/net/wireless/b43/main.c  |   40 ++++++++++++++++++-----
 drivers/serial/mpc52xx_uart.c    |    2 -
 fs/reiserfs/ioctl.c              |    4 --
 fs/reiserfs/super.c              |   17 +++++++---
 fs/utimes.c                      |   17 ++++++++--
 include/crypto/scatterwalk.h     |    4 ++
 include/linux/reiserfs_fs.h      |    1 
 kernel/sched.c                   |   66 ++++++++++++++++++++++++++++++++++++++-
 mm/page_alloc.c                  |   14 +++++++-
 net/ipv6/sit.c                   |    2 -
 24 files changed, 175 insertions(+), 38 deletions(-)


Dan Williams (1):
      md: fix use after free when removing rdev via sysfs

David S. Miller (2):
      sparc: Fix mmap VA span checking.
      sit: Add missing kfree_skb() on pskb_may_pull() failure.

Grant Likely (1):
      POWERPC: mpc5200: Fix unterminated of_device_id table

Greg Kroah-Hartman (1):
      Linux 2.6.25.3

Herbert Xu (2):
      CRYPTO: api: Fix scatterwalk_sg_chain
      CRYPTO: eseqiv: Fix off-by-one encryption

Jan Kara (1):
      reiserfs: Unpack tails on quota files

Julia Lawall (1):
      CRYPTO: cryptd: Correct kzalloc error test

KAMEZAWA Hiroyuki (1):
      mm: fix usemap initialization

Lennert Buytenhek (1):
      kprobes/arm: fix decoding of arithmetic immediate instructions

Michael Buesch (2):
      b43: Fix dual-PHY devices
      b43: Fix some TX/RX locking issues

Miklos Szeredi (1):
      vfs: fix permission checking in sys_utimensat

Nicolas Pitre (1):
      kprobes/arm: fix cache flush address for instruction stub

Patrick McHardy (1):
      CRYPTO: authenc: Fix async crypto crash in crypto_authenc_genicv()

Peter Zijlstra (1):
      sched: fix hrtick_start_fair and CPU-Hotplug

Venkatesh Pallipadi (1):
      2.6.25 regression: powertop says 120K wakeups/sec

Yinghai Lu (1):
      x86 PCI: call dmi_check_pciprobe()

