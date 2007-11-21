Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbXKUSBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbXKUSBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXKUSBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:01:02 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38240 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbXKUSBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:01:00 -0500
Date: Wed, 21 Nov 2007 09:56:44 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.14
Message-ID: <20071121175644.GA1329@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.14 kernel.
It fixes a bunch of issues, so any user of the 2.6.22 series is
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.13 and 2.6.22.14

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                               |    2 
 arch/i386/kernel/tsc.c                 |    5 
 drivers/i2c/busses/i2c-pasemi.c        |    5 
 drivers/i2c/chips/eeprom.c             |   37 ++++---
 drivers/ide/pci/serverworks.c          |    1 
 drivers/isdn/hardware/avm/b1.c         |   28 ++---
 drivers/isdn/hardware/avm/c4.c         |   14 ++
 drivers/net/forcedeth.c                |   19 ++-
 drivers/scsi/hptiop.c                  |    5 
 drivers/usb/core/hcd.h                 |    8 +
 drivers/usb/core/hub.c                 |   15 ++
 drivers/usb/host/ehci-hcd.c            |    8 +
 drivers/usb/serial/generic.c           |    7 -
 drivers/usb/serial/kobil_sct.c         |  170 +++++++++++++--------------------
 fs/ocfs2/aops.c                        |   24 ++++
 include/linux/netlink.h                |    2 
 ipc/mqueue.c                           |    6 -
 kernel/futex_compat.c                  |   24 +++-
 kernel/params.c                        |   15 +-
 mm/page-writeback.c                    |    4 
 mm/shmem.c                             |   15 ++
 mm/slub.c                              |   22 ----
 net/ipv4/ipcomp.c                      |    3 
 net/ipv6/ipcomp6.c                     |    3 
 net/netfilter/nf_conntrack_proto_tcp.c |   38 +++----
 net/netlink/af_netlink.c               |   10 -
 net/sched/cls_u32.c                    |    4 
 net/sched/sch_teql.c                   |    3 
 net/socket.c                           |    5 
 sound/pci/hda/patch_sigmatel.c         |   14 +-
 sound/pci/rme9652/hdsp.c               |    3 
 31 files changed, 291 insertions(+), 228 deletions(-)

Summary of changes from v2.6.22.13 to v2.6.22.14
================================================

Alan Stern (1):
      USB: mutual exclusion for EHCI init and port resets

Andrew Morton (1):
      writeback: don't propagate AOP_WRITEPAGE_ACTIVATE

Christoph Lameter (1):
      SLUB: Fix memory leak by not reusing cpu_slab

Dave Johnson (1):
      x86: fix TSC clock source calibration error

David Miller (2):
      Fix compat futex hangs.
      Fix error returns in sys_socketpair()

Evgeniy Polyakov (1):
      Fix TEQL oops.

Frank Seidel (1):
      USB: kobil_sct: trivial backport to fix libct

Greg Kroah-Hartman (1):
      Linux 2.6.22.14

Herbert Xu (1):
      Fix crypto_alloc_comp() error checking.

HighPoint Linux Team (1):
      hptiop: avoid buffer overflow when returning sense data

Hugh Dickins (1):
      fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE

Jan Kiszka (1):
      fix param_sysfs_builtin name length check

Jean Delvare (3):
      i2c-pasemi: Fix NACK detection
      i2c/eeprom: Hide Sony Vaio serial numbers
      i2c/eeprom: Recognize VGN as a valid Sony Vaio name prefix

Jiri Kosina (1):
      USB: usbserial - fix potential deadlock between write() and IRQ

Jozsef Kadlecsik (1):
      NETFILTER: nf_conntrack_tcp: fix connection reopening

Karsten Keil (2):
      i4l: Fix random hard freeze with AVM c4 card
      i4l: fix random freezes with AVM B1 drivers

Manfred Spraul (1):
      forcedeth msi bugfix

Mark Fasheh (1):
      ocfs2: fix write() performance regression

Patrick McHardy (1):
      Fix netlink timeouts.

Radu Rendec (1):
      Fix endianness bug in U32 classifier.

Takashi Iwai (2):
      ALSA: hdsp - Fix zero division
      ALSA: hda-codec - Add array terminator for dmic in STAC codec

Tony Battersby (1):
      ide: fix serverworks.c UDMA regression

