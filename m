Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZA1Ixs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZA1Ixs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZA1Ixk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:53:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:39739 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbZA1Ixj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:53:39 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 17:41:37 +1100
Message-Id: <1233124897.6963.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Please fine here some defconfig updates and a few small fixes for 2.6.29
The following changes since commit e4a7ca29039e615ce13a61b9c6abfb2aa394e9a1:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (2):
      Merge commit 'kumar/kumar-merge' into merge
      Merge commit 'jwb/jwb-merge' into merge

Gerhard Pircher (1):
      powerpc/mm: Fix handling of _PAGE_COHERENT in BAT setup code

Grant Erickson (1):
      powerpc/4xx: DTS: Add Add'l SDRAM0 Compatible and Interrupt Info

Josh Boyer (4):
      powerpc/40x: Update PowerPC 40x defconfigs
      powerpc/44x: Update PowerPC 44x defconfigs
      powerpc/4xx: Update multi-board PowerPC 4xx defconfigs
      powerpc: Remove arch/ppc cruft from Kconfig

Kumar Gala (6):
      powerpc/85xx: Fix typo in mpc8572ds dts
      powerpc/85xx: Update defconfigs
      powerpc/83xx: Update defconfigs
      powerpc/86xx: Update defconfigs
      powerpc/8xx: Update defconfigs
      powerpc/embedded6xx: Update defconfigs

Li Yang (1):
      powerpc/mpc8313erdb: fix kernel panic because mdio device is not probed

Robert Jennings (1):
      powerpc/pseries: Correct VIO bus accounting problem in CMO env.

Sean MacLennan (1):
      powerpc/44x: Warp patches for the new NDFC driver

