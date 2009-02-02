Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbZBBS06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbZBBS06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZBBS0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:26:47 -0500
Received: from kroah.org ([198.145.64.141]:48062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752808AbZBBS0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:26:46 -0500
Date: Mon, 2 Feb 2009 10:24:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.14
Message-ID: <20090202182404.GA7097@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.14
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.13 and 2.6.27.14

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 
 arch/alpha/kernel/irq_srm.c            |    2 
 crypto/authenc.c                       |   24 +++--
 crypto/ccm.c                           |    2 
 drivers/ata/pata_via.c                 |   22 ++++-
 drivers/ide/pci/it821x.c               |   12 ++
 drivers/misc/sgi-xp/xpc_sn2.c          |   19 ++--
 drivers/misc/sgi-xp/xpc_uv.c           |    2 
 drivers/net/bnx2x_main.c               |    3 
 drivers/net/wireless/rtl8187_dev.c     |    1 
 drivers/net/wireless/rtl8187_rtl8225.c |   10 +-
 drivers/pci/hotplug/pciehp_core.c      |    4 
 drivers/serial/8250_pci.c              |    3 
 drivers/usb/core/devio.c               |   20 ++--
 drivers/usb/core/inode.c               |    1 
 drivers/usb/core/usb.h                 |    1 
 drivers/usb/mon/mon_bin.c              |  105 ++++++++++++++++---------
 drivers/usb/storage/unusual_devs.h     |    6 +
 fs/eventpoll.c                         |   22 -----
 fs/ext3/namei.c                        |   20 +++-
 fs/fuse/dev.c                          |    3 
 fs/fuse/file.c                         |    2 
 fs/fuse/inode.c                        |   10 +-
 fs/inotify_user.c                      |  135 ++++++++++++++++++---------------
 fs/sysfs/bin.c                         |    6 +
 include/asm-x86/pgalloc.h              |    1 
 include/linux/Kbuild                   |    1 
 include/linux/pci_ids.h                |    6 +
 include/linux/sched.h                  |    1 
 kernel/relay.c                         |    4 
 net/mac80211/tx.c                      |    4 
 net/sunrpc/rpcb_clnt.c                 |   40 +++++++--
 sound/pci/hda/patch_conexant.c         |    1 
 sound/pci/hda/patch_realtek.c          |    1 
 sound/pci/hda/patch_sigmatel.c         |    2 
 sound/pci/oxygen/virtuoso.c            |   22 +++--
 36 files changed, 336 insertions(+), 184 deletions(-)

Alan Stern (1):
      USB: fix char-device disconnect handling

Boaz Harrosh (1):
      include/linux: Add bsg.h to the Kernel exported headers

Brandon Philips (1):
      it821x: Add ultra_mask quirk for Vortex86SX

Brian Cavagnolo (1):
      mac80211: decrement ref count to netdev after launching mesh discovery

Clemens Ladisch (1):
      sound: virtuoso: do not overwrite EEPROM on Xonar D2/D2X

Dan Carpenter (1):
      fuse: fix NULL deref in fuse_file_alloc()

Davide Libenzi (1):
      epoll: drop max_user_instances and rely only on max_user_watches

Eilon Greenstein (1):
      bnx2x: Block nvram access when the device is inactive

Flavio Leitner (1):
      serial_8250: support for Sealevel Systems Model 7803 COMM+8

Greg Kroah-Hartman (2):
      sysfs: fix problems with binary files
      Linux 2.6.27.14

Herbert Xu (1):
      crypto: authenc - Fix zero-length IV crash

Ivan Kokshaysky (1):
      alpha: nautilus - fix compile failure with gcc-4.3

Jarod Wilson (1):
      crypto: ccm - Fix handling of null assoc data

Jiri Slaby (2):
      PCI hotplug: fix lock imbalance in pciehp
      relay: fix lock imbalance in relay_late_setup_files

Joerg Schirottke (1):
      ALSA: hda - Add quirk for HP DV6700 laptop

JosephChan@via.com.tw (1):
      libata: pata_via: support VX855, future chips whose IDE controller use 0x0571

Larry Finger (2):
      rtl8187: Add termination packet to prevent stall
      rtl8187: Fix error in setting OFDM power settings for RTL8187L

Luke Yelavich (1):
      ALSA: hda - add another MacBook Pro 4, 1 subsystem ID

Miklos Szeredi (2):
      fuse: destroy bdi on umount
      fuse: fix missing fput on error

Oliver Neukum (1):
      USB: storage: add unusual devs entry

Pete Zaitcev (1):
      USB: usbmon: Implement compat_ioctl

Peter Zijlstra (1):
      x86, mm: fix pte_free()

Robin Holt (2):
      sgi-xpc: ensure flags are updated before bte_copy
      sgi-xpc: Remove NULL pointer dereference.

Takashi Iwai (1):
      ALSA: hda - Fix PCM reference NID for STAC/IDT analog outputs

Theodore Ts'o (1):
      ext3: Add sanity check to make_indexed_dir

Trond Myklebust (2):
      SUNRPC: Fix a memory leak in rpcb_getport_async
      SUNRPC: Fix autobind on cloned rpc clients

Vegard Nossum (1):
      inotify: clean up inotify_read and fix locking problems

