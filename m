Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbXDPAFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbXDPAFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 20:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXDPAFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 20:05:34 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbXDPAFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 20:05:33 -0400
Date: Sun, 15 Apr 2007 17:05:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21-rc7
Message-ID: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since we're still waiting for resolution for some regressions that people 
weren't able to work on last week, there's a new -rc kernel out there. 
Hopefully we'll get them all and I can do 2.6.21-final next weekend or 
so..

The changes from 2.6.21-rc6 are pretty small, and I'm including both the 
shortlog and the diffstat here since they both fit comfortably under the 
kernel mailing list size limits even when combined.

I really don't know what to say that would be more readable and 
informative than the shortlog. The HPET failsafe thing will hopefully 
resolve a few more bootup/resume issues.

Mostly driver fixes, some networking and NFS. Go wild!

		Linus

---
Adam Kropelin (1):
      HID: Do not discard truncated input reports

Alan Stern (1):
      EHCI: fix remote wakeup regression in 2.6.21-rc

Andrew Morton (3):
      x86_64 early quirks: fix early_qrk[] section tag
      i386: irqbalance_disable() section fix
      [PKTGEN]: Add try_to_freeze()

Bjorn Helgaas (1):
      cciss: unregister from SCSI before tearing down device resources

Brice Goglin (3):
      myri10ge: fix management of the firmware 4KB boundary crossing restriction
      myri10ge: more Intel chipsets providing aligned PCIe completions
      myri10ge: update driver version to 1.3.0-1.233

Cliff Brake (1):
      Input: ucb1400 - set up driver's name to show in sysfs

Daniel Drake (2):
      zd1211rw: Reject AL2230S devices
      zd1211rw: Fix E2P_PHY_REG patching

Danny Kukawka (1):
      ide: add "optical" to sysfs "media" attribute

David Brownell (2):
      omap_cf: oops-on-suspend fix
      doc: gpio.txt describes open-drain emulation

David Howells (1):
      FRV: Update the FRV arch MAINTAINER record to get a hit on "grep -i frv"

David S. Miller (7):
      [IPV6]: Revert recent change to rt6_check_dev().
      [TCP]: slow_start_after_idle should influence cwnd validation too
      [SPARC64]: Fix SBUS IOMMU allocation code.
      [SUNRPC]: Make sure on-stack cmsg buffer is properly aligned.
      [SPARC64]: Fix arg passing to compat_sys_ipc().
      [NETFILTER] arp_tables: Fix unaligned accesses.
      [SCSI] QLOGICPTI: Do not unmap DMA unless we actually mapped something.

Divy Le Ray (3):
      cxgb3 - avoid deadlock with mac watchdog
      cxgb3 - MAC watchdog update
      cxgb3 - missing CPL hanler and register setting.

Dmitry Torokhov (1):
      PM: use kobject_name() to access kobject names

Domen Puncer (1):
      [POWERPC] mpc52xx_pic: fix main interrupt masking

Emil Larsson (1):
      USB: Nikon D80 unusual device patch

Erez Zilber (1):
      IB/iser: Don't defer connection failure notification to workqueue

Herbert Xu (1):
      [SC92031]: Fix priv->lock context

Ingo Molnar (2):
      high-res timers: resume fix
      sched: get rid of p->children use in show_task()

Ishimatsu Yasuaki (1):
      [IA64] Fix wrong assumption about irq and vector in msi_ia64.c

James Bottomley (1):
      [SCSI] 3w-xxxx: fix oops caused by incorrect REQUEST_SENSE handling

Jaroslav Kysela (1):
      [NETFILTER]: ipt_CLUSTERIP: fix oops in checkentry function

Jeff Mahoney (1):
      autofs4: fix race in unhashed dentry code

Jerome Borsboom (1):
      [VLAN]: Allow VLAN interface on top of bridge interface

Joy Latten (1):
      [IPSEC] XFRM_USER: kernel panic when large security contexts in ACQUIRE

Larry Finger (2):
      bcm43xx: Fix 802.11b/g scan limits to match regulatory reqs
      bcm43xx: Fix PPC machine checks and match loopback gain specs

Linus Torvalds (2):
      sched.c: Remove unused variable 'relative'
      Linux 2.6.21-rc7

Michael Chan (1):
      [TG3]: Fix crash during tg3_init_one().

Michael S. Tsirkin (1):
      IPoIB/cm: Fix DMA direction typo

Mike Habeck (1):
      [IA64] SGI Altix : fix pcibr_dmamap_ate32() bug