Stephen Rothwell (2):
      powerpc: Printing fix for l64 to ll64 conversion: phyp_dump.c
      powerpc: More printing warning fixes for the l64 to ll64 conversion

 arch/powerpc/Kconfig                              |    4 -
 arch/powerpc/boot/cuboot-warp.c                   |   43 ------
 arch/powerpc/boot/dts/haleakala.dts               |    5 +-
 arch/powerpc/boot/dts/kilauea.dts                 |    5 +-
 arch/powerpc/boot/dts/makalu.dts                  |    5 +-
 arch/powerpc/boot/dts/mpc8313erdb.dts             |    2 +-
 arch/powerpc/boot/dts/mpc8572ds.dts               |    2 +-
 arch/powerpc/boot/dts/warp.dts                    |   42 ++++++-
 arch/powerpc/configs/40x/acadia_defconfig         |   76 ++++++++---
 arch/powerpc/configs/40x/ep405_defconfig          |   87 ++++++++++---
 arch/powerpc/configs/40x/hcu4_defconfig           |   78 +++++++++---
 arch/powerpc/configs/40x/kilauea_defconfig        |   76 ++++++++---
 arch/powerpc/configs/40x/makalu_defconfig         |   76 ++++++++---
 arch/powerpc/configs/40x/virtex_defconfig         |   53 ++++++---
 arch/powerpc/configs/40x/walnut_defconfig         |   84 +++++++++---
 arch/powerpc/configs/44x/arches_defconfig         |   60 ++++++---
 arch/powerpc/configs/44x/bamboo_defconfig         |   76 ++++++++---
 arch/powerpc/configs/44x/canyonlands_defconfig    |   60 ++++++---
 arch/powerpc/configs/44x/ebony_defconfig          |   84 +++++++++---
 arch/powerpc/configs/44x/katmai_defconfig         |   76 ++++++++---
 arch/powerpc/configs/44x/rainier_defconfig        |   83 +++++++++---
 arch/powerpc/configs/44x/sam440ep_defconfig       |   77 ++++++++---
 arch/powerpc/configs/44x/sequoia_defconfig        |   83 +++++++++---
 arch/powerpc/configs/44x/taishan_defconfig        |   83 +++++++++---
 arch/powerpc/configs/44x/virtex5_defconfig        |   53 ++++++---
 arch/powerpc/configs/44x/warp_defconfig           |  138 +++++++++++++++-----
 arch/powerpc/configs/83xx/asp8347_defconfig       |   91 +++++++++----
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |  103 +++++++++++----
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |  103 +++++++++++----
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |   86 +++++++++----
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |   89 +++++++++----
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |  100 ++++++++++-----
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |   98 ++++++++++-----
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |   84 ++++++++----
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |   93 ++++++++++----
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |   88 +++++++++----
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |   84 +++++++++----
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |   90 +++++++++----
 arch/powerpc/configs/83xx/sbc834x_defconfig       |   74 +++++++----
 arch/powerpc/configs/85xx/ksi8560_defconfig       |   79 ++++++++----
 arch/powerpc/configs/85xx/mpc8536_ds_defconfig    |  111 ++++++++++++----
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |   66 +++++++---
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig    |  111 ++++++++++++----
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |   73 ++++++++---
 arch/powerpc/configs/85xx/mpc8568mds_defconfig    |   86 +++++++++----
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig    |   80 +++++++++---
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |   69 +++++++---
 arch/powerpc/configs/85xx/sbc8548_defconfig       |   60 ++++++---
 arch/powerpc/configs/85xx/sbc8560_defconfig       |   66 +++++++---
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |   88 +++++++++----
 arch/powerpc/configs/85xx/tqm8540_defconfig       |   81 +++++++++----
 arch/powerpc/configs/85xx/tqm8541_defconfig       |   88 +++++++++----
 arch/powerpc/configs/85xx/tqm8548_defconfig       |   84 +++++++++----
 arch/powerpc/configs/85xx/tqm8555_defconfig       |   88 +++++++++----
 arch/powerpc/configs/85xx/tqm8560_defconfig       |   88 +++++++++----
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |  136 +++++++++++++++-----
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |   83 +++++++++----
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |  111 ++++++++++++-----
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |  102 +++++++++++----
 arch/powerpc/configs/adder875_defconfig           |   65 ++++++---
 arch/powerpc/configs/c2k_defconfig                |  118 ++++++++++++-----
 arch/powerpc/configs/ep8248e_defconfig            |   77 ++++++++----
 arch/powerpc/configs/ep88xc_defconfig             |   65 ++++++---
 arch/powerpc/configs/linkstation_defconfig        |  110 ++++++++++------
 arch/powerpc/configs/mgcoge_defconfig             |   74 ++++++++---
 arch/powerpc/configs/mgsuvd_defconfig             |   63 ++++++---
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |   71 +++++++----
 arch/powerpc/configs/mpc8272_ads_defconfig        |   77 ++++++++----
 arch/powerpc/configs/mpc83xx_defconfig            |  107 +++++++++++-----
 arch/powerpc/configs/mpc85xx_defconfig            |  120 +++++++++++++-----
 arch/powerpc/configs/mpc866_ads_defconfig         |   64 ++++++---
 arch/powerpc/configs/mpc86xx_defconfig            |  143 ++++++++++++++++-----
 arch/powerpc/configs/mpc885_ads_defconfig         |   65 ++++++---
 arch/powerpc/configs/ppc40x_defconfig             |   77 +++++++++---
 arch/powerpc/configs/ppc44x_defconfig             |   79 +++++++++---
 arch/powerpc/configs/pq2fads_defconfig            |   87 +++++++++----
 arch/powerpc/configs/prpmc2800_defconfig          |   96 ++++++++++----
 arch/powerpc/configs/storcenter_defconfig         |   85 ++++++++----
 arch/powerpc/kernel/vio.c                         |    7 +-
 arch/powerpc/mm/ppc_mmu_32.c                      |    6 +-
 arch/powerpc/platforms/44x/Makefile               |    1 -
 arch/powerpc/platforms/44x/warp-nand.c            |  135 -------------------
 arch/powerpc/platforms/83xx/mpc831x_rdb.c         |    1 +
 arch/powerpc/platforms/pseries/phyp_dump.c        |   26 ++--
 drivers/edac/cell_edac.c                          |    8 +-
 drivers/mtd/nand/fsl_elbc_nand.c                  |    8 +-
 drivers/mtd/nand/pasemi_nand.c                    |    4 +-
 87 files changed, 4353 insertions(+), 1930 deletions(-)
 delete mode 100644 arch/powerpc/platforms/44x/warp-nand.c


