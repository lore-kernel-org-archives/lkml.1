Return-Path: <linux-kernel-owner+w=401wt.eu-S1751562AbYJRTCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbYJRTCf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYJRTCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:02:25 -0400
Received: from kroah.org ([198.145.64.141]:39092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750926AbYJRTCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:02:24 -0400
Date: Sat, 18 Oct 2008 11:25:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.2
Message-ID: <20081018182504.GA3113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.2
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.1 and 2.6.27.2

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/x86/kernel/alternative.c         |    2 
 arch/x86/kernel/early-quirks.c        |   48 ++++++++++++
 arch/x86/kernel/io_apic_32.c          |    3 
 arch/x86/mm/ioremap.c                 |    2 
 drivers/char/tty_io.c                 |    2 
 drivers/net/atl1e/atl1e_main.c        |    2 
 drivers/net/sky2.c                    |   19 +----
 drivers/net/wireless/b43legacy/xmit.c |    2 
 drivers/net/wireless/libertas/main.c  |   20 +++++
 fs/cifs/cifsglob.h                    |    1 
 fs/cifs/cifssmb.c                     |    4 +
 fs/cifs/readdir.c                     |  128 +++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_buf.c            |    3 
 fs/xfs/linux-2.6/xfs_buf.h            |    8 ++
 fs/xfs/xfs_log.c                      |    7 +
 kernel/sched_rt.c                     |    8 +-
 net/mac80211/debugfs_netdev.c         |   14 +++
 net/rfkill/rfkill.c                   |    5 -
 19 files changed, 182 insertions(+), 98 deletions(-)

Alan Cox (2):
      tty: Termios locking - sort out real_tty confusions and lock reads
      x86, early_ioremap: fix fencepost error

Andreas Herrmann (1):
      x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC

Christoph Hellwig (1):
      Fix barrier fail detection in XFS

Dan Williams (1):
      libertas: clear current command on card removal

Dario Faggioli (1):
      sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq

Greg Kroah-Hartman (1):
      Linux 2.6.27.2

Henrique de Moraes Holschuh (1):
      rfkill: update LEDs for all state changes

Johannes Berg (1):
      mac80211: fix two issues in debugfs

Larry Finger (1):
      b43legacy: Fix failure in rate-adjustment mechanism

Matthew Wilcox (1):
      netdrvr: atl1e: Don't take the mdio_lock in atl1e_probe

Rafael J. Wysocki (1):
      sky2: Fix WOL regression

Stefan Bader (1):
      x86: Reserve FIRST_DEVICE_VECTOR in used_vectors bitmap.

Steve French (1):
      CIFS: make sure we have the right resume info before calling CIFSFindNext

Thomas Gleixner (1):
      x86: improve UP kernel when CPU-hotplug and SMP is enabled