Neil Brown (1):
      md: fix calculation for size of filemap_attr array in md/bitmap

Olaf Kirch (1):
      DVB: dvb-usb-remote - fix oops when changing keymap

Patrick McHardy (6):
      [XFRM]: beet: fix IP option encapsulation
      [XFRM]: beet: use IPOPT_NOP for option padding
      [XFRM]: beet: fix beet mode decapsulation
      [XFRM]: beet: fix IP option decapsulation
      [NET_SCHED]: cls_tcindex: fix compatibility breakage
      [NETFILTER]: ipt_ULOG: use put_unaligned

Randy Dunlap (1):
      fix kernel oops with badly formatted module option

Ravikiran G Thirumalai (1):
      failsafe mechanism to HPET clock calibration

Robert Reif (1):
      [SPARC]: Fix section mismatch warnings in pci.c and pcic.c

Roland McGrath (1):
      [SPARC]: avoid CHILD_MAX and OPEN_MAX constants

Russ Anderson (1):
      [IA64] BTE error timer fix

Stefan Richter (1):
      ieee1394: change deprecation status of dv1394

Stephen Hemminger (5):
      skge: turn carrier off when down
      sky2: turn carrier off when down
      sky2: turn on clocks when doing resume
      sky2: phy workarounds for Yukon EC-U A1
      skge: fix wake on lan

Steve Wise (1):
      RDMA/cxgb3: Add set_tcb_rpl_handler

Stuart Hayes (1):
      ide: ugly messages trying to open CD drive with no media present

Suleiman Souhlal (1):
      ide: correctly prevent IDE timer expiry function to run if request was already handled

Tejun Heo (1):
      irq-devres: fix failure path of devm_request_irq()

Timo Savola (1):
      fuse: validate rootmode mount option

Tom "spot" Callaway (1):
      [SPARC64]: Fix inline directive in pci_iommu.c

Trond Myklebust (4):
      NFS: Fix an Oops in nfs_setattr()
      NFS: Fix two bugs in the O_DIRECT write code
      NFS: Ensure PG_writeback is cleared when writeback fails
      NFS: Fix a list corruption problem

Venki Pallipadi (1):
      [IA64] Fix CPU freq displayed in /proc/cpuinfo

Vitaly Bordug (3):
      [PPC] MPC8272 ADS compile fixed, defconfig refreshed.
      [PPC] Fix compilation and linking errors of mpc885ads build.
      [PPC] Fix compilation and linking errors of mpc86xads build.

Vladimir Saveliev (1):
      reiserfs: fix key decrementing

Wang Zhenyu (2):
      [AGPGART] intel_agp: PCI id update for Intel 965GM
      [AGPGART] intel_agp: fix G965 GTT size detect

Wu, Bryan (1):
      nommu: fix bug ip_conntrack does not work on nommu

YOSHIFUJI Hideaki (1):
      [IPV6] SNMP: Fix {In,Out}NoRoutes statistics.

Zachary Amsden (2):
      Proper fix for highmem kmap_atomic functions for VMI for 2.6.21
      Fix VMI relocation processing logic error

