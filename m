Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZJER3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZJER3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZJER3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:29:46 -0400
Received: from kroah.org ([198.145.64.141]:52596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbZJER3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:29:43 -0400
Date: Mon, 5 Oct 2009 10:25:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.30.9
Message-ID: <20091005172531.GC18332@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.9 kernel.  All users of the
2.6.30 kernel series are very strongly encouraged to upgrade.

NOTE:
	This is the last release of the 2.6.30-stable series.  Everyone
	should now move to the 2.6.31 kernel tree.  If there are any
	issues preventing people from doing this, please let me know!

I'll also be replying to this message with a copy of the patch between
2.6.30.8 and 2.6.30.9

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/powerpc/include/asm/pte-common.h     |    2 
 arch/powerpc/mm/pgtable.c                 |   19 +++++-
 arch/x86/include/asm/kvm_host.h           |    1 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   15 ++---
 arch/x86/kernel/kvmclock.c                |    4 -
 arch/x86/kvm/lapic.c                      |    9 +++
 arch/x86/kvm/mmu.c                        |    9 ---
 arch/x86/kvm/vmx.c                        |   11 +--
 arch/x86/kvm/x86.c                        |   31 ++++++++--
 drivers/acpi/pci_slot.c                   |    4 -
 drivers/ata/ahci.c                        |    4 -
 drivers/net/wireless/p54/p54usb.c         |    1 
 drivers/pcmcia/at91_cf.c                  |    2 
 drivers/pcmcia/au1000_generic.c           |    2 
 drivers/pcmcia/bfin_cf_pcmcia.c           |    2 
 drivers/pcmcia/cs.c                       |    2 
 drivers/pcmcia/i82092.c                   |    2 
 drivers/pcmcia/i82365.c                   |    2 
 drivers/pcmcia/m32r_cfc.c                 |    2 
 drivers/pcmcia/m32r_pcc.c                 |    2 
 drivers/pcmcia/m8xx_pcmcia.c              |    2 
 drivers/pcmcia/omap_cf.c                  |    2 
 drivers/pcmcia/pd6729.c                   |    2 
 drivers/pcmcia/pxa2xx_base.c              |    2 
 drivers/pcmcia/sa1100_generic.c           |    2 
 drivers/pcmcia/sa1111_generic.c           |    2 
 drivers/pcmcia/tcic.c                     |    2 
 drivers/pcmcia/vrc4171_card.c             |    2 
 drivers/pcmcia/yenta_socket.c             |   88 ++++++++++++++++--------------
 drivers/platform/x86/thinkpad_acpi.c      |   74 ++++++++++++++++++++-----
 fs/cifs/cifsglob.h                        |    4 -
 fs/inode.c                                |   14 ++--
 fs/nilfs2/btnode.c                        |    1 
 fs/proc/kcore.c                           |    8 ++
 fs/proc/uptime.c                          |    7 ++
 include/linux/kvm_para.h                  |    1 
 include/pcmcia/ss.h                       |    2 
 mm/hugetlb.c                              |    2 
 mm/memory.c                               |    3 -
 mm/mmap.c                                 |    4 -
 net/ax25/af_ax25.c                        |    2 
 net/bridge/br_netfilter.c                 |    2 
 net/bridge/netfilter/ebt_ulog.c           |    2 
 net/ipv4/netfilter/nf_nat_core.c          |    2 
 net/packet/af_packet.c                    |    4 -
 scripts/kallsyms.c                        |    2 
 47 files changed, 237 insertions(+), 129 deletions(-)

Alex Chiang (1):
      ACPI: pci_slot.ko wants a 64-bit _SUN

Arjan van de Ven (2):
      net ax25: Fix signed comparison in the sockopt handler
      net: Make the copy length in af_packet sockopt handler unsigned

Avi Kivity (1):
      KVM: VMX: Check cpl before emulating debug register access

Christian Lamparter (1):
      p54usb: add Zcomax XG-705A usbid

Chuck Ebbert (1):
      Re-enable Lanman security

Glauber Costa (1):
      KVM guest: fix bogus wallclock physical address calculation

Gleb Natapov (1):
      KVM: VMX: Fix cr8 exiting control clobbering by EPT

Greg Kroah-Hartman (1):
      Linux 2.6.30.9

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: fix incorrect use of TPACPI_BRGHT_MODE_ECNVRAM

Hugh Dickins (1):
      mm: fix anonymous dirtying

Izik Eidus (1):
      KVM: MMU: make __kvm_mmu_free_some_pages handle empty list

Jan Kara (1):
      fs: make sure data stored into inode is properly seen before unlocking new inode

Jan Kiszka (1):
      KVM: x86: Disallow hypercalls for guest callers in rings > 0

KAMEZAWA Hiroyuki (1):
      /proc/kcore: work around a BUG()

Kurt Roeckx (1):
      Fix NULL ptr regression in powernow-k8

Lee Schermerhorn (2):
      hugetlb: restore interleaving of bootmem huge pages (2.6.31)
      mmap: avoid unnecessary anon_vma lock acquisition in vma_adjust()

Marcelo Tosatti (4):
      KVM: MMU: fix missing locking in alloc_mmu_pages
      KVM: MMU: fix bogus alloc_mmu_pages assignment
      KVM: limit lapic periodic timer frequency
      Revert "KVM: x86: check for cr3 validity in ioctl_set_sregs"

Mark McLoughlin (1):
      KVM: fix cpuid E2BIG handling for extended request types

Michael Abbott (1):
      Fix idle time field in /proc/uptime

Patrick McHardy (3):
      netfilter: bridge: refcount fix
      netfilter: ebt_ulog: fix checkentry return value
      netfilter: nf_nat: fix inverted logic for persistent NAT mappings

Paul Mundt (1):
      kallsyms: fix segfault in prefix_underscores_count()

Rafael J. Wysocki (2):
      PM / PCMCIA: Drop second argument of pcmcia_socket_dev_suspend()
      PM / yenta: Fix cardbus suspend/resume regression

Rex Feany (1):
      powerpc/8xx: Fix regression introduced by cache coherency rewrite

Ryusuke Konishi (1):
      nilfs2: fix missing zero-fill initialization of btree node cache

Tejun Heo (1):
      ahci: restore pci_intx() handling

Weirich, Bernhard (1):
      powerpc: Fix incorrect setting of __HAVE_ARCH_PTE_SPECIAL

