Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYFPGCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYFPGCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYFPGCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:02:30 -0400
Received: from ozlabs.org ([203.10.76.45]:60317 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYFPGC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:02:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18518.114.100584.607669@cargo.ozlabs.ibm.com>
Date: Mon, 16 Jun 2008 15:56:02 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get some more bug fixes and defconfig updates for powerpc, as
listed below.  Almost all of the bulk is in the defconfig updates for
the Freescale embedded platforms.

Thanks,
Paul.

 arch/powerpc/Makefile                             |    4 
 arch/powerpc/boot/Makefile                        |    2 
 arch/powerpc/boot/crtsavres.S                     |  233 +++++++++++++++
 arch/powerpc/boot/dts/mpc8377_rdb.dts             |    8 -
 arch/powerpc/boot/dts/mpc8378_rdb.dts             |    8 -
 arch/powerpc/boot/dts/mpc8379_rdb.dts             |    8 -
 arch/powerpc/boot/dts/mpc8548cds.dts              |    4 
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |  155 +++++++---
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |  162 +++++++----
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |  146 ++++++----
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |  150 +++++++---
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |  157 +++++++---
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |  150 ++++++----
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |  146 ++++++----
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |  146 ++++++----
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |  146 ++++++----
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |  224 +++++++++++----
 arch/powerpc/configs/83xx/sbc834x_defconfig       |  140 ++++++---
 arch/powerpc/configs/85xx/ksi8560_defconfig       |  168 +++++++----
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |  133 ++++++---
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig    |  210 +++++++++-----
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |  135 ++++++---
 arch/powerpc/configs/85xx/mpc8568mds_defconfig    |  150 ++++++----
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig    |  210 +++++++++-----
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |  137 ++++++---
 arch/powerpc/configs/85xx/sbc8548_defconfig       |  131 ++++++---
 arch/powerpc/configs/85xx/sbc8560_defconfig       |  135 ++++++---
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |  152 ++++++----
 arch/powerpc/configs/85xx/tqm8540_defconfig       |  147 ++++++----
 arch/powerpc/configs/85xx/tqm8541_defconfig       |  146 ++++++----
 arch/powerpc/configs/85xx/tqm8555_defconfig       |  146 ++++++----
 arch/powerpc/configs/85xx/tqm8560_defconfig       |  146 ++++++----
 arch/powerpc/configs/adder875_defconfig           |   52 ++-
 arch/powerpc/configs/ep8248e_defconfig            |  124 ++++++--
 arch/powerpc/configs/ep88xc_defconfig             |   47 ++-
 arch/powerpc/configs/linkstation_defconfig        |  172 +++++++----
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |  136 ++++++---
 arch/powerpc/configs/mpc8272_ads_defconfig        |  126 ++++++--
 arch/powerpc/configs/mpc83xx_defconfig            |  151 ++++++----
 arch/powerpc/configs/mpc85xx_defconfig            |  230 ++++++++++-----
 arch/powerpc/configs/mpc8610_hpcd_defconfig       |  316 ++++++++++++---------
 arch/powerpc/configs/mpc8641_hpcn_defconfig       |  210 +++++++++-----
 arch/powerpc/configs/mpc866_ads_defconfig         |  128 ++++++---
 arch/powerpc/configs/mpc885_ads_defconfig         |   47 ++-
 arch/powerpc/configs/pq2fads_defconfig            |  133 ++++++---
 arch/powerpc/configs/prpmc2800_defconfig          |  153 +++++++---
 arch/powerpc/configs/sbc8641d_defconfig           |  150 ++++++----
 arch/powerpc/configs/storcenter_defconfig         |   71 +++--
 arch/powerpc/kernel/irq.c                         |    2 
 arch/powerpc/kernel/ppc_ksyms.c                   |    2 
 arch/powerpc/kernel/prom_init_check.sh            |   14 +
 arch/powerpc/lib/Makefile                         |    2 
 arch/powerpc/lib/crtsavres.S                      |  229 +++++++++++++++
 arch/powerpc/platforms/85xx/Kconfig               |    1 
 arch/powerpc/platforms/cell/spu_base.c            |   44 ++-
 arch/powerpc/platforms/cell/spufs/run.c           |   21 +
 arch/powerpc/platforms/cell/spufs/sched.c         |   19 +
 arch/powerpc/platforms/pseries/eeh_driver.c       |   11 -
 arch/powerpc/platforms/pseries/nvram.c            |    4 
 arch/powerpc/xmon/xmon.c                          |    1 
 drivers/macintosh/mediabay.c                      |    4 
 drivers/macintosh/smu.c                           |    5 
 drivers/macintosh/therm_adt746x.c                 |   13 +
 include/asm-powerpc/mediabay.h                    |   12 +
 include/asm-powerpc/spu.h                         |    1 
 include/asm-powerpc/spu_csa.h                     |    2 
 include/asm-powerpc/system.h                      |    2 
 67 files changed, 4557 insertions(+), 2213 deletions(-)
 create mode 100644 arch/powerpc/boot/crtsavres.S
 create mode 100644 arch/powerpc/lib/crtsavres.S

Adrian Bunk (1):
      [POWERPC] Build fix for drivers/macintosh/mediabay.c

Andrew Morton (1):
      [POWERPC] Fix warning in pseries/eeh_driver.c

Anton Vorontsov (1):
      [POWERPC] 83xx: MPC837xRDB's VSC7385 ethernet switch isn't on the MDIO bus

Emil Medve (1):
      [POWERPC] Fix return value check logic in debugfs virq_mapping setup

Grant Likely (1):
      [POWERPC] bootwrapper: add simpleImage* to list of boot targets

Julia Lawall (3):
      [POWERPC] Add missing of_node_put in pseries/nvram.c
      [POWERPC] Add missing of_node_put in drivers/macintosh/smu.c
      [POWERPC] Add missing of_node_put in drivers/macintosh/therm_adt746x.c

Kumar Gala (5):
      [POWERPC] 85xx: MPC85xx MDS - Unconditionally select PHYLIB for board fixups
      [POWERPC] 85xx: MPC8548CDS - Fix size of PCIe IO space
      [POWERPC] Updated Freescale PPC defconfigs
      [POWERPC] Fix bootwrapper builds with newer gcc versions
      [POWERPC] Fix -Os kernel builds with newer gcc versions

Luke Browning (4):
      powerpc/spufs: wait for stable spu status in spu_stopped()
      powerpc/spufs: remove class_0_dsisr from spu exception handling
      powerpc/spufs: synchronize interaction between spu exception handling and time slicing
      powerpc/spufs: fix missed stop-and-signal event

Nick Piggin (1):
      [POWERPC] Fix rmb to order cacheable vs. noncacheable

Stephen Rothwell (1):
      [POWERPC] Remove ppc32's export of console_drivers

Timur Tabi (1):
      [POWERPC] 8610: Update defconfig for MPC8610 HPCD

