Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452Ab0ARGqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0ARGqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 01:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918Ab0ARGqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 01:46:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:43360 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab0ARGqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 01:46:21 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 17:45:48 +1100
Message-ID: <1263797148.724.484.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

A tad late due to me slacking and leaving the patches take dust in
patchwork for a bit too long, but here are a few bug fixes for powerpc
and a bunch of defconfig freshen ups for some of our embedded platforms.

Cheers,
Ben.

The following changes since commit 004b35063296b6772fa72404a35b498f1e71e87e:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Blanchard (2):
      powerpc/pseries: Fix xics interrupt affinity
      powerpc: cpumask_of_node() should handle -1 as a node

Anton Vorontsov (1):
      powerpc/swsusp_32: Fix TLB invalidation

Benjamin Herrenschmidt (3):
      serial/pmac_zilog: Workaround problem due to interrupt on closed port
      Merge commit 'kumar/merge' into merge
      Merge commit 'gcl/merge' into merge

FUJITA Tomonori (1):
      powerpc/pseries: Fix dlpar compile warning without CONFIG_PROC_DEVICETREE

Grant Likely (1):
      powerpc/5200: update defconfigs

Jiri Slaby (1):
      powerpc: Use helpers for rlimits

Joakim Tjernlund (2):
      powerpc/8xx: Always pin kernel instruction TLB
      powerpc/8xx: Fix user space TLB walk in dcbX fixup

Kamalesh Babulal (1):
      powerpc/hvc: Driver build breaks with !HVC_CONSOLE

Kumar Gala (1):
      powerpc: 2.6.33 update of defconfigs for embedded 6xx/7xxx, 8xx, 8xxx

Michael Ellerman (1):
      powerpc/iseries: Initialise on-stack completion

Márton Németh (1):
      powerpc/macintosh: Make Open Firmware device id constant

Nathan Fontenot (2):
      powerpc: Move /proc/ppc64 to /proc/powerpc update
      powerpc: Move cpu hotplug driver lock from pseries to powerpc

Peter Tyser (1):
      powerpc: Use scripts/mkuboot.sh instead of 'mkimage'

Stefan Roese (1):
      powerpc: Fix decrementer setup on 1GHz boards

 arch/powerpc/boot/wrapper                         |    7 +-
 arch/powerpc/configs/52xx/cm5200_defconfig        |   75 ++++++++++++---
 arch/powerpc/configs/52xx/lite5200b_defconfig     |   90 ++++++++++++++----
 arch/powerpc/configs/52xx/motionpro_defconfig     |   79 +++++++++++++---
 arch/powerpc/configs/52xx/pcm030_defconfig        |   83 +++++++++++++----
 arch/powerpc/configs/52xx/tqm5200_defconfig       |   79 +++++++++++++---
 arch/powerpc/configs/83xx/asp8347_defconfig       |   88 +++++++++++++-----
 arch/powerpc/configs/83xx/kmeter1_defconfig       |   68 +++++++++++---
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |   97 +++++++++++++++-----
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |  100 +++++++++++++++-----
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |   89 +++++++++++++-----
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |   93 ++++++++++++++-----
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |   95 ++++++++++++++-----
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |   92 ++++++++++++++-----
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |   86 +++++++++++++-----
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |   89 +++++++++++++-----
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |   87 +++++++++++++-----
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |   89 +++++++++++++-----
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |   91 +++++++++++++-----
 arch/powerpc/configs/83xx/sbc834x_defconfig       |   85 ++++++++++++-----
 arch/powerpc/configs/85xx/ksi8560_defconfig       |   69 ++++++++++---
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |   69 ++++++++++---
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |   76 ++++++++++++----
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |   75 +++++++++++----
 arch/powerpc/configs/85xx/sbc8548_defconfig       |   77 ++++++++++++----
 arch/powerpc/configs/85xx/sbc8560_defconfig       |   72 +++++++++++---
 arch/powerpc/configs/85xx/socrates_defconfig      |   99 +++++++++++++++-----
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |   87 +++++++++++++-----
 arch/powerpc/configs/85xx/tqm8540_defconfig       |   89 +++++++++++++-----
 arch/powerpc/configs/85xx/tqm8541_defconfig       |   90 +++++++++++++-----
 arch/powerpc/configs/85xx/tqm8548_defconfig       |   95 ++++++++++++++----
 arch/powerpc/configs/85xx/tqm8555_defconfig       |   90 +++++++++++++-----
 arch/powerpc/configs/85xx/tqm8560_defconfig       |   90 +++++++++++++-----
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   |  103 ++++++++++++++++----
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     |  102 ++++++++++++++++----
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    |   99 ++++++++++++++++----
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |   92 ++++++++++++++----
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |   88 +++++++++++++----
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |   90 ++++++++++++++----
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |   81 ++++++++++++----
 arch/powerpc/configs/adder875_defconfig           |   57 +++++++++---
 arch/powerpc/configs/c2k_defconfig                |   90 +++++++++++++-----
 arch/powerpc/configs/ep8248e_defconfig            |   64 ++++++++++---
 arch/powerpc/configs/ep88xc_defconfig             |   55 +++++++++---
 arch/powerpc/configs/linkstation_defconfig        |   96 ++++++++++++++-----
 arch/powerpc/configs/mgcoge_defconfig             |   74 +++++++++++----
 arch/powerpc/configs/mgsuvd_defconfig             |   63 ++++++++++---
 arch/powerpc/configs/mpc5200_defconfig            |  106 +++++++++++++++++----
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |   79 ++++++++++++----
 arch/powerpc/configs/mpc8272_ads_defconfig        |   70 +++++++++++---
 arch/powerpc/configs/mpc83xx_defconfig            |   92 +++++++++++++-----
 arch/powerpc/configs/mpc85xx_defconfig            |   97 ++++++++++++++-----
 arch/powerpc/configs/mpc85xx_smp_defconfig        |   97 ++++++++++++++-----
 arch/powerpc/configs/mpc866_ads_defconfig         |   65 ++++++++++---
 arch/powerpc/configs/mpc86xx_defconfig            |   93 ++++++++++++++----
 arch/powerpc/configs/mpc885_ads_defconfig         |   55 +++++++++---
 arch/powerpc/configs/pq2fads_defconfig            |   72 +++++++++++---
 arch/powerpc/configs/prpmc2800_defconfig          |   94 ++++++++++++++-----
 arch/powerpc/configs/storcenter_defconfig         |   86 +++++++++++++----
 arch/powerpc/include/asm/topology.h               |    4 +-
 arch/powerpc/kernel/head_8xx.S                    |   12 +-
 arch/powerpc/kernel/rtas-proc.c                   |   14 ++--
 arch/powerpc/kernel/smp.c                         |   12 +++
 arch/powerpc/kernel/swsusp_32.S                   |    2 +-
 arch/powerpc/kernel/time.c                        |   11 ++-
 arch/powerpc/mm/mmap_64.c                         |    4 +-
 arch/powerpc/platforms/cell/spufs/coredump.c      |    2 +-
 arch/powerpc/platforms/iseries/vio.c              |    2 +
 arch/powerpc/platforms/pseries/dlpar.c            |   18 +---
 arch/powerpc/platforms/pseries/xics.c             |   12 +-
 drivers/char/Kconfig                              |    2 +-
 drivers/macintosh/smu.c                           |    2 +-
 drivers/macintosh/therm_pm72.c                    |    2 +-
 drivers/macintosh/therm_windtunnel.c              |    2 +-
 drivers/serial/pmac_zilog.c                       |   11 ++
 75 files changed, 3837 insertions(+), 1175 deletions(-)


