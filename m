Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbZIIEMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbZIIEMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZIIEMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:12:16 -0400
Received: from kroah.org ([198.145.64.141]:41382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZIIEML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:12:11 -0400
Date: Tue, 8 Sep 2009 21:09:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.30.6
Message-ID: <20090909040954.GC9657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.6 kernel.  All users of the
2.6.30 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.30.5 and 2.6.30.6

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------


 Makefile                                  |    2 
 arch/ia64/kernel/pci-dma.c                |    5 -
 arch/powerpc/platforms/ps3/time.c         |    4 
 arch/x86/include/asm/kvm_host.h           |    3 
 arch/x86/include/asm/kvm_x86_emulate.h    |    6 +
 arch/x86/kernel/apic/ipi.c                |    3 
 arch/x86/kernel/cpu/amd.c                 |    2 
 arch/x86/kvm/mmu.c                        |   85 ++++++++++++-----
 arch/x86/kvm/svm.c                        |   31 +++++-
 arch/x86/kvm/vmx.c                        |   42 ++++++--
 arch/x86/kvm/x86.c                        |   70 +++++++++++++-
 arch/x86/kvm/x86_emulate.c                |   20 ++++
 arch/x86/mm/tlb.c                         |   21 ++--
 drivers/acpi/processor_thermal.c          |    6 -
 drivers/acpi/processor_throttling.c       |   26 ++---
 drivers/ata/libata-core.c                 |    3 
 drivers/media/video/gspca/ov534.c         |    4 
 drivers/net/ehea/ehea.h                   |    2 
 drivers/net/ehea/ehea_main.c              |    3 
 drivers/net/wireless/ar9170/main.c        |    5 -
 drivers/net/wireless/iwlwifi/iwl-rfkill.c |   26 +++--
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   12 ++
 drivers/net/wireless/rt2x00/rt2x00.h      |    6 -
 drivers/platform/x86/wmi.c                |    8 -
 drivers/scsi/mpt2sas/mpt2sas_base.c       |   98 ++++++++++++++------
 drivers/scsi/mpt2sas/mpt2sas_base.h       |    2 
 drivers/scsi/mpt2sas/mpt2sas_config.c     |   91 +++++--------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |  124 ++++++++++++++++++--------
 drivers/usb/core/hcd.h                    |    4 
 drivers/usb/core/hub.c                    |   40 +++++---
 drivers/usb/core/hub.h                    |    6 -
 drivers/usb/host/ehci-au1xxx.c            |    2 
 drivers/usb/host/ehci-fsl.c               |    2 
 drivers/usb/host/ehci-hcd.c               |    5 -
 drivers/usb/host/ehci-ixp4xx.c            |    2 
 drivers/usb/host/ehci-orion.c             |    2 
 drivers/usb/host/ehci-pci.c               |    2 
 drivers/usb/host/ehci-ppc-of.c            |    2 
 drivers/usb/host/ehci-ps3.c               |    2 
 drivers/usb/host/ehci-q.c                 |   97 +++++++++++++++-----
 drivers/usb/host/ehci.h                   |    2 
 drivers/video/xen-fbfront.c               |    8 -
 fs/buffer.c                               |    7 +
 fs/exec.c                                 |    4 
 fs/hugetlbfs/inode.c                      |   20 ++--
 fs/inode.c                                |   40 +++++---
 fs/ocfs2/aops.c                           |   66 +++++++++----
 fs/select.c                               |    1 
 fs/xfs/xfs_iget.c                         |  142 +++++++++++++++---------------
 fs/xfs/xfs_inode.h                        |   17 ---
 fs/xfs/xfs_log.c                          |    2 
 include/acpi/processor.h                  |    5 -
 include/linux/bitmap.h                    |   18 +--
 include/linux/cpumask.h                   |   20 ++--
 include/linux/fs.h                        |    5 -
 include/linux/hugetlb.h                   |    6 -
 include/linux/kvm_host.h                  |    1 
 init/main.c                               |    7 -
 ipc/shm.c                                 |    8 +
 kernel/fork.c                             |   20 +---
 kernel/kthread.c                          |    2 
 kernel/signal.c                           |   15 +--
 lib/bitmap.c                              |   12 +-
 mm/page_alloc.c                           |    4 
 net/appletalk/ddp.c                       |    1 
 net/can/raw.c                             |    1 
 net/econet/af_econet.c                    |    1 
 net/ipv4/ip_output.c                      |    2 
 net/ipv6/af_inet6.c                       |    4 
 net/irda/af_irda.c                        |    1 
 net/llc/af_llc.c                          |    1 
 net/mac80211/agg-tx.c                     |    8 +
 net/netrom/af_netrom.c                    |    1 
 net/rose/af_rose.c                        |    1 
 net/sunrpc/clnt.c                         |    1 
 security/integrity/ima/ima_crypto.c       |    6 -
 sound/core/pcm_lib.c                      |   39 +-------
 sound/pci/hda/patch_realtek.c             |   34 ++++---
 virt/kvm/irq_comm.c                       |    4 
 virt/kvm/kvm_main.c                       |    4 
 80 files changed, 896 insertions(+), 521 deletions(-)

Alan Stern (3):
      USB: fix the clear_tt_buffer interface
      USB: EHCI: use the new clear_tt_buffer interface
      USB: EHCI: fix two new bugs related to Clear-TT-Buffer

Amit Shah (2):
      KVM: x86: Ignore reads to EVNTSEL MSRs
      KVM: Ignore reads to K7 EVNTSEL MSRs

Avi Kivity (2):
      KVM: MMU: Use different shadows when EFER.NXE changes
      KVM: Fix cpuid feature misreporting

Bo Liu (1):
      mm: build_zonelists(): move clear node_load[] to __build_all_zonelists()

Bruno Prémont (1):
      ipv6: Fix commit 63d9950b08184e6531adceb65f64b429909cc101 (ipv6: Make v4-mapped bindings consistent with IPv4)

Christoph Hellwig (4):
      vfs: fix inode_init_always calling convention
      vfs: add __destroy_inode
      xfs: fix freeing of inodes not yet added to the inode cache
      xfs: fix spin_is_locked assert on uni-processor builds

Clemens Ladisch (1):
      sound: pcm_lib: fix unsorted list constraint handling

Costantino Leandro (1):
      wmi: fix kernel panic when stack protection enabled.

Dan Carpenter (1):
      ar9170: fix read & write outside array bounds

Eric Dumazet (6):
      can: Fix raw_getname() leak
      irda: Fix irda_getname() leak
      appletalk: fix atalk_getname() leak
      netrom: Fix nr_getname() leak
      econet: Fix econet_getname() leak
      rose: Fix rose_getname() leak

Fenghua Yu (1):
      Bug Fix arch/ia64/kernel/pci-dma.c: fix recursive dma_supported() call in iommu_dma_supported()

Frans Pop (1):
      ACPI processor: force throttling state when BIOS returns incorrect value

Geert Uytterhoeven (1):
      powerpc/ps3: Add missing check for PS3 to rtc-ps3 platform device registration

Glauber Costa (2):
      KVM: Introduce {set/get}_interrupt_shadow()
      KVM: Deal with interrupt shadow state for emulated instructions

Gleb Natapov (1):
      KVM: MMU: do not free active mmu pages in free_mmu_pages()

Greg Kroah-Hartman (1):
      Linux 2.6.30.6

Guillaume Knispel (1):
      poll/select: initialize triggered field of struct poll_wqueues

Hannes Hering (1):
      ehea: Fix napi list corruption on ifconfig down

Hugh Dickins (1):
      mm: fix hugetlb bug due to user_shm_unlock call

Ingo Molnar (1):
      tracing: Fix too large stack usage in do_one_initcall()

Jan Kiszka (1):
      KVM: Fix KVM_GET_MSR_INDEX_LIST

Jean-Francois Moine (1):
      gspca - ov534: Fix ov772x

Jeremy Fitzhardinge (1):
      x86, amd: Don't probe for extended APIC ID if APICs are disabled

Jiri Slaby (1):
      NET: llc, zero sockaddr_llc struct

Julien TINNES (1):
      ipv4: make ip_append_data() handle NULL routing table

Kashyap, Desai (8):
      SCSI: mpt2sas: Introduced check for enclosure_handle to avoid crash
      SCSI: mpt2sas: Expander fix oops saying "Already part of another port"
      SCSI: mpt2sas: Raid 10 Value is showing as Raid 1E in /va/log/messages
      SCSI: mpt2sas: Excessive log info causes sas iounit page time out
      SCSI: mpt2sas: fix infinite loop inside config request
      SCSI: mpt2sas: fix crash due to Watchdog is active while OS in standby mode
      SCSI: mpt2sas: fix oops because drv data points to NULL on resume from hibernate
      mpt2sas: fix config request and diag reset deadlock

Linus Torvalds (5):
      Make bitmask 'and' operators return a result code
      x86: don't send an IPI to the empty set of CPU's
      x86: don't call '->send_IPI_mask()' with an empty mask
      Re-introduce page mapping check in mark_buffer_dirty()
      do_sigaltstack: avoid copying 'stack_t' as a structure to user space

Luis R. Rodriguez (1):
      mac80211: fix panic when splicing unprepared TIDs

Marcelo Tosatti (7):
      KVM: take mmu_lock when updating a deleted slot
      KVM: x86: check for cr3 validity in mmu_alloc_roots
      KVM: MMU: protect kvm_mmu_change_mmu_pages with mmu_lock
      KVM: x86: verify MTRR/PAT validity
      KVM: SVM: force new asid on vcpu migration
      KVM: MMU: handle n_free_mmu_pages > n_alloc_mmu_pages in kvm_mmu_change_mmu_pages
      KVM: MMU: limit rmap chain length

Michael S. Tsirkin (1):
      KVM: fix ack not being delivered when msi present

Michal Schmidt (1):
      xenfb: connect to backend before registering fb

Mimi Zohar (2):
      ima: hashing large files bug fix
      kernel_read: redefine offset type

Oleg Nesterov (2):
      clone(): fix race between copy_process() and de_thread()
      kthreads: fix kthread_create() vs kthread_stop() race

Pavel Roskin (1):
      rt2x00: fix memory corruption in rf cache, add a sanity check

Reinette Chatre (1):
      iwlagn: do not send key clear commands when rfkill enabled

Stanislaw Gruszka (1):
      iwl3945: fix rfkill switch

Sunil Mushran (2):
      ocfs2: Initialize the cluster we're writing to in a non-sparse extend
      ocfs2: ocfs2_write_begin_nolock() should handle len=0

Takashi Iwai (1):
      ALSA: hda - Fix MacBookPro 3,1/4,1 quirk with ALC889A

Tejun Heo (1):
      libata: OCZ Vertex can't do HPA

Trond Myklebust (1):
      SUNRPC: Fix rpc_task_force_reencode

