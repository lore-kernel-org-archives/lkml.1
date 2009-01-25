Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZAYAwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZAYAwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 19:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbZAYAvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 19:51:46 -0500
Received: from kroah.org ([198.145.64.141]:60271 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753959AbZAYAvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 19:51:38 -0500
Date: Sat, 24 Jan 2009 16:49:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.28.2
Message-ID: <20090125004958.GC6711@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.28.2
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.28.1 and 2.6.28.2

The updated 2.6.28.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/sound/alsa/ALSA-Configuration.txt |    3 
 Makefile                                        |    2 
 arch/ia64/Kconfig                               |    1 
 arch/powerpc/mm/slice.c                         |   11 +
 drivers/firmware/dell_rbu.c                     |    4 
 drivers/hwmon/abituguru3.c                      |    2 
 drivers/misc/sgi-xp/xpc_sn2.c                   |    2 
 drivers/net/irda/irda-usb.c                     |    2 
 drivers/net/r6040.c                             |   17 +-
 drivers/net/wireless/p54/p54usb.c               |    6 
 drivers/net/wireless/rt2x00/rt73usb.c           |    1 
 drivers/pci/pcie/aspm.c                         |  125 ++++++++++++++--
 drivers/usb/core/driver.c                       |    9 -
 drivers/usb/core/hub.c                          |    2 
 drivers/usb/core/message.c                      |   25 ++-
 drivers/usb/core/usb.c                          |    2 
 drivers/usb/core/usb.h                          |    4 
 drivers/usb/storage/libusual.c                  |    7 
 drivers/usb/storage/scsiglue.c                  |   31 ++++
 drivers/usb/storage/transport.c                 |   80 ++++++++++
 drivers/usb/storage/unusual_devs.h              |  178 ++----------------------
 drivers/usb/storage/usb.c                       |    6 
 drivers/usb/storage/usb.h                       |    4 
 fs/fs-writeback.c                               |   92 +++++++-----
 fs/sync.c                                       |    2 
 include/linux/fs.h                              |    1 
 include/linux/usb_usual.h                       |    5 
 include/linux/writeback.h                       |    1 
 kernel/sched_fair.c                             |    2 
 lib/idr.c                                       |   10 -
 mm/filemap.c                                    |   18 --
 mm/page-writeback.c                             |  121 +++++++++++-----
 net/bridge/netfilter/ebtables.c                 |    2 
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c    |    2 
 net/ipv4/tcp.c                                  |    8 -
 net/ipv6/ip6_fib.c                              |   15 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c  |    2 
 net/netfilter/x_tables.c                        |    8 +
 net/sched/cls_u32.c                             |    3 
 net/sched/sch_htb.c                             |    1 
 net/sctp/sm_statefuns.c                         |   14 +
 security/keys/keyctl.c                          |    1 
 sound/pci/hda/patch_analog.c                    |   49 ++++++
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/pci/hda/patch_sigmatel.c                  |   16 ++
 sound/pci/oxygen/virtuoso.c                     |   17 +-
 46 files changed, 585 insertions(+), 330 deletions(-)

Alan Stern (3):
      usb-storage: add last-sector hacks
      usb-storage: set CAPACITY_HEURISTICS flag for bad vendors
      USB: re-enable interface after driver unbinds

Alistair John Strachan (1):
      hwmon: (abituguru3) Fix CONFIG_DMI=n fallback to probe

Andrew Morton (2):
      lib/idr.c: use kmem_cache_zalloc() for the idr_layer cache
      mm: write_cache_pages more terminate quickly

Christian Lamparter (1):
      p54usb: fix traffic stalls / packet drop

Clemens Ladisch (1):
      sound: virtuoso: do not overwrite EEPROM on Xonar D2/D2X

Dave Kleikamp (1):
      powerpc: is_hugepage_only_range() must account for both 4kB and 64kB slices

Dean Nelson (1):
      sgi-xp: eliminate false detection of no heartbeat

Florian Fainelli (1):
      r6040: bump release number to 0.19

Giuseppe Bilotta (1):
      ALSA: hda - Add quirk for another HP dv5

Greg Kroah-Hartman (1):
      Linux 2.6.28.2

Herbert Xu (1):
      ipv6: Fix fib6_dump_table walker leak

Jarek Poplawski (2):
      pkt_sched: sch_htb: Fix deadlock in hrtimers triggered by HTB
      pkt_sched: cls_u32: Fix locking in u32_change()

Joe Chou (2):
      r6040: fix wrong logic in mdio code
      r6040: save and restore MIER correctly in the interrupt routine

Jos-Vicente Gilabert (1):
      drivers/net/irda/irda-usb.c: fix buffer overflow

Lennert Buytenhek (1):
      tcp: don't mask EOF and socket errors on nonblocking splice receive

Luke Yelavich (1):
      ALSA: hda - Add automatic model setting for Samsung Q45

Michiel (1):
      p54usb: Add USB ID for Thomson Speedtouch 121g

Nick Piggin (12):
      mm: write_cache_pages cyclic fix
      mm: write_cache_pages early loop termination
      mm: write_cache_pages writepage error fix
      mm: write_cache_pages integrity fix
      mm: write_cache_pages cleanups
      mm: write_cache_pages optimise page cleaning
      mm: write_cache_pages terminate quickly
      mm: do_sync_mapping_range integrity fix
      mm: direct IO starvation improvement
      fs: remove WB_SYNC_HOLD
      fs: sync_sb_inodes fix
      fs: sys_sync fix

Patrick McHardy (3):
      netfilter: x_tables: fix match/target revision lookup
      netfilter: ebtables: fix inversion in match code
      netfilter: nf_conntrack: fix ICMP/ICMPv6 timeout sysctls on big-endian

Pavel Roskin (1):
      dell_rbu: use scnprintf() instead of less secure sprintf()

Peter Zijlstra (1):
      sched: fix update_min_vruntime

Shaohua Li (1):
      PCI: keep ASPM link state consistent throughout PCIe hierarchy

Stefan Lippers-Hollmann (1):
      rt2x00: add USB ID for the Linksys WUSB200.

Takashi Iwai (3):
      ALSA: hda - Fix HP dv5 mic input
      ALSA: hda - Don't reset HP pinctl in patch_sigmatel.c
      ALSA: hda - make laptop-eapd model back for AD1986A

Tony Luck (1):
      IA64: Turn on CONFIG_HAVE_UNSTABLE_CLOCK

Vegard Nossum (1):
      security: introduce missing kfree

Wei Yongjun (1):
      sctp: Avoid memory overflow while FWD-TSN chunk is received with bad stream ID

