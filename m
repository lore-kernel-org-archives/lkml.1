Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZDVHMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZDVHMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZDVHMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:12:15 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42221 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZDVHMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:12:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18926.44987.591720.873463@cargo.ozlabs.ibm.com>
Date: Wed, 22 Apr 2009 15:48:43 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get some more bug fixes for powerpc, plus some documentation and
defconfig updates and a MAINTAINERS update.

Thanks,
Paul.

 Documentation/powerpc/booting-without-of.txt       |   89 -
 Documentation/powerpc/dts-bindings/mtd-physmap.txt |   80 +
 MAINTAINERS                                        |    5 
 arch/powerpc/boot/dts/lite5200b.dts                |   39 
 arch/powerpc/configs/52xx/cm5200_defconfig         |   69 +
 arch/powerpc/configs/52xx/lite5200b_defconfig      |   74 +
 arch/powerpc/configs/52xx/motionpro_defconfig      |   77 +
 arch/powerpc/configs/52xx/pcm030_defconfig         |   69 +
 arch/powerpc/configs/52xx/tqm5200_defconfig        |   76 +
 arch/powerpc/configs/85xx/mpc8536_ds_defconfig     | 1802 --------------------
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig     | 1802 --------------------
 arch/powerpc/configs/85xx/mpc8568mds_defconfig     | 1309 ---------------
 arch/powerpc/configs/mpc5200_defconfig             |  188 ++
 arch/powerpc/configs/mpc85xx_defconfig             |  252 +--
 arch/powerpc/configs/mpc85xx_smp_defconfig         |  343 ++--
 arch/powerpc/include/asm/elf.h                     |    3 
 arch/powerpc/kernel/prom_parse.c                   |   11 
 arch/powerpc/mm/hash_utils_64.c                    |    2 
 arch/powerpc/platforms/fsl_uli1575.c               |    5 
 arch/powerpc/platforms/pasemi/setup.c              |    4 
 arch/powerpc/platforms/ps3/os-area.c               |    2 
 arch/powerpc/sysdev/fsl_rio.c                      |   28 
 drivers/macintosh/Kconfig                          |    2 
 drivers/macintosh/mediabay.c                       |    2 
 include/linux/fsl_devices.h                        |    4 
 25 files changed, 896 insertions(+), 5441 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/mtd-physmap.txt
 delete mode 100644 arch/powerpc/configs/85xx/mpc8536_ds_defconfig
 delete mode 100644 arch/powerpc/configs/85xx/mpc8544_ds_defconfig
 delete mode 100644 arch/powerpc/configs/85xx/mpc8568mds_defconfig
 rename arch/powerpc/configs/{85xx/mpc8572_ds_defconfig => mpc85xx_smp_defconfig} (91%)

Alexander Beregalov (1):
      powerpc: Make macintosh/mediabay driver depend on CONFIG_BLOCK

Andreas Schwab (1):
      powerpc/32: Don't clobber personality flags on exec

Anton Vorontsov (2):
      powerpc/5200: Bring the legacy fsl_spi_platform_data hooks back
      fsl_rio: Pass the proper device to dma mapping routines

Bartlomiej Zolnierkiewicz (1):
      powerpc: Fix modular build of ide-pmac when mediabay is built in

Geoff Levand (3):
      powerpc/ps3: Fix CONFIG_PS3_FLASH=n build warning
      maintainers: Fix PS3 patterns
      powerpc/pasemi: Fix build error on UP

Grant Likely (2):
      powerpc/5200: Add FLASH nodes to lite5200 device tree
      powerpc/5200: defconfig updates

Ilpo Järvinen (1):
      powerpc: Fix of_node_put() exit path in of_irq_map_one()

Kumar Gala (4):
      powerpc/85xx: Updated generic mpc85xx_defconfig
      powerpc/85xx: Enabled a bunch of FSL specific drivers/options
      powerpc/85xx: Added SMP defconfig
      powerpc/85xx: Remove defconfigs that mpc85xx_{smp_}defconfig cover

Michael Ellerman (1):
      powerpc: Fix crash on CPU hotplug

Stefan Roese (2):
      powerpc/of-device-tree: Factor MTD physmap bindings out of booting-without-of
      powerpc/device-tree: Document MTD nodes with multiple "reg" tuples

Timur Tabi (1):
      powerpc: don't disable SATA interrupts on Freescale MPC8610 HPCD

