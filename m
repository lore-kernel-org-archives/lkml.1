Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957Ab0ARSuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0ARSuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889Ab0ARSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:50:14 -0500
Received: from kroah.org ([198.145.64.141]:46248 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab0ARSuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:50:08 -0500
Date: Mon, 18 Jan 2010 10:48:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.4
Message-ID: <20100118184856.GE25918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.4 kernel.  All users of the
2.6.32 kernel series are very strongly encouraged to upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/alpha/kernel/osf_sys.c               |   19 --
 arch/arm/include/asm/mman.h               |    3 
 arch/arm/kernel/calls.S                   |    2 
 arch/arm/kernel/entry-common.S            |    4 
 arch/arm/kernel/sys_arm.c                 |   55 ------
 arch/arm/mm/mmap.c                        |    3 
 arch/avr32/include/asm/syscalls.h         |    4 
 arch/avr32/kernel/sys_avr32.c             |   31 ---
 arch/avr32/kernel/syscall-stubs.S         |    2 
 arch/blackfin/kernel/sys_bfin.c           |   33 ----
 arch/blackfin/mach-common/entry.S         |    2 
 arch/cris/kernel/sys_cris.c               |   30 ---
 arch/frv/kernel/sys_frv.c                 |   66 --------
 arch/h8300/kernel/sys_h8300.c             |   83 ----------
 arch/h8300/kernel/syscalls.S              |    2 
 arch/ia64/ia32/sys_ia32.c                 |    3 
 arch/ia64/kernel/sys_ia64.c               |   83 ----------
 arch/m32r/kernel/sys_m32r.c               |   24 --
 arch/m32r/kernel/syscall_table.S          |    2 
 arch/m68k/kernel/sys_m68k.c               |   83 ----------
 arch/m68knommu/kernel/sys_m68k.c          |   38 ----
 arch/m68knommu/kernel/syscalltable.S      |    2 
 arch/microblaze/kernel/sys_microblaze.c   |   38 ----
 arch/microblaze/kernel/syscall_table.S    |    2 
 arch/mips/kernel/linux32.c                |   19 --
 arch/mips/kernel/syscall.c                |   32 ---
 arch/mn10300/include/asm/mman.h           |    5 
 arch/mn10300/kernel/entry.S               |    2 
 arch/mn10300/kernel/sys_mn10300.c         |   36 ----
 arch/parisc/kernel/sys_parisc.c           |   30 ---
 arch/powerpc/include/asm/module.h         |    5 
 arch/powerpc/kernel/syscalls.c            |   15 -
 arch/powerpc/kernel/vmlinux.lds.S         |    3 
 arch/s390/kernel/compat_linux.c           |   37 ----
 arch/s390/kernel/sys_s390.c               |   30 ---
 arch/score/kernel/sys_score.c             |   28 ---
 arch/sh/kernel/sys_sh.c                   |   28 ---
 arch/sh/mm/mmap.c                         |    3 
 arch/sparc/kernel/sys_sparc_32.c          |   64 -------
 arch/sparc/kernel/sys_sparc_64.c          |   50 +-----
 arch/sparc/kernel/systbls.h               |    1 
 arch/sparc/kernel/systbls_32.S            |    4 
 arch/sparc/kernel/systbls_64.S            |    4 
 arch/um/kernel/syscall.c                  |   28 ---
 arch/um/sys-i386/shared/sysdep/syscalls.h |    4 
 arch/x86/Kconfig.cpu                      |    2 
 arch/x86/ia32/ia32entry.S                 |    2 
 arch/x86/ia32/sys_ia32.c                  |   43 -----
 arch/x86/include/asm/sys_ia32.h           |    3 
 arch/x86/include/asm/syscalls.h           |    2 
 arch/x86/kernel/sys_i386_32.c             |   27 ---
 arch/x86/kernel/sys_x86_64.c              |   17 --
 arch/x86/kernel/syscall_table_32.S        |    2 
 arch/xtensa/include/asm/syscall.h         |    2 
 arch/xtensa/include/asm/unistd.h          |    2 
 arch/xtensa/kernel/syscall.c              |   25 ---
 drivers/char/agp/intel-agp.c              |    7 
 drivers/cpuidle/governors/menu.c          |   12 +
 drivers/gpu/drm/ati_pcigart.c             |   10 -
 drivers/gpu/drm/drm_bufs.c                |    4 
 drivers/gpu/drm/drm_pci.c                 |    8 
 drivers/gpu/drm/i915/i915_dma.c           |    5 
 drivers/gpu/drm/i915/i915_drv.h           |    1 
 drivers/gpu/drm/i915/i915_gem.c           |   12 -
 drivers/gpu/drm/i915/i915_reg.h           |    4 
 drivers/gpu/drm/i915/intel_display.c      |  180 ++++++----------------
 drivers/gpu/drm/i915/intel_lvds.c         |    9 +
 drivers/hwmon/Kconfig                     |    2 
 drivers/hwmon/adt7462.c                   |    2 
 drivers/hwmon/coretemp.c                  |   16 +
 drivers/mmc/card/block.c                  |    8 
 drivers/mmc/card/queue.c                  |   18 +-
 drivers/net/wireless/ath/ath5k/eeprom.c   |   32 +++
 drivers/net/wireless/ath/ath5k/eeprom.h   |    8 
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    2 
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 
 drivers/net/wireless/libertas/scan.c      |   22 --
 drivers/rtc/rtc-cmos.c                    |    9 -
 drivers/xen/manage.c                      |    8 
 fs/exofs/inode.c                          |   17 +-
 fs/fcntl.c                                |  102 ++++++++----
 fs/nfsd/vfs.c                             |    5 
 fs/quota/dquot.c                          |    3 
 include/drm/drmP.h                        |    2 
 include/linux/syscalls.h                  |    4 
 ipc/shm.c                                 |   31 ++-
 kernel/audit_tree.c                       |   13 -
 kernel/cgroup.c                           |    1 
 kernel/module.c                           |   45 +++--
 kernel/signal.c                           |    3 
 kernel/sysctl.c                           |    2 
 lib/dma-debug.c                           |    7 
 lib/rational.c                            |    1 
 mm/mmap.c                                 |   42 +----
 mm/mremap.c                               |  241 +++++++++++++++++++-----------
 mm/util.c                                 |   44 +++++
 net/bridge/netfilter/ebtables.c           |    6 
 net/ipv6/exthdrs.c                        |    7 
 net/mac80211/iface.c                      |   40 ++++
 net/mac80211/mlme.c                       |    4 
 net/mac80211/rx.c                         |    8 
 net/mac80211/tx.c                         |    5 
 net/mac80211/util.c                       |   12 +
 net/mac80211/wme.c                        |   89 +++++++----
 net/mac80211/wme.h                        |    8 
 net/netfilter/nf_conntrack_ftp.c          |   18 +-
 net/sunrpc/auth_gss/auth_gss.c            |   17 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c       |    4 
 net/sunrpc/auth_gss/gss_mech_switch.c     |    2 
 net/sunrpc/svc_xprt.c                     |    3 
 net/wireless/reg.c                        |    2 
 sound/pci/ac97/ac97_patch.c               |    1 
 sound/pci/atiixp.c                        |    1 
 sound/pci/hda/patch_realtek.c             |    2 
 sound/soc/codecs/wm8350.c                 |    2 
 sound/soc/codecs/wm8510.c                 |   14 -
 sound/soc/codecs/wm8940.c                 |   14 -
 sound/soc/codecs/wm8974.c                 |   14 -
 119 files changed, 873 insertions(+), 1515 deletions(-)


Adrian Hunter (1):
      mmc_block: fix queue cleanup

Al Viro (3):
      untangle the do_mremap() mess
      fix braindamage in audit_tree.c untag_chunk()
      fix more leaks in audit_tree.c tag_chunk()

Andi Kleen (1):
      kernel/signal.c: fix kernel information leak with print-fatal-signals=1

Andrew Morton (1):
      drm/i915: fix unused var

Anna Lemehova (1):
      mmc_block: add dev_t initialization check

Ben Hutchings (1):
      modules: Skip empty sections when exporting section notes

Boaz Harrosh (1):
      exofs: simple_write_end does not mark_inode_dirty

Chris Wilson (1):
      drm/i915: Permit pinning whilst the device is 'suspended'

Christoph Hellwig (1):
      nfsd: make sure data is on disk before calling ->fsync

Dan Carpenter (1):
      iwl: off by one bug

Daniel T Chen (2):
      ALSA: ac97: Add Dell Dimension 2400 to Headphone/Line Jack Sense blacklist
      ALSA: atiixp: Specify codec for Foxconn RC4107MA-RS2

Daniel Vetter (1):
      drm/i915: fix order of fence release wrt flushing

Dave Anderson (1):
      cgroups: fix 2.6.32 regression causing BUG_ON() in cgroup_diput()

David S. Miller (1):
      ipv6: skb_dst() can be NULL in ipv6_hop_jumbo().

David Woodhouse (1):
      agp/intel-agp: Clear entire GTT on startup

Felix Fietkau (1):
      mac80211: add missing sanity checks for action frames

Florian Westphal (1):
      netfilter: ebtables: enforce CAP_NET_ADMIN

Greg Kroah-Hartman (1):
      Linux 2.6.32.4

Guennadi Liakhovetski (1):
      ASoC: fix params_rate() macro use in several codecs

Ian Campbell (1):
      xen: fix hang on suspend.

Jan Kara (1):
      quota: Fix dquot_transfer for filesystems different from ext4

Jarkko Lavinen (1):
      mmc_block: fix probe error cleanup bug

Jeff Layton (1):
      sunrpc: on successful gss error pipe write, don't return error

Jesse Barnes (1):
      drm/i915: remove render reclock support

Johannes Berg (1):
      mac80211: fix skb buffering issue (and fixes to that)

Krzysztof Halasa (1):
      dma-debug: allow DMA_BIDIRECTIONAL mappings to be synced with DMA_FROM_DEVICE and

Linus Torvalds (1):
      fasync: split 'fasync_helper()' into separate add/remove functions

Luis R. Rodriguez (2):
      ath5k: Fix eeprom checksum check for custom sized eeproms
      cfg80211: fix syntax error on user regulatory hints

Mark Brown (1):
      ASoC: Fix WM8350 DSP mode B configuration

Mike Frysinger (1):
      kernel/sysctl.c: fix stable merge error in NOMMU mmap_min_addr

OGAWA Hirofumi (1):
      rtc_cmos: convert shutdown to new pnp_driver->shutdown

Patrick McHardy (1):
      netfilter: nf_ct_ftp: fix out of bounds read in update_nl_seq()

Roger Blofeld (1):
      hwmon: (adt7462) Fix pin 28 monitoring

Rusty Russell (2):
      Revert "x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium"
      module: handle ppc64 relocating kcrctabs when CONFIG_RELOCATABLE=y

Samuel Ortiz (1):
      libertas: Remove carrier signaling from the scan code

Sascha Hauer (1):
      lib/rational.c needs module.h

Stephen Hemminger (1):
      drivers/cpuidle/governors/menu.c: fix undefined reference to `__udivdi3'

Takashi Iwai (1):
      ALSA: hda - Fix ALC861-VD capture source mixer

Trond Myklebust (2):
      SUNRPC: Fix up an error return value in gss_import_sec_context_kerberos()
      SUNRPC: Fix the return value in gss_import_sec_context()

Xiaotian Feng (1):
      sunrpc: fix peername failed on closed listener

Yong Wang (1):
      hwmon: (coretemp) Fix TjMax for Atom N450/D410/D510 CPUs

Zhao Yakui (4):
      drm/i915: Update LVDS connector status when receiving ACPI LID event
      drm/i915: Enable/disable the dithering for LVDS based on VBT setting
      drm/i915: Make the BPC in FDI rx/transcoder be consistent with that in pipeconf on Ironlake
      drm/i915: Select the correct BPC for LVDS on Ironlake

Zhenyu Wang (1):
      drm: remove address mask param for drm_pci_alloc()

Zhu Yi (1):
      iwlwifi: fix iwl_queue_used bug when read_ptr == write_ptr