---
 Documentation/ABI/obsolete/dv1394            |    9 +
 Documentation/feature-removal-schedule.txt   |   11 -
 Documentation/gpio.txt                       |   31 ++-
 MAINTAINERS                                  |    2 +-
 Makefile                                     |    2 +-
 arch/i386/kernel/io_apic.c                   |    2 +-
 arch/i386/kernel/vmi.c                       |   32 ++-
 arch/i386/mm/highmem.c                       |    2 +
 arch/ia64/kernel/msi_ia64.c                  |    4 +-
 arch/ia64/kernel/setup.c                     |    2 +-
 arch/ia64/sn/kernel/bte_error.c              |    6 +-
 arch/ia64/sn/pci/pcibr/pcibr_dma.c           |    8 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c    |    4 +-
 arch/ppc/8xx_io/commproc.c                   |   26 ++
 arch/ppc/configs/ads8272_defconfig           |  592 ++++++++++++++++++++------
 arch/ppc/platforms/mpc8272ads_setup.c        |   17 +-
 arch/ppc/platforms/mpc866ads_setup.c         |   17 +-
 arch/ppc/platforms/mpc885ads_setup.c         |   20 +-
 arch/sparc/kernel/pcic.c                     |    4 +-
 arch/sparc/kernel/sys_sunos.c                |    4 +-
 arch/sparc64/kernel/pci.c                    |    4 +-
 arch/sparc64/kernel/pci_iommu.c              |    2 +-
 arch/sparc64/kernel/sbus.c                   |  560 ++++++++++--------------
 arch/sparc64/kernel/sys32.S                  |    1 -
 arch/sparc64/kernel/sys_sunos32.c            |    4 +-
 arch/sparc64/kernel/systbls.S                |    2 +-
 arch/sparc64/solaris/misc.c                  |    6 +-
 arch/x86_64/kernel/early-quirks.c            |    2 +-
 arch/x86_64/kernel/hpet.c                    |    9 +-
 drivers/base/power/main.c                    |    6 +-
 drivers/block/cciss.c                        |   35 +-
 drivers/char/agp/intel-agp.c                 |   17 +-
 drivers/hid/hid-core.c                       |    2 +-
 drivers/ide/ide-cd.c                         |    9 +
 drivers/ide/ide-io.c                         |    6 +-
 drivers/ide/ide-iops.c                       |    2 +
 drivers/ide/ide.c                            |    2 +
 drivers/ieee1394/Kconfig                     |    6 +-
 drivers/ieee1394/dv1394.c                    |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |   12 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |    2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    1 -
 drivers/infiniband/ulp/iser/iser_verbs.c     |   40 +-
 drivers/input/touchscreen/ucb1400_ts.c       |    1 +
 drivers/md/bitmap.c                          |    4 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c   |    2 -
 drivers/net/cxgb3/common.h                   |    7 +-
 drivers/net/cxgb3/cxgb3_main.c               |   16 +-
 drivers/net/cxgb3/cxgb3_offload.c            |   14 +-
 drivers/net/cxgb3/regs.h                     |    6 +
 drivers/net/cxgb3/xgmac.c                    |  107 ++++--
 drivers/net/myri10ge/myri10ge.c              |   37 ++-
 drivers/net/sc92031.c                        |   20 +-
 drivers/net/skge.c                           |   93 +++--
 drivers/net/sky2.c                           |   12 +-
 drivers/net/tg3.c                            |    6 +-
 drivers/net/wireless/bcm43xx/bcm43xx_main.c  |   20 +-
 drivers/net/wireless/bcm43xx/bcm43xx_phy.c   |   57 ++--
 drivers/net/wireless/zd1211rw/zd_chip.c      |   12 +-
 drivers/net/wireless/zd1211rw/zd_chip.h      |    4 +-
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c |    6 +
 drivers/pcmcia/omap_cf.c                     |   41 ++-
 drivers/scsi/3w-xxxx.c                       |   11 +-
 drivers/scsi/qlogicpti.c                     |    2 +-
 drivers/usb/host/ehci-hcd.c                  |    1 +
 drivers/usb/storage/unusual_devs.h           |    7 +
 fs/autofs4/root.c                            |    6 +-
 fs/fuse/dir.c                                |    5 +-
 fs/fuse/fuse_i.h                             |    5 +
 fs/fuse/inode.c                              |    2 +
 fs/nfs/dir.c                                 |    3 +-
 fs/nfs/direct.c                              |   11 +-
 fs/nfs/inode.c                               |    6 +-
 fs/nfs/write.c                               |   22 +-
 fs/reiserfs/item_ops.c                       |    2 +-
 include/asm-generic/pgtable.h                |    2 +
 include/asm-i386/paravirt.h                  |    3 +
 include/asm-ia64/sn/pcibr_provider.h         |    5 +-
 include/linux/hrtimer.h                      |    3 +
 include/linux/ide.h                          |    2 +
 include/linux/nfs_page.h                     |    1 -
 kernel/hrtimer.c                             |   12 +
 kernel/irq/devres.c                          |    2 +-
 kernel/params.c                              |    4 +
 kernel/sched.c                               |   36 +--
 kernel/timer.c                               |    2 +-
 mm/nommu.c                                   |    1 +
 net/8021q/vlan_dev.c                         |    3 +
 net/core/pktgen.c                            |    3 +
 net/ipv4/netfilter/arp_tables.c              |   10 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c           |    2 -
 net/ipv4/netfilter/ipt_ULOG.c                |    7 +-
 net/ipv4/tcp_output.c                        |    3 +-
 net/ipv4/xfrm4_mode_beet.c                   |   26 +-
 net/ipv6/route.c                             |   48 +-
 net/sched/cls_tcindex.c                      |    4 +-
 net/sunrpc/svcsock.c                         |   16 +-
 net/xfrm/xfrm_user.c                         |    7 +-
 98 files changed, 1415 insertions(+), 864 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/dv1394
