Return-Path: <linux-kernel-owner+w=401wt.eu-S933249AbYEAWGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbYEAWGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765535AbYEAWGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:06:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40731 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764022AbYEAWGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:06:03 -0400
Date: Thu, 1 May 2008 15:05:21 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.1
Message-ID: <20080501220521.GE28881@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.1 kernel.

If fixes a number of different bugs and some security issues so that all
users of the 2.6.25 series of kernels are strongly encouraged to
upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.25 and 2.6.25.1

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                              |    2 
 arch/alpha/kernel/osf_sys.c           |    1 
 arch/x86/kernel/io_apic_32.c          |    1 
 arch/x86/pci/irq.c                    |   12 ++---
 drivers/infiniband/hw/nes/nes.c       |    4 -
 drivers/infiniband/hw/nes/nes_cm.c    |    6 +-
 drivers/infiniband/hw/nes/nes_hw.c    |   20 ++++-----
 drivers/md/dm-exception-store.c       |    2 
 drivers/media/video/cx88/cx88-cards.c |    4 +
 drivers/media/video/ivtv/ivtv-ioctl.c |    3 -
 drivers/media/video/tea5761.c         |   15 ++++--
 drivers/media/video/tuner-core.c      |    6 +-
 drivers/net/s2io.c                    |    4 -
 drivers/net/tehuti.c                  |   15 ++++++
 drivers/net/tg3.c                     |   52 ++++++++++++++++++++++--
 drivers/net/tg3.h                     |    1 
 drivers/net/wireless/b43/dma.c        |   73 ++++++++++++++++++++++++----------
 drivers/net/wireless/b43/main.c       |   28 ++++++++++++-
 drivers/rtc/rtc-pcf8583.c             |    2 
 drivers/scsi/qla2xxx/qla_os.c         |    2 
 drivers/serial/dz.c                   |    2 
 drivers/ssb/pci.c                     |    5 ++
 drivers/usb/core/hub.c                |    1 
 drivers/usb/host/ohci-pci.c           |    4 +
 drivers/usb/serial/sierra.c           |    1 
 fs/aio.c                              |   12 +++++
 fs/dnotify.c                          |   11 +++++
 fs/jffs2/erase.c                      |   18 +++-----
 include/linux/rtnetlink.h             |    4 -
 include/net/tcp.h                     |    7 ++-
 include/net/xfrm.h                    |    3 +
 kernel/cgroup.c                       |    7 ++-
 kernel/hrtimer.c                      |   34 +++++++++++++--
 mm/pagewalk.c                         |    8 ++-
 net/can/raw.c                         |    3 -
 net/core/rtnetlink.c                  |    6 ++
 net/dccp/probe.c                      |    2 
 net/ipv4/tcp_probe.c                  |    9 +---
 net/key/af_key.c                      |    2 
 net/rose/af_rose.c                    |    6 +-
 net/tipc/socket.c                     |    4 -
 net/xfrm/xfrm_policy.c                |    2 
 net/xfrm/xfrm_user.c                  |    2 
 security/selinux/hooks.c              |   15 +++++-
 44 files changed, 318 insertions(+), 103 deletions(-)


Al Viro (1):
      Fix dnotify/close race (CVE-2008-1375)

Alan Cox (1):
      V4L: Fix VIDIOCGAP corruption in ivtv

Alan Stern (2):
      USB: log an error message when USB enumeration fails
      USB: OHCI: fix bug in controller resume

Andrew Vasquez (1):
      SCSI: qla2xxx: Correct regression in relogin code.

Bernard Pidoux (1):
      rose: Socket lock was not released before returning to user space

Björn Steinbrink (1):
      x86, pci: fix off-by-one errors in some pirq warnings

Bodo Stroesser (1):
      hrtimer: timeout too long when using HRTIMER_CB_SOFTIRQ

Chien Tung (1):
      RDMA/nes: Fix adapter reset after PXE boot

David Brownell (1):
      rtc-pcf8583 build fix

David Woodhouse (1):
      JFFS2: Fix free space leak with in-band cleanmarkers

Eric Paris (1):
      SELinux: no BUG_ON(!ss_initialized) in selinux_clone_mnt_opts

Francois Romieu (1):
      tehuti: check register size (CVE-2008-1675)

Greg Kroah-Hartman (1):
      Linux 2.6.25.1

Herbert Xu (1):
      IPSEC: Fix catch-22 with algorithm IDs above 31

Ivan Kokshaysky (1):
      alpha: unbreak OSF/1 (a.out) binaries

Jeff Garzik (1):
      tehuti: move ioctl perm check closer to function start (CVE-2008-1675)

Jeff Moyer (1):
      aio: io_getevents() should return if io_destroy() is invoked

Johannes Weiner (1):
      mm: fix possible off-by-one in walk_pte_range()

John Heffner (1):
      TCP: Increase the max_burst threshold from 3 to tp->reordering.

Larry Finger (1):
      ssb: Fix all-ones boardflags

Li Zefan (1):
      cgroup: fix a race condition in manipulating tsk->cg_list

Linus Torvalds (1):
      drivers/net/tehuti: use proper capability check for raw IO access

Matt Carlson (1):
      tg3: 5701 DMA corruption fix

Mauro Carvalho Chehab (1):
      V4L: tea5761: bugzilla #10462: tea5761 autodetection code were broken

Michael Buesch (3):
      b43: Workaround invalid bluetooth settings
      b43: Add more btcoexist workarounds
      b43: Workaround DMA quirks

Mikulas Patocka (1):
      dm snapshot: fix chunksize sector conversion

PJ Waskiewicz (1):
      x86: Fix 32-bit x86 MSI-X allocation leakage

Patrick McHardy (1):
      RTNETLINK: Fix bogus ASSERT_RTNL warning

Pavel Emelyanov (1):
      net: Fix wrong interpretation of some copy_to_user() results.

Roel Kluin (1):
      dz: test after postfix decrement fails in dz_console_putchar()

Roland Dreier (1):
      RDMA/nes: Free IRQ before killing tasklet

Sreenivasa Honnur (2):
      S2io: Fix memory leak during free_tx_buffers
      S2io: Version update for memory leak fix during free_tx_buffers

Stefan Seyfried (1):
      USB: Add HP hs2300 Broadband Wireless Module to sierra.c

Steven Toth (1):
      V4L: cx88: enable radio GPIO correctly

Thomas Gleixner (1):
      hrtimer: raise softirq unlocked to avoid circular lock dependency

Tom Quetchenbach (1):
      tcp: tcp_probe buffer overflow and incorrect return value

