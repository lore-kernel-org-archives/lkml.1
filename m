Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZBQSCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZBQSCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZBQSCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:02:14 -0500
Received: from kroah.org ([198.145.64.141]:35900 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751535AbZBQSCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:02:06 -0500
Date: Tue, 17 Feb 2009 10:00:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.18
Message-ID: <20090217180005.GC14982@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the announcement of the 2.6.27.18 kernel release.  If you are
using the 2.6.27 kernel series, you want to upgrade to this one.

I'll also be replying to this message with a copy of the patch between
2.6.27.17 and 2.6.27.18

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/powerpc/kernel/signal_32.c                |   36 ++++-------
 arch/powerpc/kernel/signal_64.c                |   33 ++++------
 arch/powerpc/mm/fsl_booke_mmu.c                |    4 -
 arch/powerpc/mm/pgtable_32.c                   |    4 -
 arch/sparc64/Kconfig                           |    1 
 arch/sparc64/kernel/sys_sparc.c                |   48 +++++++--------
 arch/sparc64/kernel/syscalls.S                 |    2 
 arch/sparc64/kernel/systbls.S                  |   16 ++---
 arch/sparc64/kernel/systbls.h                  |    3 
 arch/x86/kernel/vmi_32.c                       |   11 +++
 arch/x86/pci/fixup.c                           |   25 ++++----
 drivers/ata/libata-eh.c                        |    5 -
 drivers/block/nbd.c                            |    9 ++
 drivers/hid/usbhid/hid-quirks.c                |   16 +----
 drivers/net/skfp/skfddi.c                      |    4 -
 drivers/net/sky2.c                             |    6 -
 drivers/net/sungem.c                           |    8 +-
 drivers/net/tun.c                              |   10 ++-
 drivers/net/virtio_net.c                       |    3 
 drivers/net/wireless/iwlwifi/iwl-scan.c        |    2 
 drivers/net/wireless/zd1211rw/zd_rf.c          |    1 
 drivers/net/wireless/zd1211rw/zd_usb.c         |    1 
 drivers/parport/parport_serial.c               |    5 +
 drivers/w1/slaves/w1_therm.c                   |    2 
 fs/compat_ioctl.c                              |    7 ++
 fs/lockd/svclock.c                             |    6 +
 include/linux/ata.h                            |   15 +++-
 include/linux/syscalls.h                       |   28 ++++-----
 include/net/sctp/checksum.h                    |    2 
 mm/page-writeback.c                            |   18 ++++-
 net/bluetooth/hidp/core.c                      |    4 +
 net/core/skbuff.c                              |   76 ++++++++++++-------------
 net/core/sock.c                                |    2 
 net/ipv4/ipconfig.c                            |    6 -
 net/ipv4/tcp.c                                 |   12 +++
 net/ipv4/udp.c                                 |    7 +-
 net/ipv6/ip6_flowlabel.c                       |    8 +-
 net/ipv6/ip6_output.c                          |   67 +++++++++++++++++-----
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    4 -
 net/mac80211/debugfs_sta.c                     |    2 
 net/netfilter/xt_sctp.c                        |    2 
 net/packet/af_packet.c                         |   17 +++--
 net/sctp/output.c                              |    7 +-
 net/sctp/outqueue.c                            |    3 
 scripts/kernel-doc                             |   39 ++++++++++++
 sound/drivers/mtpav.c                          |    3 
 47 files changed, 368 insertions(+), 224 deletions(-)

Alex Williamson (2):
      tun: Fix unicast filter overflow
      virtio_net: Fix MAX_PACKET_LEN to support 802.1Q VLANs

Alexey Dobriyan (1):
      sky2: fix hard hang with netconsoling and iface going up

Alok Kataria (1):
      x86, vmi: put a missing paravirt_release_pmd in pgd_dtor

Andreas Herrmann (1):
      x86: fixup config space size of CPU functions for AMD family 11h

Artem Bityutskiy (1):
      write-back: fix nr_to_write counter

Benjamin Zores (1):
      ipv4: fix infinite retry loop in IP-Config

Christian Borntraeger (1):
      sparc: Enable syscall wrappers for 64-bit (CVE-2009-0029)

Clément Lecigne (1):
      net: 4 bytes kernel memory disclosure in SO_BSDCOMPAT gsopt try #2

David S. Miller (3):
      ipv6: Disallow rediculious flowlabel option sizes.
      tun: Add some missing TUN compat ioctl translations.
      sparc64: Annotate sparc64 specific syscalls with SYSCALL_DEFINEx()

Dimitris Michailidis (1):
      tcp: Fix length tcp_splice_data_recv passes to skb_splice_bits.

Eric Dumazet (1):
      udp: increments sk_drops in __udp_queue_rcv_skb()

Eric Leblond (1):
      netfilter: fix tuple inversion for Node information request

Federico Cuello (1):
      writeback: fix break condition

Greg Kroah-Hartman (1):
      Linux 2.6.27.18

Heiko Carstens (1):
      syscall define: fix uml compile bug

Herbert Xu (3):
      ipv6: Copy cork options in ip6_append_data
      net: Fix frag_list handling in skb_seq_read
      packet: Avoid lock_sock in mmap handler

Hin-Tak Leung (2):
      zd1211rw: adding 0ace:0xa211 as a ZD1211 device
      zd1211rw: treat MAXIM_NEW_RF(0x08) as UW2453_RF(0x09) for TP-Link WN322/422G

Ian Dall (1):
      w1: w1 temp calculation overflow fix

Ilkka Virta (1):
      sungem: Soft lockup in sungem on Netra AC200 when switching interface up

J. Bruce Fields (1):
      lockd: fix regression in lockd's handling of blocked locks

Jarek Poplawski (1):
      net: Fix data corruption when splicing from sockets.

Jesper Dangaard Brouer (1):
      udp: Fix UDP short packet false positive

Jianjun Kong (1):
      mac80211: fix a buffer overrun in station debug code

Jiri Kosina (1):
      HID: adjust report descriptor fixup for MS 1028 receiver

Jiri Slaby (1):
      parport: parport_serial, don't bind netmos ibm 0299

Kumar Gala (1):
      powerpc/fsl-booke: Fix mapping functions to use phys_addr_t

Michael Neuling (1):
      powerpc: Fix swapcontext system for VSX + old ucontext size

Nick Piggin (1):
      Fix page writeback thinko, causing Berkeley DB slowdown

Paul Clements (1):
      nbd: fix I/O hang on disconnected nbds

Qu Haoran (1):
      netfilter: xt_sctp: sctp chunk mapping doesn't work

Randy Dunlap (1):
      kernel-doc: fix syscall wrapper processing

Roel Kluin (1):
      drivers/net/skfp: if !capable(CAP_NET_ADMIN): inverted logic

Sebastiano Di Paola (1):
      net: packet socket packet_lookup_frame fix

Sergei Shtylyov (1):
      ide/libata: fix ata_id_is_cfa() (take 4)

Shyam Iyer (1):
      net: Fix OOPS in skb_seq_read().

Takashi Iwai (1):
      ALSA: mtpav - Fix initial value for input hwport

Tejun Heo (1):
      libata: fix EH device failure handling

Tomas Winkler (1):
      iwlwifi: scan correct setting of valid rx_chains

Torsten Rausche (1):
      bluetooth hid: enable quirk handling for Apple Wireless Keyboards in 2.6.27

Vlad Yasevich (3):
      sctp: Fix crc32c calculations on big-endian arhes.
      sctp: Correctly start rtx timer on new packet transmissions.
      sctp: Properly timestamp outgoing data chunks for rtx purposes

Willy Tarreau (1):
      tcp: splice as many packets as possible at once

