Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbZEBUGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbZEBUGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbZEBUFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:05:38 -0400
Received: from kroah.org ([198.145.64.141]:49709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761724AbZEBUFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:05:35 -0400
Date: Sat, 2 May 2009 13:05:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.21
Message-ID: <20090502200515.GC7287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.22 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.21 and 2.6.27.22

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 
 arch/powerpc/include/asm/futex.h       |   12 +-
 arch/powerpc/include/asm/processor.h   |   19 +++
 arch/powerpc/kernel/signal.c           |    4 
 arch/powerpc/kernel/signal.h           |    2 
 arch/powerpc/kernel/signal_32.c        |    4 
 arch/powerpc/kernel/signal_64.c        |    2 
 arch/x86/boot/memory.c                 |    7 -
 arch/x86/kernel/cpu/mtrr/generic.c     |   51 +++++----
 arch/x86/pci/i386.c                    |    3 
 drivers/acpi/ec.c                      |   43 +++----
 drivers/ata/pata_hpt37x.c              |   22 ---
 drivers/char/agp/generic.c             |    2 
 drivers/char/raw.c                     |    1 
 drivers/crypto/ixp4xx_crypto.c         |  182 +++++++++++----------------------
 drivers/ide/pci/hpt366.c               |    4 
 drivers/isdn/gigaset/bas-gigaset.c     |   16 ++
 drivers/misc/thinkpad_acpi.c           |   41 +++----
 drivers/net/b44.c                      |    2 
 drivers/net/bonding/bond_main.c        |   25 +++-
 drivers/net/bonding/bonding.h          |    6 +
 drivers/net/r8169.c                    |  106 +++++++++++--------
 drivers/net/wireless/ath9k/ath9k.h     |    4 
 drivers/net/wireless/ath9k/core.c      |    1 
 drivers/net/wireless/ath9k/core.h      |   33 +++++
 drivers/net/wireless/ath9k/hw.c        |   22 +++
 drivers/net/wireless/b43/xmit.c        |    2 
 drivers/scsi/libiscsi.c                |    9 -
 drivers/usb/class/cdc-wdm.c            |    2 
 drivers/usb/gadget/f_rndis.c           |    2 
 drivers/usb/gadget/u_ether.c           |    8 -
 drivers/usb/host/ehci-q.c              |   32 +++++
 drivers/usb/host/ehci.h                |    3 
 drivers/usb/serial/ftdi_sio.c          |    1 
 drivers/usb/serial/ftdi_sio.h          |    7 +
 drivers/usb/storage/cypress_atacb.c    |   15 +-
 drivers/usb/storage/scsiglue.c         |    6 +
 drivers/usb/storage/unusual_devs.h     |    6 -
 fs/buffer.c                            |    2 
 fs/cifs/CHANGES                        |    3 
 fs/cifs/cifssmb.c                      |    6 -
 fs/cifs/connect.c                      |    2 
 fs/compat.c                            |   12 +-
 fs/dquot.c                             |    2 
 fs/drop_caches.c                       |    2 
 fs/exec.c                              |    4 
 fs/fs-writeback.c                      |    3 
 fs/hugetlbfs/inode.c                   |    3 
 fs/ocfs2/file.c                        |    8 +
 fs/proc/base.c                         |   50 ++-------
 fs/splice.c                            |   25 +++-
 include/linux/capability.h             |   23 +++-
 include/linux/pci_regs.h               |    2 
 include/linux/sched.h                  |    3 
 kernel/exit.c                          |    3 
 kernel/kprobes.c                       |    4 
 kernel/signal.c                        |    8 +
 mm/filemap_xip.c                       |    4 
 mm/mmap.c                              |    3 
 net/bridge/br_if.c                     |    1 
 net/ipv4/netfilter/arp_tables.c        |    4 
 net/ipv4/netfilter/ip_tables.c         |    4 
 net/ipv6/inet6_hashtables.c            |    4 
 net/ipv6/ip6_input.c                   |    4 
 net/ipv6/netfilter/ip6_tables.c        |    4 
 net/netfilter/nf_conntrack_proto_tcp.c |    3 
 net/netrom/af_netrom.c                 |    8 +
 net/rose/af_rose.c                     |    4 
 net/sctp/endpointola.c                 |    3 
 net/x25/af_x25.c                       |    6 +
 security/selinux/hooks.c               |    1 
 security/smack/smack_lsm.c             |    4 
 sound/pci/hda/patch_analog.c           |    2 
 73 files changed, 550 insertions(+), 383 deletions(-)

Akinobu Mita (2):
      ALSA: hda - add missing comma in ad1884_slave_vols
      hugetlbfs: return negative error code for bad mount option

Al Viro (1):
      net: fix sctp breakage

Alan Cox (1):
      af_rose/x25: Sanity check the maximum user frame size

Alan Stern (3):
      USB: EHCI: add software retry for transaction errors
      USB: usb-storage: increase max_sectors for tape drives
      USB: usb-storage: augment unusual_devs entry for Simple Tech/Datafab

Alexey Starikovskiy (1):
      ACPI: EC: Add some basic check for ECDT data

Ananth N Mavinakayanahalli (1):
      kprobes: Fix locking imbalance in kretprobes

Andreas Herrmann (1):
      x86: mtrr: don't modify RdDram/WrDram bits of fixed MTRRs

Boaz Harrosh (1):
      USB: fix USB_STORAGE_CYPRESS_ATACB

Christian Hohnstaedt (1):
      crypto: ixp4xx - Fix handling of chained sg buffers

Dan Carpenter (1):
      Add a missing unlock_kernel() in raw_open()

David Brownell (1):
      USB: gadget: fix rndis regression

Etienne Basset (1):
      security/smack: fix oops when setting a size 0 SMACK64 xattr

Eugene Teo (1):
      unreached code in selinux_ip_postroute_iptables_compat() (CVE-2009-1184)

Francois Romieu (3):
      r8169: Don't update statistics counters when interface is down
      r8169: use hardware auto-padding.
      r8169: reset IntrStatus after chip reset

Greg Kroah-Hartman (1):
      Linux 2.6.27.22

Hannes Eder (1):
      ACPI: EC: fix compilation warning

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: fix LED blinking through timer trigger

Hugh Dickins (1):
      fs core fixes

Jay Vosburgh (1):
      bonding: Fix updating of speed/duplex changes

Jean Delvare (3):
      net/netrom: Fix socket locking
      SCSI: libiscsi: fix iscsi pool error path
      SCSI: libiscsi: fix iscsi pool error path again

Jeff Layton (1):
      cifs: fix buffer format byte on NT Rename/hardlink

Jens Axboe (1):
      block: revert part of 18ce3751ccd488c78d3827e9f6bf54e6322676fb

Jesper Nilsson (1):
      ipv6: Plug sk_buff leak in ipv6_rcv (net/ipv6/ip6_input.c)

Johannes Weiner (1):
      mm: check for no mmaps in exit_mmap()

Jonathan McDowell (1):
      usb gadget: fix ethernet link reports to ethtool

Josh Boyer (1):
      powerpc: Sanitize stack pointer in signal handling code

Lorenzo Nava (1):
      b43: fix b43_plcp_get_bitrate_idx_ofdm return type

Luis R. Rodriguez (2):
      ath9k: implement IO serialization
      ath9k: AR9280 PCI devices must serialize IO as well

Mark H. Weaver (1):
      netfilter: nf_conntrack_tcp: fix unaligned memory access in tcp_sack

Martin Schwidefsky (1):
      mm: do_xip_mapping_read: fix length calculation

Michael Buesch (1):
      b44: Use kernel DMA addresses for the kernel DMA API

Michael K. Johnson (1):
      x86, setup: mark %esi as clobbered in E820 BIOS call

Miklos Szeredi (2):
      splice: fix deadlock in splicing to file
      fix ptrace slowness

Nathan Lynch (1):
      sched: do not count frozen tasks toward load

Oleg Nesterov (1):
      exit_notify: kill the wrong capable(CAP_KILL) check (CVE-2009-1337)

Oliver Neukum (1):
      USB: fix oops in cdc-wdm in case of malformed descriptors

Pallipadi, Venkatesh (1):
      x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot

Patrick McHardy (1):
      netfilter: {ip, ip6, arp}_tables: fix incorrect loop detection

Paul Mackerras (1):
      powerpc: Fix data-corrupting bug in __futex_atomic_op

Pavel Emelyanov (1):
      ipv6: don't use tw net when accounting for recycled tw

Peter Korsgaard (1):
      USB: ftdi_sio: add vendor/project id for JETI specbos 1201 spectrometer

Serge E. Hallyn (1):
      add some long-missing capabilities to fs_mask

Sergei Shtylyov (2):
      hpt366: fix HPT370 DMA timeouts
      pata_hpt37x: fix HPT370 DMA timeouts

Shaohua Li (1):
      agp: zero pages before sending to userspace

Stephen Hemminger (1):
      bridge: bad error handling when adding invalid ether address

Steve French (1):
      CIFS: Fix memory overwrite when saving nativeFileSystem field during mount

Tilman Schmidt (1):
      bas_gigaset: correctly allocate USB interrupt transfer buffer

Wu Fengguang (1):
      vfs: skip I_CLEAR state inodes

Yu Zhao (1):
      PCI: fix incorrect mask of PM No_Soft_Reset bit

