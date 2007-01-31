Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXAaPBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXAaPBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbXAaPBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:01:49 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53029 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933327AbXAaPBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:01:48 -0500
Date: Wed, 31 Jan 2007 16:01:54 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.39
Message-ID: <20070131150154.GU3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.38:

Adrian Bunk (4):
      [Bluetooth] Let BT_HIDP depend on INPUT
      kbuild: explicitly turn off gcc stack-protector
      Linux 2.6.16.39-rc1
      Linux 2.6.16.39

Alan Cox (1):
      atiixp: hang fix

Alexey Dobriyan (1):
      V4L/DVB: Flexcop-usb: fix debug printk

Andrew de Quincey (1):
      V4L/DVB: Fix uninitialised variable in dvb_frontend_swzigzag

David S. Miller (1):
      BLUETOOTH: Fix unaligned access in hci_send_to_sock.

Eric Sesterhenn (1):
      V4L/DVB: Missing statement in drivers/media/dvb/frontends/cx22700.c

Hugh Dickins (1):
      read_zero_pagealigned() locking fix

James Bursa (1):
      adfs: fix filename handling

Jan Andersson (1):
      sparc32: add offset in pci_map_sg()

Jens Axboe (1):
      cdrom: set default timeout to 7 seconds

Jes Sorensen (2):
      [SCSI] qla1280 command timeout
      [SCSI] qla1280 bus reset typo

Marcel Holtmann (8):
      [Bluetooth] Check if DLC is still attached to the TTY
      [Bluetooth] More checks if DLC is still attached to the TTY
      [Bluetooth] Fix uninitialized return value for RFCOMM sendmsg()
      [Bluetooth] Return EINPROGRESS for non-blocking socket calls
      [Bluetooth] Handle command complete event for exit periodic inquiry
      [Bluetooth] Fix compat ioctl for BNEP, CMTP and HIDP
      [Bluetooth] Add locking for bt_proto array manipulation
      [Bluetooth] Fix deadlock in the L2CAP layer

Martin Schwidefsky (1):
      s390: connector support

Nick Piggin (1):
      mm: fix bug in set_page_dirty_buffers

Patrick McHardy (2):
      NETFILTER: NAT: fix NOTRACK checksum handling
      NETFILTER: arp_tables: missing unregistration on module unload

Shaohua Li (1):
      i386: fix CPU hotplug with 2GB VMSPLIT


 Makefile                                  |    7 +
 arch/i386/kernel/smpboot.c                |    2 
 arch/s390/Kconfig                         |    2 
 arch/sparc/kernel/ioport.c                |    3 
 drivers/cdrom/cdrom.c                     |    8 +-
 drivers/char/mem.c                        |   12 ++-
 drivers/ide/pci/atiixp.c                  |   18 ++--
 drivers/media/dvb/b2c2/flexcop-usb.c      |    2 
 drivers/media/dvb/dvb-core/dvb_frontend.c |    2 
 drivers/media/dvb/frontends/cx22700.c     |    1 
 drivers/scsi/qla1280.c                    |   11 +--
 fs/adfs/dir_f.c                           |    2 
 fs/buffer.c                               |    5 +
 include/net/bluetooth/hci.h               |    2 
 mm/memory.c                               |   32 +++++---
 net/bluetooth/af_bluetooth.c              |   38 ++++++++--
 net/bluetooth/bnep/sock.c                 |   69 ++++++++++++++----
 net/bluetooth/cmtp/sock.c                 |   35 +++++++++
 net/bluetooth/hci_event.c                 |    1 
 net/bluetooth/hci_sock.c                  |   13 ++-
 net/bluetooth/hidp/Kconfig                |    3 
 net/bluetooth/hidp/sock.c                 |   80 +++++++++++++++++++++-
 net/bluetooth/l2cap.c                     |   20 ++---
 net/bluetooth/rfcomm/core.c               |    2 
 net/bluetooth/rfcomm/sock.c               |   12 ++-
 net/bluetooth/rfcomm/tty.c                |   25 ++++--
 net/bluetooth/sco.c                       |    3 
 net/ipv4/netfilter/arp_tables.c           |    2 
 net/ipv4/netfilter/ip_nat_standalone.c    |   11 +--
 29 files changed, 322 insertions(+), 101 deletions(-)

