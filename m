Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZEOICc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZEOICc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbZEOICR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:02:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:35265 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbZEOICQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:02:16 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 May 2009 18:01:31 +1000
Message-Id: <1242374491.22331.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some updates for .30. A bit more than I would have hoped at
this stage in the game, but I've been MIA for a while, first on vacation
and then carried off to a customer issue, and so a lot of this have
actually been around for some time. There are bug fixes and defconfig
updates exclusively (though not all are regressions).

The tree is based on an older -rc3 checkout but it seems to merge fine
with your latest so I didn't feel the need to stick a merge commit
myself in there.

Cheers,
Ben.

The following changes since commit 45d447406a19cbfd42720f066f156f4eb9d68801:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../czankel/xtensa-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Vorontsov (1):
      powerpc/fsl_soc: Remove mpc83xx_wdt_init, again

Becky Bruce (1):
      powerpc: Allow mem=x cmdline to work with 4G+

Benjamin Herrenschmidt (2):
      powerpc/pseries: Really fix the oprofile CPU type on pseries
      powerpc: Fix PCI ROM access

Benjamin Krill (1):
      serial/nwpserial: Fix wrong register read address and add interrupt acknowledge.

Gerhard Stenzel (1):
      powerpc/cell: Make ptcal more reliable

Grant Likely (2):
      powerpc/boot: add simpleImage.* to clean-files list
      powerpc/virtex: Add uImage to the default images list

John Linn (1):
      powerpc/virtex: Fix duplicate level irq events.

Kumar Gala (6):
      powerpc/83xx: Update defconfigs
      powerpc/85xx: Update defconfigs
      powerpc/86xx: Update defconfigs
      powerpc/embedded6xx: Update defconfigs
      powerpc/8xx: Update defconfigs
      powerpc/mpic: Fix incorrect allocation of interrupt rev-map

Maynard Johnson (1):
      powerpc: Fix oprofile sampling of marked events on POWER7

Stephen Rothwell  x (1):
      powerpc/iseries: Fix pci breakage due to bad dma_data initialization

Timur Tabi (1):
      powerpc: Fix mktree build error on Mac OS X host

 arch/powerpc/boot/Makefile                        |    2 +-
 arch/powerpc/boot/mktree.c                        |   10 +-
 arch/powerpc/configs/83xx/asp8347_defconfig       |  104 ++++--
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |  114 +++++--
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |  114 +++++--
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |  107 +++++--
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |  113 +++++--
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |  108 +++++--
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |  108 +++++--
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |  103 ++++--
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |  108 +++++--
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |   96 ++++--
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |  104 +++++--
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |  111 +++++--
 arch/powerpc/configs/83xx/sbc834x_defconfig       |   96 ++++--
 arch/powerpc/configs/85xx/ksi8560_defconfig       |   86 ++++--
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |   82 ++++--
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |   89 ++++--
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |   88 ++++--
 arch/powerpc/configs/85xx/sbc8548_defconfig       |   84 ++++-
 arch/powerpc/configs/85xx/sbc8560_defconfig       |   83 ++++--
 arch/powerpc/configs/85xx/socrates_defconfig      |  385 ++++++++++++++++-----
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |  105 +++++--
 arch/powerpc/configs/85xx/tqm8540_defconfig       |  100 ++++--
 arch/powerpc/configs/85xx/tqm8541_defconfig       |  101 ++++--
 arch/powerpc/configs/85xx/tqm8548_defconfig       |   64 +++-
 arch/powerpc/configs/85xx/tqm8555_defconfig       |  101 ++++--
 arch/powerpc/configs/85xx/tqm8560_defconfig       |  101 ++++--
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     |   92 ++++--
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    |   92 ++++--
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |  122 +++++--
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |  100 ++++--
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |  211 +++++-------
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |  114 +++++--
 arch/powerpc/configs/adder875_defconfig           |   65 +++-
 arch/powerpc/configs/c2k_defconfig                |  128 +++++--
 arch/powerpc/configs/ep8248e_defconfig            |   74 +++--
 arch/powerpc/configs/ep88xc_defconfig             |   63 +++-
 arch/powerpc/configs/linkstation_defconfig        |   96 ++++--
 arch/powerpc/configs/mgcoge_defconfig             |   74 +++-
 arch/powerpc/configs/mgsuvd_defconfig             |   72 +++-
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |   91 ++++--
 arch/powerpc/configs/mpc8272_ads_defconfig        |   77 +++--
 arch/powerpc/configs/mpc83xx_defconfig            |  115 +++++--
 arch/powerpc/configs/mpc866_ads_defconfig         |   77 +++--
 arch/powerpc/configs/mpc86xx_defconfig            |  211 +++++-------
 arch/powerpc/configs/mpc885_ads_defconfig         |   63 +++-
 arch/powerpc/configs/pq2fads_defconfig            |   90 ++++--
 arch/powerpc/configs/prpmc2800_defconfig          |  120 +++++--
 arch/powerpc/configs/storcenter_defconfig         |   71 +++-
 arch/powerpc/include/asm/iseries/iommu.h          |    4 -
 arch/powerpc/include/asm/system.h                 |    2 +-
 arch/powerpc/kernel/cputable.c                    |    2 +-
 arch/powerpc/kernel/machine_kexec.c               |    4 +-
 arch/powerpc/kernel/pci-common.c                  |   21 +-
 arch/powerpc/kernel/pci_64.c                      |   15 +-
 arch/powerpc/kernel/prom.c                        |    8 +-
 arch/powerpc/mm/mem.c                             |    2 +-
 arch/powerpc/oprofile/op_model_power4.c           |    9 +-
 arch/powerpc/platforms/40x/Kconfig                |    1 +
 arch/powerpc/platforms/44x/Kconfig                |    1 +
 arch/powerpc/platforms/cell/ras.c                 |   17 +-
 arch/powerpc/platforms/iseries/iommu.c            |    6 +-
 arch/powerpc/platforms/iseries/pci.c              |    1 -
 arch/powerpc/sysdev/fsl_soc.c                     |   46 ---
 arch/powerpc/sysdev/mpic.c                        |   16 +-
 arch/powerpc/sysdev/xilinx_intc.c                 |  117 ++++++-
 drivers/serial/nwpserial.c                        |    4 +-
 68 files changed, 3819 insertions(+), 1542 deletions(-)


