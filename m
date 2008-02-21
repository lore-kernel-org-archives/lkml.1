Return-Path: <linux-kernel-owner+w=401wt.eu-S934403AbYBUVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbYBUVEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYBUVEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:04:45 -0500
Received: from ozlabs.org ([203.10.76.45]:38296 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbYBUVEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:04:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18365.27476.485545.810868@cargo.ozlabs.ibm.com>
Date: Thu, 21 Feb 2008 23:15:16 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Please pull powerpc.git merge branch
In-Reply-To: <18363.41603.210217.163071@cargo.ozlabs.ibm.com>
References: <18363.41603.210217.163071@cargo.ozlabs.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Since I send the last pull request I have added four more commits to
the powerpc.git merge branch, two from Olof Johansson fixing a bug and
a warning for the pasemi platform, and two spufs bugfixes from Jeremy
Kerr.

Please do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

The diffstat and log below reflect all the outstanding commits, not
just the new four.

Thanks,
Paul.

 arch/powerpc/boot/Makefile                 |    8 
 arch/powerpc/boot/dts/bamboo.dts           |    3 
 arch/powerpc/boot/dts/ebony.dts            |    2 
 arch/powerpc/boot/dts/katmai.dts           |    2 
 arch/powerpc/boot/dts/kilauea.dts          |    3 
 arch/powerpc/boot/dts/makalu.dts           |    3 
 arch/powerpc/boot/dts/rainier.dts          |    4 
 arch/powerpc/boot/dts/sequoia.dts          |    4 
 arch/powerpc/boot/dts/taishan.dts          |    4 
 arch/powerpc/configs/bamboo_defconfig      |   81 ++-
 arch/powerpc/configs/ebony_defconfig       |   79 ++
 arch/powerpc/configs/ep405_defconfig       |   92 ++-
 arch/powerpc/configs/kilauea_defconfig     |   69 +-
 arch/powerpc/configs/makalu_defconfig      |   69 +-
 arch/powerpc/configs/ppc44x_defconfig      |  904 ++++++++++++++++++++++++++++
 arch/powerpc/configs/rainier_defconfig     |   82 ++-
 arch/powerpc/configs/sequoia_defconfig     |   77 ++
 arch/powerpc/configs/taishan_defconfig     |   81 ++-
 arch/powerpc/configs/walnut_defconfig      |   81 ++-
 arch/powerpc/configs/warp_defconfig        |  139 +++-
 arch/powerpc/kernel/kprobes.c              |    9 
 arch/powerpc/kernel/prom.c                 |   13 
 arch/powerpc/platforms/44x/Kconfig         |   10 
 arch/powerpc/platforms/cell/spu_base.c     |   12 
 arch/powerpc/platforms/cell/spufs/run.c    |    1 
 arch/powerpc/platforms/cell/spufs/sched.c  |    8 
 arch/powerpc/platforms/cell/spufs/switch.c |    6 
 arch/powerpc/platforms/pasemi/Makefile     |    2 
 arch/powerpc/platforms/pasemi/misc.c       |   97 +++
 arch/powerpc/platforms/pseries/power.c     |    2 
 arch/powerpc/sysdev/mpic_pasemi_msi.c      |    5 
 arch/ppc/platforms/4xx/ibm440ep.c          |    6 
 drivers/net/ibm_newemac/rgmii.c            |    1 
 include/asm-powerpc/spu.h                  |    3 
 34 files changed, 1605 insertions(+), 357 deletions(-)
 create mode 100644 arch/powerpc/configs/ppc44x_defconfig
 create mode 100644 arch/powerpc/platforms/pasemi/misc.c

Ananth N Mavinakayanahalli (1):
      [POWERPC] Kill sparse warnings in kprobes

Andre Detsch (1):
      [POWERPC] cell: fix spurious false return from spu_trap_data_{map,seg}

Becky Bruce (1):
      [POWERPC] Fix dt_mem_next_cell() to read the full address

Jeremy Kerr (1):
      [POWERPC] spufs: fix scheduler starvation by idle contexts

Josh Boyer (4):
      [POWERPC] 4xx: Update defconfigs for 2.6.25
      [POWERPC] 44x: Fix Kconfig formatting
      [POWERPC] 44x: Add multiplatform defconfig
      [POWERPC] Fix bootwrapper builds with older gcc versions

Olof Johansson (2):
      [POWERPC] pasemi: Register i2c devices at boot
      [POWERPC] pasemi: Remove warning in mpic_pasemi_msi.c

Stefan Roese (2):
      [POWERPC] net: NEWEMAC: Remove "rgmii-interface" from rgmii matching table
      [POWERPC] 4xx: Remove "i2c" and "xxmii-interface" device_types from dts

Stephen Rothwell (1):
      [POWERPC] Fix warning in pseries/power.c

Wolfgang Ocker (1):
      [POWERPC] PPC440EP Interrupt Triggering and Level Settings

