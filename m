Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZAZU3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZAZU3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZAZU3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:29:41 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:32413 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZAZU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:29:39 -0500
Date: Mon, 26 Jan 2009 21:29:27 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.29
Message-ID: <20090126212927.4517f9d5@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem updates for Linux 2.6.29 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

The diffstats looks big but that's almost only defconfig updates to
reflect the change of symbol names for eeprom drivers. Also worth
noting are the warnings when using the deprecated i2c binding model.
Apparently the remaining drivers will never get updated without that.

 MAINTAINERS                                       |    3 +-
 arch/arm/configs/afeb9260_defconfig               |    6 +-
 arch/arm/configs/ams_delta_defconfig              |    2 +-
 arch/arm/configs/at91cap9adk_defconfig            |    4 +-
 arch/arm/configs/at91rm9200dk_defconfig           |    2 +-
 arch/arm/configs/at91rm9200ek_defconfig           |    2 +-
 arch/arm/configs/at91sam9260ek_defconfig          |    2 +-
 arch/arm/configs/at91sam9261ek_defconfig          |    4 +-
 arch/arm/configs/at91sam9263ek_defconfig          |    4 +-
 arch/arm/configs/at91sam9g20ek_defconfig          |    2 +-
 arch/arm/configs/at91sam9rlek_defconfig           |    4 +-
 arch/arm/configs/ateb9200_defconfig               |    2 +-
 arch/arm/configs/badge4_defconfig                 |    2 +-
 arch/arm/configs/cam60_defconfig                  |    4 +-
 arch/arm/configs/cm_x300_defconfig                |    4 +-
 arch/arm/configs/colibri_defconfig                |    2 +-
 arch/arm/configs/corgi_defconfig                  |    6 +-
 arch/arm/configs/csb337_defconfig                 |    2 +-
 arch/arm/configs/csb637_defconfig                 |    2 +-
 arch/arm/configs/ecbat91_defconfig                |    4 +-
 arch/arm/configs/ep93xx_defconfig                 |    2 +-
 arch/arm/configs/ezx_defconfig                    |    4 +-
 arch/arm/configs/footbridge_defconfig             |    2 +-
 arch/arm/configs/iop13xx_defconfig                |    2 +-
 arch/arm/configs/iop32x_defconfig                 |    2 +-
 arch/arm/configs/iop33x_defconfig                 |    2 +-
 arch/arm/configs/ixp2000_defconfig                |    2 +-
 arch/arm/configs/ixp23xx_defconfig                |    2 +-
 arch/arm/configs/ixp4xx_defconfig                 |    2 +-
 arch/arm/configs/kafa_defconfig                   |    2 +-
 arch/arm/configs/kirkwood_defconfig               |    6 +-
 arch/arm/configs/loki_defconfig                   |    4 +-
 arch/arm/configs/magician_defconfig               |    2 +-
 arch/arm/configs/msm_defconfig                    |    2 +-
 arch/arm/configs/mv78xx0_defconfig                |    2 +-
 arch/arm/configs/n770_defconfig                   |    4 +-
 arch/arm/configs/neocore926_defconfig             |    6 +-
 arch/arm/configs/neponset_defconfig               |    2 +-
 arch/arm/configs/omap3_beagle_defconfig           |    4 +-
 arch/arm/configs/omap3_pandora_defconfig          |    6 +-
 arch/arm/configs/omap_2430sdp_defconfig           |    4 +-
 arch/arm/configs/omap_apollon_2420_defconfig      |    2 +-
 arch/arm/configs/omap_generic_1510_defconfig      |    2 +-
 arch/arm/configs/omap_generic_1610_defconfig      |    2 +-
 arch/arm/configs/omap_h2_1610_defconfig           |    4 +-
 arch/arm/configs/omap_h4_2420_defconfig           |    2 +-
 arch/arm/configs/omap_innovator_1510_defconfig    |    2 +-
 arch/arm/configs/omap_ldp_defconfig               |    6 +-
 arch/arm/configs/omap_osk_5912_defconfig          |    2 +-
 arch/arm/configs/onearm_defconfig                 |    2 +-
 arch/arm/configs/orion5x_defconfig                |    4 +-
 arch/arm/configs/overo_defconfig                  |    6 +-
 arch/arm/configs/palmz71_defconfig                |    2 +-
 arch/arm/configs/palmz72_defconfig                |    6 +-
 arch/arm/configs/pcm027_defconfig                 |    2 +-
 arch/arm/configs/pcm038_defconfig                 |    4 +-
 arch/arm/configs/picotux200_defconfig             |    2 +-
 arch/arm/configs/pnx4008_defconfig                |    2 +-
 arch/arm/configs/qil-a9260_defconfig              |    4 +-
 arch/arm/configs/rpc_defconfig                    |    2 +-
 arch/arm/configs/s3c2410_defconfig                |    4 +-
 arch/arm/configs/s3c6400_defconfig                |    4 +-
 arch/arm/configs/spitz_defconfig                  |    6 +-
 arch/arm/configs/sx1_defconfig                    |    2 +-
 arch/arm/configs/trizeps4_defconfig               |    2 +-
 arch/arm/configs/usb-a9260_defconfig              |    2 +-
 arch/arm/configs/usb-a9263_defconfig              |    2 +-
 arch/arm/configs/versatile_defconfig              |    2 +-
 arch/arm/configs/viper_defconfig                  |    4 +-
 arch/arm/configs/xm_x2xx_defconfig                |    4 +-
 arch/arm/configs/yl9200_defconfig                 |    2 +-
 arch/avr32/configs/atngw100_defconfig             |    6 +-
 arch/avr32/configs/atngw100_evklcd100_defconfig   |    4 +-
 arch/avr32/configs/atngw100_evklcd101_defconfig   |    4 +-
 arch/avr32/configs/atstk1002_defconfig            |    6 +-
 arch/avr32/configs/atstk1003_defconfig            |    6 +-
 arch/avr32/configs/atstk1004_defconfig            |    2 +-
 arch/avr32/configs/atstk1006_defconfig            |    6 +-
 arch/avr32/configs/favr-32_defconfig              |    6 +-
 arch/avr32/configs/hammerhead_defconfig           |    6 +-
 arch/avr32/configs/mimc200_defconfig              |    6 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    4 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    6 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    6 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    6 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |    6 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    6 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    6 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BlackStamp_defconfig        |    4 +-
 arch/blackfin/configs/CM-BF527_defconfig          |    4 +-
 arch/blackfin/configs/CM-BF548_defconfig          |    4 +-
 arch/blackfin/configs/H8606_defconfig             |    2 +-
 arch/blackfin/configs/IP0X_defconfig              |    2 +-
 arch/blackfin/configs/PNAV-10_defconfig           |    6 +-
 arch/blackfin/configs/SRV1_defconfig              |    4 +-
 arch/blackfin/configs/TCM-BF537_defconfig         |    2 +-
 arch/ia64/configs/bigsur_defconfig                |    2 +-
 arch/ia64/configs/zx1_defconfig                   |    2 +-
 arch/m32r/configs/m32104ut_defconfig              |    2 +-
 arch/mips/configs/bigsur_defconfig                |    2 +-
 arch/mips/configs/emma2rh_defconfig               |    2 +-
 arch/mips/configs/fulong_defconfig                |    4 +-
 arch/mips/configs/msp71xx_defconfig               |    2 +-
 arch/mips/configs/mtx1_defconfig                  |    4 +-
 arch/mips/configs/pnx8335-stb225_defconfig        |    4 +-
 arch/mips/configs/rbtx49xx_defconfig              |    2 +-
 arch/powerpc/configs/44x/sam440ep_defconfig       |    4 +-
 arch/powerpc/configs/44x/warp_defconfig           |    4 +-
 arch/powerpc/configs/52xx/cm5200_defconfig        |    4 +-
 arch/powerpc/configs/52xx/lite5200b_defconfig     |    4 +-
 arch/powerpc/configs/52xx/motionpro_defconfig     |    4 +-
 arch/powerpc/configs/52xx/pcm030_defconfig        |    4 +-
 arch/powerpc/configs/52xx/tqm5200_defconfig       |    4 +-
 arch/powerpc/configs/83xx/asp8347_defconfig       |    4 +-
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |    6 +-
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |    6 +-
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |    4 +-
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |    6 +-
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |    6 +-
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |    6 +-
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |    4 +-
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |    4 +-
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |    6 +-
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |    4 +-
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |    4 +-
 arch/powerpc/configs/83xx/sbc834x_defconfig       |    4 +-
 arch/powerpc/configs/85xx/mpc8536_ds_defconfig    |    4 +-
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig    |    4 +-
 arch/powerpc/configs/85xx/mpc8568mds_defconfig    |    4 +-
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig    |    4 +-
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |    4 +-
 arch/powerpc/configs/85xx/tqm8540_defconfig       |    4 +-
 arch/powerpc/configs/85xx/tqm8541_defconfig       |    4 +-
 arch/powerpc/configs/85xx/tqm8548_defconfig       |    4 +-
 arch/powerpc/configs/85xx/tqm8555_defconfig       |    4 +-
 arch/powerpc/configs/85xx/tqm8560_defconfig       |    4 +-
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |    4 +-
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |    4 +-
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |    4 +-
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |    4 +-
 arch/powerpc/configs/c2k_defconfig                |    4 +-
 arch/powerpc/configs/cell_defconfig               |    2 +-
 arch/powerpc/configs/celleb_defconfig             |    2 +-
 arch/powerpc/configs/chrp32_defconfig             |    4 +-
 arch/powerpc/configs/g5_defconfig                 |    4 +-
 arch/powerpc/configs/linkstation_defconfig        |    4 +-
 arch/powerpc/configs/maple_defconfig              |    4 +-
 arch/powerpc/configs/mpc5200_defconfig            |    4 +-
 arch/powerpc/configs/mpc83xx_defconfig            |    4 +-
 arch/powerpc/configs/mpc85xx_defconfig            |    4 +-
 arch/powerpc/configs/mpc86xx_defconfig            |    4 +-
 arch/powerpc/configs/pasemi_defconfig             |    2 +-
 arch/powerpc/configs/pmac32_defconfig             |    4 +-
 arch/powerpc/configs/ppc40x_defconfig             |    4 +-
 arch/powerpc/configs/ppc44x_defconfig             |    4 +-
 arch/powerpc/configs/ppc64_defconfig              |    4 +-
 arch/powerpc/configs/ppc6xx_defconfig             |    4 +-
 arch/powerpc/configs/prpmc2800_defconfig          |    4 +-
 arch/powerpc/configs/pseries_defconfig            |    4 +-
 arch/powerpc/configs/storcenter_defconfig         |    4 +-
 arch/sh/configs/cayman_defconfig                  |    4 +-
 arch/sh/configs/edosk7760_defconfig               |    4 +-
 arch/sh/configs/migor_defconfig                   |    4 +-
 arch/sh/configs/r7780mp_defconfig                 |    4 +-
 arch/sh/configs/r7785rp_defconfig                 |    4 +-
 arch/sh/configs/rts7751r2d1_defconfig             |    2 +-
 arch/sh/configs/rts7751r2dplus_defconfig          |    2 +-
 arch/sh/configs/se7343_defconfig                  |    4 +-
 arch/sh/configs/sh7785lcr_defconfig               |    4 +-
 arch/sh/configs/shx3_defconfig                    |    6 +-
 arch/sparc/configs/sparc64_defconfig              |    4 +-
 arch/x86/configs/i386_defconfig                   |    4 +-
 arch/x86/configs/x86_64_defconfig                 |    4 +-
 drivers/gpu/drm/i915/intel_i2c.c                  |    4 --
 drivers/i2c/busses/i2c-acorn.c                    |    1 -
 drivers/i2c/busses/i2c-ali1535.c                  |    1 -
 drivers/i2c/busses/i2c-ali1563.c                  |    1 -
 drivers/i2c/busses/i2c-ali15x3.c                  |    1 -
 drivers/i2c/busses/i2c-amd756.c                   |    1 -
 drivers/i2c/busses/i2c-amd8111.c                  |    1 -
 drivers/i2c/busses/i2c-au1550.c                   |    1 -
 drivers/i2c/busses/i2c-bfin-twi.c                 |    1 -
 drivers/i2c/busses/i2c-elektor.c                  |    1 -
 drivers/i2c/busses/i2c-hydra.c                    |    1 -
 drivers/i2c/busses/i2c-i801.c                     |    1 -
 drivers/i2c/busses/i2c-ibm_iic.c                  |    1 -
 drivers/i2c/busses/i2c-iop3xx.c                   |    1 -
 drivers/i2c/busses/i2c-ixp2000.c                  |    1 -
 drivers/i2c/busses/i2c-mpc.c                      |    1 -
 drivers/i2c/busses/i2c-mv64xxx.c                  |    1 -
 drivers/i2c/busses/i2c-nforce2.c                  |    1 -
 drivers/i2c/busses/i2c-parport-light.c            |    1 -
 drivers/i2c/busses/i2c-parport.c                  |    1 -
 drivers/i2c/busses/i2c-pca-isa.c                  |    1 -
 drivers/i2c/busses/i2c-piix4.c                    |    1 -
 drivers/i2c/busses/i2c-sibyte.c                   |    2 -
 drivers/i2c/busses/i2c-sis5595.c                  |    1 -
 drivers/i2c/busses/i2c-sis630.c                   |    1 -
 drivers/i2c/busses/i2c-sis96x.c                   |    1 -
 drivers/i2c/busses/i2c-via.c                      |    1 -
 drivers/i2c/busses/i2c-viapro.c                   |    1 -
 drivers/i2c/busses/i2c-voodoo3.c                  |    2 -
 drivers/i2c/busses/scx200_acb.c                   |    1 -
 drivers/i2c/busses/scx200_i2c.c                   |    1 -
 drivers/i2c/chips/Kconfig                         |   37 -------------
 drivers/i2c/chips/Makefile                        |    2 -
 drivers/ieee1394/pcilynx.c                        |    1 -
 drivers/misc/Kconfig                              |    9 +---
 drivers/misc/Makefile                             |    2 +-
 drivers/misc/eeprom/Kconfig                       |   59 ++++++++++++++++++++
 drivers/misc/eeprom/Makefile                      |    4 ++
 drivers/{i2c/chips => misc/eeprom}/at24.c         |    0 
 drivers/{spi => misc/eeprom}/at25.c               |    0 
 drivers/{i2c/chips => misc/eeprom}/eeprom.c       |    0 
 drivers/misc/{ => eeprom}/eeprom_93cx6.c          |    0 
 drivers/spi/Kconfig                               |   11 ----
 drivers/spi/Makefile                              |    1 -
 drivers/video/aty/radeon_i2c.c                    |    1 -
 drivers/video/i810/i810-i2c.c                     |    1 -
 drivers/video/intelfb/intelfb_i2c.c               |    1 -
 drivers/video/nvidia/nv_i2c.c                     |    1 -
 drivers/video/savage/savagefb-i2c.c               |    1 -
 include/linux/i2c-id.h                            |   61 ---------------------
 include/linux/i2c.h                               |    8 ++-
 226 files changed, 391 insertions(+), 486 deletions(-)
 create mode 100644 drivers/misc/eeprom/Kconfig
 create mode 100644 drivers/misc/eeprom/Makefile
 rename drivers/{i2c/chips => misc/eeprom}/at24.c (100%)
 rename drivers/{spi => misc/eeprom}/at25.c (100%)
 rename drivers/{i2c/chips => misc/eeprom}/eeprom.c (100%)
 rename drivers/misc/{ => eeprom}/eeprom_93cx6.c (100%)

---------------

Jean Delvare (5):
      i2c: Delete 10 unused driver IDs
      i2c: Delete many unused adapter IDs
      i2c: Quilt tree has moved
      eeprom: More consistent symbol names
      i2c: Warn on deprecated binding model use

Wolfram Sang (4):
      i2c: Move at24 to drivers/misc/eeprom
      i2c: Move old eeprom driver to /drivers/misc/eeprom
      spi: Move at25 (for SPI eeproms) to /drivers/misc/eeprom
      eeprom: Move 93cx6 eeprom driver to /drivers/misc/eeprom

Thanks,
-- 
Jean Delvare
