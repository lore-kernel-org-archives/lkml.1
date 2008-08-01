Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYHAXOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYHAXOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYHAXOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:14:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYHAXOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:14:30 -0400
Date: Fri, 1 Aug 2008 16:10:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.14
Message-ID: <20080801231051.GA22309@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.14
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.25
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.25.13 and 2.6.25.14

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

-------------

 Makefile                                      |    5 ++-
 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 ++++
 arch/sparc64/kernel/irq.c                     |   10 ++++++
 arch/sparc64/kernel/ldc.c                     |   38 +++++++++++++-------------
 arch/sparc64/kernel/time.c                    |   15 ++++++----
 arch/x86/Kconfig.cpu                          |    2 -
 arch/x86/mm/init_64.c                         |    2 -
 drivers/acpi/processor_perflib.c              |   15 ++++++++--
 drivers/ata/ahci.c                            |   15 ++++++++--
 drivers/ata/ata_generic.c                     |    6 ++++
 drivers/ata/pata_acpi.c                       |    6 ++++
 drivers/cpufreq/cpufreq.c                     |    3 ++
 drivers/ide/ide-cd.c                          |   27 +++++++++++++++---
 drivers/net/ixgbe/ixgbe_main.c                |    2 -
 drivers/net/wireless/ath5k/base.c             |    5 ---
 drivers/net/wireless/b43legacy/main.c         |    2 -
 drivers/spi/mpc52xx_psc_spi.c                 |   22 ++++-----------
 fs/dquot.c                                    |   16 ++++++++++
 fs/ecryptfs/crypto.c                          |   30 ++++++++++++--------
 fs/isofs/rock.c                               |   22 +++++++++++++--
 fs/libfs.c                                    |    4 +-
 include/asm-arm/bitops.h                      |    9 +++++-
 include/asm-generic/vmlinux.lds.h             |    4 ++
 include/asm-powerpc/pgtable-ppc64.h           |   11 +++++++
 include/asm-sparc64/io.h                      |    1 
 include/linux/cpufreq.h                       |    1 
 kernel/marker.c                               |   12 ++++++--
 kernel/sys_ni.c                               |    1 
 mm/filemap.c                                  |    2 -
 mm/hugetlb.c                                  |    6 +++-
 mm/shmem.c                                    |    3 +-
 net/ipv4/tcp_input.c                          |    3 --
 net/netfilter/nf_conntrack_proto_tcp.c        |   10 +++++-
 scripts/Makefile.modpost                      |    1 
 scripts/mod/modpost.c                         |    3 +-
 sound/pci/hda/patch_realtek.c                 |    1 
 sound/pci/trident/trident_main.c              |    5 ++-
 37 files changed, 234 insertions(+), 92 deletions(-)


Adam Greenblatt (1):
      isofs: fix minor filesystem corruption

Akio Idehara (1):
      ALSA: hda - Fix "alc262_sony_unsol[]" hda_verb array

Alan Cox (1):
      pata_atiixp: Don't disable

Alex Nixon (1):
      VFS: increase pseudo-filesystem block size to PAGE_SIZE

Andrew Morton (1):
      ARM: fix fls() for 64-bit arguments

Atsushi Nemoto (1):
      Fix build on COMPAT platforms when CONFIG_EPOLL is disabled

David Gibson (1):
      Correct hash flushing from huge_ptep_set_wrprotect()

David S. Miller (4):
      tcp: Clear probes_out more aggressively in tcp_ack().
      sparc64: Fix lockdep issues in LDC protocol layer.
      sparc64: Fix cpufreq notifier registry.
      sparc64: Do not define BIO_VMERGE_BOUNDARY.

Eric Sandeen (1):
      eCryptfs: use page_alloc not kmalloc to get a page of memory

Greg Kroah-Hartman (1):
      Linux 2.6.25.14

Hugh Dickins (1):
      tmpfs: fix kernel BUG in shmem_delete_inode

Ingo Molnar (1):
      x86: fix kernel_physical_mapping_init() for large x86 systems

Jan Beulich (1):
      vmlinux.lds: move __attribute__((__cold__)) functions back into final .text section

Jan Kara (1):
      quota: fix possible infinite loop in quota code

Jan Kratochvil (1):
      x86: fix crash due to missing debugctlmsr on AMD K6-3

Jens Axboe (1):
      ide-cd: fix oops when using growisofs

Jesse Brandeburg (1):
      ixgbe: remove device ID for unsupported device

Julia Lawall (1):
      b43legacy: Release mutex in error handling code

Linus Torvalds (1):
      Fix off-by-one error in iov_iter_advance()

Luotao Fu (1):
      mpc52xx_psc_spi: fix block transfer

Mathieu Desnoyers (2):
      markers: fix duplicate modpost entry
      markers: fix markers read barrier for multiple probes

Patrick McHardy (1):
      netfilter -stable: nf_conntrack_tcp: fix endless loop

Pavel Roskin (1):
      ath5k: don't enable MSI, we cannot handle it yet

Pierre Ossman (1):
      ALSA: trident - pause s/pdif output

Tejun Heo (1):
      ahci: retry enabling AHCI a few times before spitting out WARN_ON()

Thomas Renninger (1):
      cpufreq acpi: only call _PPC after cpufreq ACPI init funcs got called already

