Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbYDTLD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbYDTLD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 07:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYDTLDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 07:03:15 -0400
Received: from ozlabs.org ([203.10.76.45]:41982 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYDTLDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 07:03:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Message-ID: <18443.8932.942979.982105@cargo.ozlabs.ibm.com>
Date: Sun, 20 Apr 2008 21:03:00 +1000
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Please pull powerpc.git master branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git master

to get a powerpc update.

Thanks,
Paul.

 Documentation/kernel-parameters.txt               |    2 
 Documentation/powerpc/booting-without-of.txt      |  622 +++++++++++++-
 Documentation/powerpc/phyp-assisted-dump.txt      |  127 +++
 arch/powerpc/Kconfig                              |   82 +-
 arch/powerpc/Kconfig.debug                        |    2 
 arch/powerpc/Makefile                             |   12 
 arch/powerpc/boot/Makefile                        |   40 +
 arch/powerpc/boot/bamboo.c                        |    3 
 arch/powerpc/boot/cpm-serial.c                    |  117 ++-
 arch/powerpc/boot/cuboot-pq2.c                    |   27 -
 arch/powerpc/boot/cuboot-rainier.c                |    3 
 arch/powerpc/boot/cuboot-sequoia.c                |    3 
 arch/powerpc/boot/cuboot-taishan.c                |    3 
 arch/powerpc/boot/cuboot-warp.c                   |    2 
 arch/powerpc/boot/cuboot-yosemite.c               |   44 +
 arch/powerpc/boot/devtree.c                       |   20 
 arch/powerpc/boot/dts/bamboo.dts                  |    2 
 arch/powerpc/boot/dts/canyonlands.dts             |  402 +++++++++
 arch/powerpc/boot/dts/ebony.dts                   |    2 
 arch/powerpc/boot/dts/ep8248e.dts                 |    5 
 arch/powerpc/boot/dts/ep88xc.dts                  |   73 +-
 arch/powerpc/boot/dts/glacier.dts                 |  467 ++++++++++
 arch/powerpc/boot/dts/haleakala.dts               |    4 
 arch/powerpc/boot/dts/katmai.dts                  |    2 
 arch/powerpc/boot/dts/kilauea.dts                 |    4 
 arch/powerpc/boot/dts/ksi8560.dts                 |  267 ++++++
 arch/powerpc/boot/dts/kuroboxHD.dts               |   83 +-
 arch/powerpc/boot/dts/kuroboxHG.dts               |   83 +-
 arch/powerpc/boot/dts/makalu.dts                  |    4 
 arch/powerpc/boot/dts/mpc7448hpc2.dts             |   97 +-
 arch/powerpc/boot/dts/mpc8272ads.dts              |  132 ++-
 arch/powerpc/boot/dts/mpc832x_mds.dts             |    7 
 arch/powerpc/boot/dts/mpc832x_rdb.dts             |    4 
 arch/powerpc/boot/dts/mpc836x_mds.dts             |    4 
 arch/powerpc/boot/dts/mpc8540ads.dts              |  173 ++--
 arch/powerpc/boot/dts/mpc8541cds.dts              |  161 ++--
 arch/powerpc/boot/dts/mpc8544ds.dts               |  299 ++++---
 arch/powerpc/boot/dts/mpc8548cds.dts              |  289 +++---
 arch/powerpc/boot/dts/mpc8555cds.dts              |  161 ++--
 arch/powerpc/boot/dts/mpc8560ads.dts              |  209 ++---
 arch/powerpc/boot/dts/mpc8568mds.dts              |  291 +++----
 arch/powerpc/boot/dts/mpc8572ds.dts               |  383 ++++-----
 arch/powerpc/boot/dts/mpc8641_hpcn.dts            |    2 
 arch/powerpc/boot/dts/mpc866ads.dts               |   58 +
 arch/powerpc/boot/dts/mpc885ads.dts               |   77 +-
 arch/powerpc/boot/dts/pq2fads.dts                 |  126 +--
 arch/powerpc/boot/dts/prpmc2800.dts               |  336 ++++----
 arch/powerpc/boot/dts/rainier.dts                 |    6 
 arch/powerpc/boot/dts/sbc8641d.dts                |  352 ++++++++
 arch/powerpc/boot/dts/sequoia.dts                 |    6 
 arch/powerpc/boot/dts/taishan.dts                 |   31 +
 arch/powerpc/boot/dts/walnut.dts                  |    1 
 arch/powerpc/boot/dts/warp.dts                    |    1 
 arch/powerpc/boot/dts/yosemite.dts                |  304 +++++++
 arch/powerpc/boot/ebony.c                         |    3 
 arch/powerpc/boot/libfdt-wrapper.c                |    2 
 arch/powerpc/boot/mpc52xx-psc.c                   |    9 
 arch/powerpc/boot/mpsc.c                          |    2 
 arch/powerpc/boot/mv64x60.c                       |    4 
 arch/powerpc/boot/mv64x60_i2c.c                   |    2 
 arch/powerpc/boot/ns16550.c                       |   10 
 arch/powerpc/boot/ops.h                           |    1 
 arch/powerpc/boot/prpmc2800.c                     |   23 -
 arch/powerpc/boot/ps3-head.S                      |   25 -
 arch/powerpc/boot/ps3.c                           |   23 -
 arch/powerpc/boot/serial.c                        |    2 
 arch/powerpc/boot/simpleboot.c                    |   84 ++
 arch/powerpc/boot/treeboot-walnut.c               |    2 
 arch/powerpc/boot/virtex405-head.S                |   30 +
 arch/powerpc/boot/wrapper                         |   32 -
 arch/powerpc/configs/40x/ep405_defconfig          |    0 
 arch/powerpc/configs/40x/kilauea_defconfig        |    0 
 arch/powerpc/configs/40x/makalu_defconfig         |    0 
 arch/powerpc/configs/40x/walnut_defconfig         |    0 
 arch/powerpc/configs/44x/bamboo_defconfig         |    0 
 arch/powerpc/configs/44x/canyonlands_defconfig    |  138 ---
 arch/powerpc/configs/44x/ebony_defconfig          |    0 
 arch/powerpc/configs/44x/katmai_defconfig         |    0 
 arch/powerpc/configs/44x/rainier_defconfig        |    0 
 arch/powerpc/configs/44x/sequoia_defconfig        |    0 
 arch/powerpc/configs/44x/taishan_defconfig        |    0 
 arch/powerpc/configs/44x/warp_defconfig           |    0 
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |    8 
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |    0 
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |    0 
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |    0 
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |    0 
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |    0 
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |    0 
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |    0 
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |    0 
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |    0 
 arch/powerpc/configs/83xx/sbc834x_defconfig       |    0 
 arch/powerpc/configs/85xx/ksi8560_defconfig       |  250 +++---
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |    0 
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig    |   17 
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |    0 
 arch/powerpc/configs/85xx/mpc8568mds_defconfig    |    0 
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig    |    0 
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |    0 
 arch/powerpc/configs/85xx/sbc8548_defconfig       |    0 
 arch/powerpc/configs/85xx/sbc8560_defconfig       |    0 
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |    0 
 arch/powerpc/configs/85xx/tqm8540_defconfig       |    0 
 arch/powerpc/configs/85xx/tqm8541_defconfig       |    0 
 arch/powerpc/configs/85xx/tqm8555_defconfig       |    0 
 arch/powerpc/configs/85xx/tqm8560_defconfig       |    0 
 arch/powerpc/configs/chrp32_defconfig             |    7 
 arch/powerpc/configs/g5_defconfig                 |    7 
 arch/powerpc/configs/iseries_defconfig            |    7 
 arch/powerpc/configs/maple_defconfig              |  131 +++
 arch/powerpc/configs/mpc83xx_defconfig            |  164 ++++
 arch/powerpc/configs/pmac32_defconfig             |    7 
 arch/powerpc/configs/ppc40x_defconfig             |   31 -
 arch/powerpc/configs/ppc44x_defconfig             |   14 
 arch/powerpc/configs/ppc64_defconfig              |    8 
 arch/powerpc/configs/pseries_defconfig            |    8 
 arch/powerpc/configs/sbc8641d_defconfig           |  937 +++++++++++----------
 arch/powerpc/kernel/Makefile                      |    1 
 arch/powerpc/kernel/asm-offsets.c                 |   10 
 arch/powerpc/kernel/btext.c                       |    3 
 arch/powerpc/kernel/cpu_setup_44x.S               |    5 
 arch/powerpc/kernel/cputable.c                    |   28 +
 arch/powerpc/kernel/crash.c                       |    3 
 arch/powerpc/kernel/crash_dump.c                  |    3 
 arch/powerpc/kernel/entry_32.S                    |   30 -
 arch/powerpc/kernel/entry_64.S                    |   30 +
 arch/powerpc/kernel/head_32.S                     |   22 
 arch/powerpc/kernel/head_44x.S                    |    4 
 arch/powerpc/kernel/head_64.S                     |   69 +-
 arch/powerpc/kernel/head_booke.h                  |   33 -
 arch/powerpc/kernel/head_fsl_booke.S              |   44 +
 arch/powerpc/kernel/ibmebus.c                     |   12 
 arch/powerpc/kernel/iommu.c                       |    4 
 arch/powerpc/kernel/irq.c                         |   18 
 arch/powerpc/kernel/isa-bridge.c                  |    6 
 arch/powerpc/kernel/lparcfg.c                     |   12 
 arch/powerpc/kernel/machine_kexec.c               |    3 
 arch/powerpc/kernel/paca.c                        |   34 -
 arch/powerpc/kernel/ppc32.h                       |    2 
 arch/powerpc/kernel/ppc_ksyms.c                   |    7 
 arch/powerpc/kernel/process.c                     |   33 -
 arch/powerpc/kernel/prom.c                        |  120 ++-
 arch/powerpc/kernel/prom_init.c                   |    8 
 arch/powerpc/kernel/ptrace32.c                    |   27 +
 arch/powerpc/kernel/rtas.c                        |    4 
 arch/powerpc/kernel/rtas_flash.c                  |    2 
 arch/powerpc/kernel/rtas_pci.c                    |   29 -
 arch/powerpc/kernel/setup-common.c                |   11 
 arch/powerpc/kernel/setup_32.c                    |   14 
 arch/powerpc/kernel/setup_64.c                    |    8 
 arch/powerpc/kernel/signal_32.c                   |   19 
 arch/powerpc/kernel/stacktrace.c                  |   47 +
 arch/powerpc/kernel/sys_ppc32.c                   |    5 
 arch/powerpc/kernel/vdso.c                        |    3 
 arch/powerpc/kernel/vio.c                         |   10 
 arch/powerpc/kernel/vmlinux.lds.S                 |   51 +
 arch/powerpc/lib/rheap.c                          |    4 
 arch/powerpc/lib/string.S                         |   14 
 arch/powerpc/math-emu/fabs.c                      |    2 
 arch/powerpc/math-emu/fadd.c                      |    2 
 arch/powerpc/math-emu/fadds.c                     |    2 
 arch/powerpc/math-emu/fcmpo.c                     |    2 
 arch/powerpc/math-emu/fcmpu.c                     |    2 
 arch/powerpc/math-emu/fctiw.c                     |    2 
 arch/powerpc/math-emu/fctiwz.c                    |    2 
 arch/powerpc/math-emu/fdiv.c                      |    6 
 arch/powerpc/math-emu/fdivs.c                     |    6 
 arch/powerpc/math-emu/fmadd.c                     |    2 
 arch/powerpc/math-emu/fmadds.c                    |    2 
 arch/powerpc/math-emu/fmr.c                       |    2 
 arch/powerpc/math-emu/fmsub.c                     |    2 
 arch/powerpc/math-emu/fmsubs.c                    |    2 
 arch/powerpc/math-emu/fmul.c                      |    2 
 arch/powerpc/math-emu/fmuls.c                     |    2 
 arch/powerpc/math-emu/fnabs.c                     |    2 
 arch/powerpc/math-emu/fneg.c                      |    2 
 arch/powerpc/math-emu/fnmadd.c                    |    2 
 arch/powerpc/math-emu/fnmadds.c                   |    2 
 arch/powerpc/math-emu/fnmsub.c                    |    2 
 arch/powerpc/math-emu/fnmsubs.c                   |    2 
 arch/powerpc/math-emu/fres.c                      |    2 
 arch/powerpc/math-emu/frsp.c                      |    2 
 arch/powerpc/math-emu/frsqrte.c                   |    2 
 arch/powerpc/math-emu/fsel.c                      |    2 
 arch/powerpc/math-emu/fsqrt.c                     |    2 
 arch/powerpc/math-emu/fsqrts.c                    |    2 
 arch/powerpc/math-emu/fsub.c                      |    2 
 arch/powerpc/math-emu/fsubs.c                     |    2 
 arch/powerpc/math-emu/lfd.c                       |    2 
 arch/powerpc/math-emu/lfs.c                       |    2 
 arch/powerpc/math-emu/mcrfs.c                     |    4 
 arch/powerpc/math-emu/mffs.c                      |    2 
 arch/powerpc/math-emu/mtfsb0.c                    |    2 
 arch/powerpc/math-emu/mtfsb1.c                    |    2 
 arch/powerpc/math-emu/mtfsf.c                     |    2 
 arch/powerpc/math-emu/mtfsfi.c                    |    2 
 arch/powerpc/math-emu/stfd.c                      |    2 
 arch/powerpc/math-emu/stfiwx.c                    |    2 
 arch/powerpc/math-emu/stfs.c                      |    2 
 arch/powerpc/mm/40x_mmu.c                         |    2 
 arch/powerpc/mm/44x_mmu.c                         |    2 
 arch/powerpc/mm/Makefile                          |    2 
 arch/powerpc/mm/fsl_booke_mmu.c                   |   48 -
 arch/powerpc/mm/hash_utils_64.c                   |   32 +
 arch/powerpc/mm/init_32.c                         |   27 -
 arch/powerpc/mm/init_64.c                         |    7 
 arch/powerpc/mm/lmb.c                             |  357 --------
 arch/powerpc/mm/mem.c                             |   21 
 arch/powerpc/mm/mmu_decl.h                        |    4 
 arch/powerpc/mm/numa.c                            |    3 
 arch/powerpc/mm/pgtable_32.c                      |    5 
 arch/powerpc/mm/ppc_mmu_32.c                      |   15 
 arch/powerpc/mm/stab.c                            |    4 
 arch/powerpc/oprofile/cell/spu_task_sync.c        |   12 
 arch/powerpc/oprofile/cell/vma_map.c              |   10 
 arch/powerpc/oprofile/op_model_cell.c             |   14 
 arch/powerpc/platforms/40x/ep405.c                |    2 
 arch/powerpc/platforms/40x/kilauea.c              |    4 
 arch/powerpc/platforms/40x/makalu.c               |    2 
 arch/powerpc/platforms/40x/virtex.c               |    2 
 arch/powerpc/platforms/40x/walnut.c               |    4 
 arch/powerpc/platforms/44x/44x.h                  |    1 
 arch/powerpc/platforms/44x/Kconfig                |   27 +
 arch/powerpc/platforms/44x/Makefile               |    4 
 arch/powerpc/platforms/44x/bamboo.c               |   15 
 arch/powerpc/platforms/44x/canyonlands.c          |   63 +
 arch/powerpc/platforms/44x/ebony.c                |    5 
 arch/powerpc/platforms/44x/idle.c                 |   67 ++
 arch/powerpc/platforms/44x/katmai.c               |    5 
 arch/powerpc/platforms/44x/misc_44x.S             |   11 
 arch/powerpc/platforms/44x/rainier.c              |    4 
 arch/powerpc/platforms/44x/sequoia.c              |    4 
 arch/powerpc/platforms/44x/taishan.c              |    5 
 arch/powerpc/platforms/44x/warp-nand.c            |    3 
 arch/powerpc/platforms/44x/warp.c                 |    6 
 arch/powerpc/platforms/52xx/lite5200.c            |    4 
 arch/powerpc/platforms/82xx/Kconfig               |    3 
 arch/powerpc/platforms/83xx/mpc837x_rdb.c         |    1 
 arch/powerpc/platforms/83xx/mpc83xx.h             |    2 
 arch/powerpc/platforms/83xx/usb.c                 |   12 
 arch/powerpc/platforms/85xx/Kconfig               |   13 
 arch/powerpc/platforms/85xx/Makefile              |    1 
 arch/powerpc/platforms/85xx/ksi8560.c             |  257 ++++++
 arch/powerpc/platforms/85xx/mpc85xx_ads.c         |    2 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |   15 
 arch/powerpc/platforms/86xx/Kconfig               |    8 
 arch/powerpc/platforms/86xx/Makefile              |    1 
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c        |    4 
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c        |   14 
 arch/powerpc/platforms/86xx/sbc8641d.c            |  164 ++++
 arch/powerpc/platforms/8xx/Kconfig                |    4 
 arch/powerpc/platforms/8xx/m8xx_setup.c           |    7 
 arch/powerpc/platforms/Kconfig                    |    8 
 arch/powerpc/platforms/Kconfig.cputype            |    2 
 arch/powerpc/platforms/cell/iommu.c               |   10 
 arch/powerpc/platforms/cell/pervasive.c           |    2 
 arch/powerpc/platforms/cell/ras.c                 |   10 
 arch/powerpc/platforms/cell/spu_base.c            |    8 
 arch/powerpc/platforms/cell/spu_callbacks.c       |    2 
 arch/powerpc/platforms/cell/spu_manage.c          |    8 
 arch/powerpc/platforms/cell/spufs/coredump.c      |    8 
 arch/powerpc/platforms/cell/spufs/file.c          |    8 
 arch/powerpc/platforms/cell/spufs/run.c           |   14 
 arch/powerpc/platforms/cell/spufs/switch.c        |    2 
 arch/powerpc/platforms/celleb/beat.c              |   17 
 arch/powerpc/platforms/celleb/beat.h              |    4 
 arch/powerpc/platforms/celleb/beat_wrapper.h      |    3 
 arch/powerpc/platforms/celleb/htab.c              |    7 
 arch/powerpc/platforms/celleb/interrupt.c         |   26 -
 arch/powerpc/platforms/celleb/scc_epci.c          |    8 
 arch/powerpc/platforms/celleb/scc_sio.c           |    4 
 arch/powerpc/platforms/celleb/spu_priv1.c         |    3 
 arch/powerpc/platforms/celleb/udbg_beat.c         |    5 
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |   10 
 arch/powerpc/platforms/embedded6xx/prpmc2800.c    |    4 
 arch/powerpc/platforms/iseries/exception.S        |   12 
 arch/powerpc/platforms/iseries/ipl_parms.h        |    2 
 arch/powerpc/platforms/iseries/lpardata.c         |  121 ++-
 arch/powerpc/platforms/iseries/naca.h             |    2 
 arch/powerpc/platforms/iseries/pci.c              |    3 
 arch/powerpc/platforms/iseries/release_data.h     |    2 
 arch/powerpc/platforms/iseries/spcomm_area.h      |    2 
 arch/powerpc/platforms/iseries/vpd_areas.h        |    4 
 arch/powerpc/platforms/maple/pci.c                |   47 -
 arch/powerpc/platforms/maple/setup.c              |    4 
 arch/powerpc/platforms/pasemi/dma_lib.c           |  144 +++
 arch/powerpc/platforms/pasemi/iommu.c             |   19 
 arch/powerpc/platforms/powermac/setup.c           |    2 
 arch/powerpc/platforms/ps3/device-init.c          |   78 +-
 arch/powerpc/platforms/ps3/htab.c                 |    3 
 arch/powerpc/platforms/ps3/interrupt.c            |    2 
 arch/powerpc/platforms/ps3/mm.c                   |    3 
 arch/powerpc/platforms/ps3/os-area.c              |    3 
 arch/powerpc/platforms/ps3/setup.c                |   14 
 arch/powerpc/platforms/ps3/spu.c                  |    7 
 arch/powerpc/platforms/pseries/Makefile           |    1 
 arch/powerpc/platforms/pseries/eeh.c              |    5 
 arch/powerpc/platforms/pseries/lpar.c             |   25 -
 arch/powerpc/platforms/pseries/pci_dlpar.c        |    2 
 arch/powerpc/platforms/pseries/phyp_dump.c        |  507 +++++++++++
 arch/powerpc/platforms/pseries/pseries.h          |    2 
 arch/powerpc/platforms/pseries/reconfig.c         |   12 
 arch/powerpc/platforms/pseries/scanlog.c          |   37 -
 arch/powerpc/platforms/pseries/setup.c            |  105 +-
 arch/powerpc/platforms/pseries/xics.c             |   87 --
 arch/powerpc/platforms/pseries/xics.h             |    3 
 arch/powerpc/sysdev/Makefile                      |    2 
 arch/powerpc/sysdev/cpm1.c                        |  114 ---
 arch/powerpc/sysdev/cpm2.c                        |  105 --
 arch/powerpc/sysdev/cpm_common.c                  |    3 
 arch/powerpc/sysdev/dart_iommu.c                  |    2 
 arch/powerpc/sysdev/fsl_lbc.c                     |  129 +++
 arch/powerpc/sysdev/fsl_soc.c                     |  611 +-------------
 arch/powerpc/sysdev/fsl_soc.h                     |    1 
 arch/powerpc/sysdev/mpic.c                        |   41 -
 arch/powerpc/sysdev/mv64x60_dev.c                 |   78 +-
 arch/powerpc/sysdev/mv64x60_pci.c                 |    6 
 arch/powerpc/sysdev/mv64x60_pic.c                 |    4 
 arch/powerpc/sysdev/mv64x60_udbg.c                |    2 
 arch/powerpc/sysdev/ppc4xx_pci.c                  |  133 +++
 arch/powerpc/sysdev/ppc4xx_pci.h                  |   59 +
 arch/powerpc/sysdev/ppc4xx_soc.c                  |  200 ++++
 arch/powerpc/sysdev/qe_lib/qe.c                   |   13 
 arch/powerpc/sysdev/qe_lib/qe_io.c                |    7 
 arch/powerpc/sysdev/qe_lib/ucc_fast.c             |   32 -
 arch/powerpc/sysdev/qe_lib/ucc_slow.c             |   18 
 arch/powerpc/sysdev/rtc_cmos_setup.c              |    2 
 arch/powerpc/sysdev/tsi108_dev.c                  |    4 
 arch/powerpc/sysdev/tsi108_pci.c                  |    4 
 arch/powerpc/xmon/xmon.c                          |   24 -
 arch/ppc/8xx_io/commproc.c                        |    2 
 arch/ppc/8xx_io/fec.c                             |    4 
 arch/ppc/kernel/head.S                            |   17 
 arch/ppc/mm/init.c                                |    1 
 arch/ppc/platforms/radstone_ppc7d.c               |    8 
 arch/ppc/syslib/mpc52xx_setup.c                   |    2 
 arch/sparc64/Kconfig                              |    1 
 drivers/block/viodasd.c                           |    2 
 drivers/char/hvc_beat.c                           |    4 
 drivers/char/xilinx_hwicap/buffer_icap.c          |   22 
 drivers/char/xilinx_hwicap/buffer_icap.h          |    5 
 drivers/char/xilinx_hwicap/fifo_icap.c            |   31 +
 drivers/char/xilinx_hwicap/fifo_icap.h            |    1 
 drivers/char/xilinx_hwicap/xilinx_hwicap.c        |   63 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.h        |   24 +
 drivers/mtd/nand/fsl_elbc_nand.c                  |  219 -----
 drivers/net/Makefile                              |    3 
 drivers/net/iseries_veth.c                        |    3 
 drivers/net/pasemi_mac.c                          |  355 +++++++-
 drivers/net/pasemi_mac.h                          |   35 +
 drivers/net/pasemi_mac_ethtool.c                  |  159 ++++
 drivers/net/ps3_gelic_net.c                       |   81 ++
 drivers/net/ps3_gelic_net.h                       |   20 
 drivers/net/ucc_geth.c                            |    8 
 drivers/net/ucc_geth_mii.c                        |   11 
 drivers/of/Kconfig                                |   12 
 drivers/of/Makefile                               |    2 
 drivers/of/base.c                                 |   26 +
 drivers/of/gpio.c                                 |  242 +++++
 drivers/of/of_i2c.c                               |  115 +++
 drivers/ps3/ps3-sys-manager.c                     |   74 +-
 drivers/ps3/sys-manager-core.c                    |   16 
 drivers/serial/cpm_uart/cpm_uart.h                |    3 
 drivers/serial/cpm_uart/cpm_uart_core.c           |   19 
 drivers/serial/cpm_uart/cpm_uart_cpm1.c           |   14 
 drivers/serial/cpm_uart/cpm_uart_cpm2.c           |   52 +
 drivers/serial/of_serial.c                        |    4 
 drivers/serial/ucc_uart.c                         |   16 
 include/asm-powerpc/Kbuild                        |    2 
 include/asm-powerpc/abs_addr.h                    |    3 
 include/asm-powerpc/bitops.h                      |   32 -
 include/asm-powerpc/cpm.h                         |   14 
 include/asm-powerpc/cpm1.h                        |   13 
 include/asm-powerpc/cpm2.h                        |   11 
 include/asm-powerpc/cputhreads.h                  |    2 
 include/asm-powerpc/dcr-native.h                  |   17 
 include/asm-powerpc/dcr-regs.h                    |   78 ++
 include/asm-powerpc/exception.h                   |    6 
 include/asm-powerpc/fsl_lbc.h                     |  311 +++++++
 include/asm-powerpc/gpio.h                        |   56 +
 include/asm-powerpc/hw_irq.h                      |   13 
 include/asm-powerpc/immap_qe.h                    |    3 
 include/asm-powerpc/irqflags.h                    |   37 +
 include/asm-powerpc/iseries/alpaca.h              |   31 +
 include/asm-powerpc/iseries/it_lp_reg_save.h      |   85 --
 include/asm-powerpc/lmb.h                         |   82 --
 include/asm-powerpc/machdep.h                     |    5 
 include/asm-powerpc/macio.h                       |    2 
 include/asm-powerpc/mmu-40x.h                     |    2 
 include/asm-powerpc/mmu-44x.h                     |    2 
 include/asm-powerpc/mmu-8xx.h                     |    2 
 include/asm-powerpc/mmu-fsl-booke.h               |    6 
 include/asm-powerpc/mmu-hash32.h                  |    2 
 include/asm-powerpc/mmu-hash64.h                  |    3 
 include/asm-powerpc/paca.h                        |   12 
 include/asm-powerpc/page.h                        |    1 
 include/asm-powerpc/page_32.h                     |    2 
 include/asm-powerpc/pasemi_dma.h                  |   77 ++
 include/asm-powerpc/pci-bridge.h                  |    4 
 include/asm-powerpc/pgtable-ppc32.h               |    8 
 include/asm-powerpc/phyp_dump.h                   |   47 +
 include/asm-powerpc/pmi.h                         |    2 
 include/asm-powerpc/ppc4xx.h                      |   18 
 include/asm-powerpc/ps3.h                         |    7 
 include/asm-powerpc/ptrace.h                      |    9 
 include/asm-powerpc/qe.h                          |   12 
 include/asm-powerpc/rwsem.h                       |   35 +
 include/asm-powerpc/sparsemem.h                   |    1 
 include/asm-powerpc/spinlock.h                    |    1 
 include/asm-powerpc/string.h                      |    2 
 include/asm-powerpc/system.h                      |    1 
 include/asm-powerpc/types.h                       |    7 
 include/asm-sparc64/lmb.h                         |   10 
 include/linux/lmb.h                               |   85 ++
 include/linux/of.h                                |    1 
 include/linux/of_gpio.h                           |   69 ++
 include/linux/of_i2c.h                            |   24 +
 lib/Kconfig                                       |    3 
 lib/Makefile                                      |    2 
 lib/lmb.c                                         |  428 ++++++++++
 421 files changed, 11370 insertions(+), 5221 deletions(-)
 create mode 100644 Documentation/powerpc/phyp-assisted-dump.txt
 create mode 100644 arch/powerpc/boot/cuboot-yosemite.c
 create mode 100644 arch/powerpc/boot/dts/canyonlands.dts
 create mode 100644 arch/powerpc/boot/dts/glacier.dts
 create mode 100644 arch/powerpc/boot/dts/ksi8560.dts
 create mode 100644 arch/powerpc/boot/dts/sbc8641d.dts
 create mode 100644 arch/powerpc/boot/dts/yosemite.dts
 create mode 100644 arch/powerpc/boot/simpleboot.c
 create mode 100644 arch/powerpc/boot/virtex405-head.S
 rename arch/powerpc/configs/{ep405_defconfig => 40x/ep405_defconfig} (100%)
 rename arch/powerpc/configs/{kilauea_defconfig => 40x/kilauea_defconfig} (100%)
 rename arch/powerpc/configs/{makalu_defconfig => 40x/makalu_defconfig} (100%)
 copy arch/powerpc/configs/{walnut_defconfig => 40x/walnut_defconfig} (100%)
 rename arch/powerpc/configs/{bamboo_defconfig => 44x/bamboo_defconfig} (100%)
 copy arch/powerpc/configs/{taishan_defconfig => 44x/canyonlands_defconfig} (82%)
 rename arch/powerpc/configs/{ebony_defconfig => 44x/ebony_defconfig} (100%)
 rename arch/powerpc/configs/{katmai_defconfig => 44x/katmai_defconfig} (100%)
 rename arch/powerpc/configs/{rainier_defconfig => 44x/rainier_defconfig} (100%)
 rename arch/powerpc/configs/{sequoia_defconfig => 44x/sequoia_defconfig} (100%)
 rename arch/powerpc/configs/{taishan_defconfig => 44x/taishan_defconfig} (100%)
 rename arch/powerpc/configs/{warp_defconfig => 44x/warp_defconfig} (100%)
 rename arch/powerpc/configs/{mpc8313_rdb_defconfig => 83xx/mpc8313_rdb_defconfig} (99%)
 rename arch/powerpc/configs/{mpc8315_rdb_defconfig => 83xx/mpc8315_rdb_defconfig} (100%)
 rename arch/powerpc/configs/{mpc832x_mds_defconfig => 83xx/mpc832x_mds_defconfig} (100%)
 rename arch/powerpc/configs/{mpc832x_rdb_defconfig => 83xx/mpc832x_rdb_defconfig} (100%)
 rename arch/powerpc/configs/{mpc834x_itx_defconfig => 83xx/mpc834x_itx_defconfig} (100%)
 rename arch/powerpc/configs/{mpc834x_itxgp_defconfig => 83xx/mpc834x_itxgp_defconfig} (100%)
 rename arch/powerpc/configs/{mpc834x_mds_defconfig => 83xx/mpc834x_mds_defconfig} (100%)
 rename arch/powerpc/configs/{mpc836x_mds_defconfig => 83xx/mpc836x_mds_defconfig} (100%)
 rename arch/powerpc/configs/{mpc837x_mds_defconfig => 83xx/mpc837x_mds_defconfig} (100%)
 rename arch/powerpc/configs/{mpc837x_rdb_defconfig => 83xx/mpc837x_rdb_defconfig} (100%)
 rename arch/powerpc/configs/{sbc834x_defconfig => 83xx/sbc834x_defconfig} (100%)
 copy arch/powerpc/configs/{mpc8560_ads_defconfig => 85xx/ksi8560_defconfig} (85%)
 rename arch/powerpc/configs/{mpc8540_ads_defconfig => 85xx/mpc8540_ads_defconfig} (100%)
 rename arch/powerpc/configs/{mpc8544_ds_defconfig => 85xx/mpc8544_ds_defconfig} (99%)
 rename arch/powerpc/configs/{mpc8560_ads_defconfig => 85xx/mpc8560_ads_defconfig} (100%)
 rename arch/powerpc/configs/{mpc8568mds_defconfig => 85xx/mpc8568mds_defconfig} (100%)
 rename arch/powerpc/configs/{mpc8572_ds_defconfig => 85xx/mpc8572_ds_defconfig} (100%)
 rename arch/powerpc/configs/{mpc85xx_cds_defconfig => 85xx/mpc85xx_cds_defconfig} (100%)
 rename arch/powerpc/configs/{sbc8548_defconfig => 85xx/sbc8548_defconfig} (100%)
 rename arch/powerpc/configs/{sbc8560_defconfig => 85xx/sbc8560_defconfig} (100%)
 copy arch/powerpc/configs/{stx_gp3_defconfig => 85xx/stx_gp3_defconfig} (100%)
 rename arch/powerpc/configs/{tqm8540_defconfig => 85xx/tqm8540_defconfig} (100%)
 rename arch/powerpc/configs/{tqm8541_defconfig => 85xx/tqm8541_defconfig} (100%)
 rename arch/powerpc/configs/{tqm8555_defconfig => 85xx/tqm8555_defconfig} (100%)
 rename arch/powerpc/configs/{tqm8560_defconfig => 85xx/tqm8560_defconfig} (100%)
 rename arch/powerpc/configs/{walnut_defconfig => ppc40x_defconfig} (97%)
 rename arch/powerpc/configs/{stx_gp3_defconfig => sbc8641d_defconfig} (61%)
 create mode 100644 arch/powerpc/kernel/stacktrace.c
 delete mode 100644 arch/powerpc/mm/lmb.c
 create mode 100644 arch/powerpc/platforms/44x/canyonlands.c
 create mode 100644 arch/powerpc/platforms/44x/idle.c
 create mode 100644 arch/powerpc/platforms/85xx/ksi8560.c
 create mode 100644 arch/powerpc/platforms/86xx/sbc8641d.c
 create mode 100644 arch/powerpc/platforms/pseries/phyp_dump.c
 create mode 100644 arch/powerpc/sysdev/fsl_lbc.c
 create mode 100644 arch/powerpc/sysdev/ppc4xx_soc.c
 create mode 100644 drivers/net/pasemi_mac_ethtool.c
 create mode 100644 drivers/of/gpio.c
 create mode 100644 drivers/of/of_i2c.c
 create mode 100644 include/asm-powerpc/fsl_lbc.h
 create mode 100644 include/asm-powerpc/gpio.h
 create mode 100644 include/asm-powerpc/iseries/alpaca.h
 delete mode 100644 include/asm-powerpc/iseries/it_lp_reg_save.h
 create mode 100644 include/asm-powerpc/phyp_dump.h
 create mode 100644 include/asm-powerpc/ppc4xx.h
 create mode 100644 include/asm-sparc64/lmb.h
 create mode 100644 include/linux/lmb.h
 create mode 100644 include/linux/of_gpio.h
 create mode 100644 include/linux/of_i2c.h
 create mode 100644 lib/lmb.c

Adrian Bunk (1):
      [POWERPC] Add MODULE_LICENSE to powerpc/sysdev/rtc_cmos_setup.c

Alexander van Heukelum (1):
      [POWERPC] Use asm-generic/bitops/find.h in bitops.h

Alexandr Smirnov (4):
      [POWERPC] 85xx: Emerson KSI8560 base support
      [POWERPC] 85xx: Emerson KSI8560 bootwrapper
      [POWERPC] 85xx: Emerson KSI8560 default config
      [POWERPC] 85xx: Emerson KSI8560 device tree

Andreas Schwab (1):
      [POWERPC] Add compat handler for PTRACE_GETSIGINFO

Anton Vorontsov (12):
      [POWERPC] 8xx: Timebase frequency should not depend on bus-frequency
      [POWERPC] OF helpers for the GPIO API
      [POWERPC] Implement support for the GPIO LIB API
      [POWERPC] QE: UCC nodes cleanup
      [POWERPC] fsl_elbc_nand: factor out localbus defines
      [POWERPC] fsl_lbc: implement few UPM routines
      [POWERPC] QE: implement qe_muram_offset
      [POWERPC] QE: immap_qe.h should include asm/io.h
      [POWERPC] QE: export qe_get_brg_clk()
      [POWERPC] QE: fix sparse warnings
      [POWERPC] 83xx: mpc837x_rdb: add simple-bus compatible matching
      [POWERPC] 83xx: mpc8315 - fix USB UTMI Host setup

Badari Pulavarty (2):
      [POWERPC] Add code for removing HPTEs for parts of the linear mapping
      [POWERPC] Add error return from htab_remove_mapping()

Becky Bruce (1):
      [LMB]: Make lmb support large physical addressing

Benjamin Herrenschmidt (7):
      [POWERPC] Fix thinko in cpu_thread_mask_to_cores()
      [POWERPC] Initialize paca->current earlier
      [POWERPC] Fixup softirq preempt count
      [POWERPC] properly declare onstack completion in iseries veth
      [POWERPC] Fix device-tree locking vs. interrupts
      [POWERPC] Move stackframe definitions to common header
      [POWERPC] irqtrace support for 64-bit powerpc

Christoph Hellwig (1):
      [POWERPC] Stacktrace support for lockdep

Dale Farnsworth (6):
      [POWERPC] Remove dead code at KernelAltiVec
      [POWERPC] prpmc2800: Fix frequencies in prpmc2800.dts
      [POWERPC] mv64x60: Remove device tree absolute path references
      [POWERPC] mv643xx_eth: Prepare to support multiple silicon blocks
      [POWERPC] Document the mv64x60 device tree bindings
      [POWERPC] prpmc2800 needs a dtbImage

David Gibson (1):
      [POWERPC] Start removing linux,network-index in favour of aliases

David S. Miller (3):
      [LIB]: Make PowerPC LMB code generic so sparc64 can use it too.
      [LMB]: Fix bug in __lmb_alloc_base().
      [LMB] Add lmb_alloc_nid()

David Woodhouse (1):
      [POWERPC] Efika: Really, don't pretend to be CHRP

Geert Uytterhoeven (4):
      [POWERPC] PS3: Save power in busy loops on halt
      [POWERPC] move_device_tree() should be __init
      [POWERPC] arch_add_memory() cannot be __devinit
      [POWERPC] PS3: Split device setup for static vs. dynamic devices

Geoff Levand (2):
      [POWERPC] PS3: Bootwrapper improvements
      [POWERPC] PS3: Sys-manager Wake-on-LAN support

Gerhard Stenzel (1):
      [POWERPC] spufs: fix incorrect file descriptors in SPU coredump note names

Grant Likely (2):
      [POWERPC] add target for building .dtb files
      [POWERPC] bootwrapper: Add a firmware-independent simpleboot target.

Haiying Wang (1):
      [POWERPC] 85xx: Fix the size of qe muram for MPC8568E

Harvey Harrison (2):
      [POWERPC] Replace remaining __FUNCTION__ occurrences
      [POWERPC] ppc: Replace remaining __FUNCTION__ occurrences

Ionut Nicu (1):
      [POWERPC] Fix kernel panic in arch_arm_kprobe

Ishizaki Kou (2):
      [POWERPC] celleb: Coding style cleanup
      [POWERPC] hvcbeat: Fix buffer manipulation

Jeremy Kerr (3):
      [POWERPC] spufs: add newline to signal{1,2}_type files
      [POWERPC] spufs: reacquire LS pointer in spu_process_callback
      [POWERPC] spufs: save MFC command channel before purging MFC queue

Jerone Young (1):
      [POWERPC] 4xx: Add idle wait support for 44x platforms

Jochen Friedrich (2):
      [POWERPC] i2c: OF helpers for the i2c API
      [POWERPC] i2c: Fix build breakage introduced by OF helpers

Johannes Berg (1):
      [POWERPC] mpic: Make sparse happy

Johannes Weiner (2):
      [POWERPC] Remove redundant display of free swap space in show_mem()
      [POWERPC] ppc: Remove redundant display of free swap space in show_mem()

Josh Boyer (7):
      [POWERPC] 4xx: Add AMCC 440EP Yosemite DTS
      [POWERPC] 4xx: Add platform support for the AMCC Yosemite board
      [POWERPC] 4xx: Add bootwrapper for AMCC Yosemite board
      [POWERPC] 4xx: Add Canyonlands and Yosemite to multi-board defconfig
      [POWERPC] Add of_device_is_available function
      [POWERPC] 4xx: Reorganize 4xx defconfigs
      [POWERPC] 4xx: Add ppc40x_defconfig

Julia Lawall (2):
      [POWERPC] Use FIELD_SIZEOF in arch/ppc
      [POWERPC] Use FIELD_SIZEOF in drivers/block/viodasd.c

Kumar Gala (23):
      [LMB]: Fix initial lmb add region with a non-zero base
      [LMB]: Fix lmb_add_region if region should be added at the head
      [POWERPC] Remove Kconfig option BOOT_LOAD
      [POWERPC] Provide access to arch/powerpc include path on ppc64
      [POWERPC] Remove and replace uses of PPC_MEMSTART with memstart_addr
      [POWERPC] Introduce lowmem_end_addr to distinguish from total_lowmem
      [POWERPC] 85xx: Cleanup TLB initialization
      [POWERPC] Use lowmem_end_addr to limit lmb allocations on ppc32
      [POWERPC] Rename __initial_memory_limit to __initial_memory_limit_addr
      [POWERPC] Clean up some linker and symbol usage
      [POWERPC] Move phys_addr_t definition into asm/types.h
      [POWERPC] Update linker script to properly set physical addresses
      [POWERPC] bootwrapper: Use physical address in PHDR for uImage
      [POWERPC] Cleanup pgtable-ppc32.h
      [POWERPC] Remove unused machine call outs
      [POWERPC] Rework Book-E debug exception handling
      [POWERPC] 83xx/85xx: Reorganize defconfigs
      [POWERPC] Make Book-E debug handling SMP safe
      [POWERPC] 83xx: Enable FCM NAND and OF partitions in defconfig
      [POWERPC] 85xx: Fix compile warning
      [POWERPC] 85xx: Convert dts to v1 syntax
      [POWERPC] 85xx: minor .dts cleanups
      [POWERPC] fsl: Convert dts to v1 syntax

Laurent Pinchart (6):
      [POWERPC] cpm_uart: Allocate DPRAM memory for SMC ports on CPM2-based platforms.
      [POWERPC] Add bootwrapper function to get virtual reg from the device tree.
      [POWERPC] cpm-serial: Relocate CPM buffer descriptors and SMC parameter ram.
      [POWERPC] ep8248e: Reference SMC parameter RAM base in the device tree.
      [POWERPC] CPM2: Reset the CPM when early debugging is not enabled.
      [POWERPC] CPM: Move opcodes common to CPM1 and CPM2 to include/asm-powerpc/cpm.h

Manish Ahuja (11):
      [POWERPC] pseries: phyp dump: Documentation
      [POWERPC] pseries: phyp dump: Reserve and release memory
      [POWERPC] pseries: phyp dump: Use sysfs to release reserved mem
      [POWERPC] pseries: phyp dump: Register dump area
      [POWERPC] pseries: phyp dump: Debugging print routines
      [POWERPC] pseries: phyp dump: Invalidate and print dump areas
      [POWERPC] pseries: phyp dump: Tracking memory range freed
      [POWERPC] pseries: phyp dump: Add Kconfig file option
      [POWERPC] pseries: phyp dump: Disable phyp-dump through boot-var
      [POWERPC] pseries: phyp dump: Inform kdump when phyp-dump is loaded
      [POWERPC] pseries/phyp dump: Reserve a variable amount of space at boot

Marian Balakowicz (1):
      [POWERPC] Add 'model: ...' line to common show_cpuinfo()

Mark A. Greer (3):
      [POWERPC] prpmc2800: Convert DTS to v1 and add labels
      [POWERPC] mv64x60: Fix FDT compatible names: mv64x60 => mv64360
      [POWERPC] prpmc2800: Clean up dts properties

Masakazu Mokuno (1):
      [POWERPC] PS3: Gelic network driver Wake-on-LAN support

Michael Ellerman (6):
      [POWERPC] Move prototype for find_udbg_vterm() into a header file
      [POWERPC] Always add preferred consoles in platforms/pseries/lpar.c
      [POWERPC] Move xics_setup_8259_cascade() into platforms/pseries/setup.c
      [POWERPC] Turn xics_setup_8259_cascade() into a generic pseries_setup_i8259_cascade()
      [POWERPC] Use pseries_setup_i8259_cascade() in pseries_mpic_init_IRQ()
      [POWERPC] Simplify xics direct/lpar irq_host setup

Nate Case (1):
      pasemi_mac: Netpoll support

Nathan Lynch (5):
      [POWERPC] maple: Use platform name in define_machine()
      [POWERPC] maple: Kill fixup_maple_ide
      [POWERPC] maple: Enable ipr driver in defconfig
      [POWERPC] scanlog_init cleanup and minor fixes
      [POWERPC] Convert pci and eeh code to of_device_is_available

Olof Johansson (9):
      pasemi_mac: Move RX/TX section enablement to dma_lib
      [POWERPC] pasemi: Add flag management functions to dma_lib
      [POWERPC] pasemi: Add function engine management functions to dma_lib
      pasemi_mac: jumbo frame support
      pasemi_mac: Enable GSO by default
      pasemi_mac: basic ethtool support
      pasemi_mac: Jumbo frame bugfixes
      [POWERPC] pasemi: Minor iommu cleanup
      [POWERPC] Remove unused __max_memory variable

Paul Gortmaker (5):
      [POWERPC] 86xx: Add support for Wind River SBC8641D board
      [POWERPC] 86xx: Add defconfig for Wind River SBC8641D board
      [POWERPC] 86xx: Add device tree source for Wind River SBC8641D
      [POWERPC] 86xx: mark functions static, other minor cleanups
      [POWERPC] 86xx: mpc86xx_hpcn - Temporarily accept old dts node identifier.

Paul Mackerras (5):
      [POWERPC] Fix handling of unrecoverable SLB miss interrupts
      [LMB] Fix some whitespace and other formatting issues, use pr_debug
      [LMB] Restructure allocation loops to avoid unsigned underflow
      [POWERPC] Optimize fls64() on 64-bit processors
      [POWERPC] Fix compile breakage for 64-bit UP configs

Robert Brose (1):
      [POWERPC] Add kernel parameter to set l3cr for MPC745x

Robert P. J. Day (2):
      [POWERPC] Move a.out.h to header-y since it doesn't check __KERNEL__
      [POWERPC] Use __SPIN_LOCK_UNLOCKED macro in mpc52xx_set_psc_clkdiv

Roel Kluin (2):
      [POWERPC] PS3: Fix unlikely typo in ps3_get_irq
      [POWERPC] Replace logical-AND by bit-AND in pci_process_ISA_OF_ranges()

Roland McGrath (3):
      [POWERPC] Don't touch PT_DTRACE in exec
      [POWERPC] powerpc32: Remove asm-offsets ptrace cruft
      [POWERPC] Define copy_siginfo_from_user32

S.,AG(Ba$,1 ?(Blar Onur (1):
      [POWERPC] arch/powerpc/platforms/iseries/pci.c: Use time_* macros

Scott Wood (4):
      [POWERPC] CPM: Always use new binding.
      [POWERPC] fsl_soc: Factor fsl_get_sys_freq() out of the wdt and spi inits.
      [POWERPC] cuboot-pq2: PCI fixes
      [POWERPC] 83xx: mpc8313erdb - Enable FCM NAND and OF partitions in defconfig

Sebastian Siewior (1):
      [POWERPC] 85xx: Enable DMA engine on the MPC8544 DS

Stefan Roese (15):
      [POWERPC] 4xx: Add AMCC 460EX/460GT support to cputable.c & cpu_setup_44x.S
      [POWERPC] 4xx: Add AMCC Canyonlands 460EX eval board support to platforms/44x
      [POWERPC] 4xx: Add Canyonlands DTS
      [POWERPC] 4xx: Add 460EX PCIe support to 4xx pci driver
      [POWERPC] 4xx: Add Canyonlands defconfig file
      [POWERPC] 4xx: Add TAH support to taishan dts
      [POWERPC] 4xx: Add AMCC Glacier 460GT eval board dts
      [POWERPC] 4xx: Add "amcc, haleakala" to the toplevel compatible property
      [POWERPC] 4xx: Add PPC4xx L2-cache support (440GX)
      [POWERPC] 4xx: Add L2 cache node to AMCC Taishan dts file
      [POWERPC] 4xx: Only reset PCIe PHY on 405EX systems when no link is detected
      [POWERPC] 4xx: Fix PESDRn_UTLSET1 register setup on 460EX/GT
      [POWERPC] 4xx: Create common ppc4xx_reset_system() in ppc4xx_soc.c
      [POWERPC] 4xx: Some EMAC related changes in Canyonlands & Glacier dts files
      [POWERPC] 4xx: Change dts files to support jumbo frames

Stephen Neuendorffer (4):
      [POWERPC] Xilinx: hwicap: Refactor status handling code.
      [POWERPC] Xilinx: hwicap: Verify sync before reading idcode.
      [POWERPC] Xilinx: hwicap: Use fixed device major.
      [POWERPC] of_serial: Fix possible null dereference.

Stephen Rothwell (9):
      [POWERPC] Really export empty_zero_page
      [POWERPC] htab_remove_mapping is only used by MEMORY_HOTPLUG
      [POWERPC] Remove CONFIG_PCI_LEGACY from some configs
      [POWERPC] Fix MAX_ORDER config problem
      [POWERPC] iSeries: Use alternate paca structure for booting
      [POWERPC] iSeries: Make iseries_reg_save private to iSeries
      [POWERPC] iSeries: Localise and constify some iSeries data
      [POWERPC] remove include of asm/of_device.h from pmi.h
      [POWERPC] replace asm/of_device.h with linux/of_device.h in macio.h

Steven Rostedt (1):
      [POWERPC] Add hand-coded assembly strcmp

Takashi Yamamoto (1):
      [POWERPC] PS3: Add ps3_get_speid routine

Timur Tabi (2):
      [POWERPC] Enable CONFIG_FORCE_MAX_ZONEORDER for all PowerPC, and make selectable
      [POWERPC] Make rheap safe for spinlocks

Tony Breeds (1):
      [POWERPC] Update wait_state_cycles in the VPA

Trent Piepho (1):
      [POWERPC] Make pci_bus_to_host()'s struct pci_bus * argument const

Valentine Barshak (4):
      [POWERPC] 4xx: Add dcri_clrset() for locked read/modify/write functionality
      [POWERPC] 4xx: Use dcri_clrset() for PCIe indirect dcr read/modify/write access
      [POWERPC] 4xx: Use machine_device_initcall() for warp_nand
      [POWERPC] kexec: MPIC ack interrupts at mpic_teardown_this_cpu()

