Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbYCCLlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbYCCLlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYCCLlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:41:09 -0500
Received: from ozlabs.org ([203.10.76.45]:52603 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYCCLlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:41:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18379.58317.223229.950553@cargo.ozlabs.ibm.com>
Date: Mon, 3 Mar 2008 22:41:01 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get a collection of bug-fixes for powerpc, for the Cell, 4xx and
52xx platforms.

Thanks,
Paul.

 arch/powerpc/boot/cuboot-bamboo.c            |    1 
 arch/powerpc/boot/cuboot-ebony.c             |    1 
 arch/powerpc/boot/cuboot-katmai.c            |    1 
 arch/powerpc/boot/cuboot-taishan.c           |    2 
 arch/powerpc/boot/cuboot-warp.c              |    1 
 arch/powerpc/boot/dts/haleakala.dts          |    2 
 arch/powerpc/boot/dts/katmai.dts             |   58 +++++-----
 arch/powerpc/oprofile/op_model_cell.c        |    2 
 arch/powerpc/platforms/52xx/mpc52xx_common.c |    1 
 arch/powerpc/platforms/cell/iommu.c          |  151 +++++++++++++++-----------
 arch/powerpc/platforms/cell/setup.c          |    7 +
 arch/powerpc/platforms/cell/spu_base.c       |   16 ++-
 arch/powerpc/platforms/cell/spufs/context.c  |    7 +
 arch/powerpc/platforms/cell/spufs/file.c     |   12 ++
 arch/powerpc/platforms/cell/spufs/sched.c    |    2 
 arch/powerpc/platforms/cell/spufs/sputrace.c |    7 +
 arch/powerpc/platforms/cell/spufs/switch.c   |    6 +
 arch/powerpc/platforms/celleb/beat.h         |    3 -
 drivers/char/xilinx_hwicap/buffer_icap.c     |   80 +++++++-------
 drivers/char/xilinx_hwicap/fifo_icap.c       |   60 +++++-----
 drivers/char/xilinx_hwicap/xilinx_hwicap.c   |  138 +++++++++++-------------
 drivers/char/xilinx_hwicap/xilinx_hwicap.h   |   24 ++--
 include/asm-powerpc/reg.h                    |    3 +
 23 files changed, 318 insertions(+), 267 deletions(-)

Andre Detsch (1):
      [POWERPC] spufs: fix use time accounting on SPE-overcommit

Arnd Bergmann (3):
      [POWERPC] spufs: synchronize IRQ when disabling
      [POWERPC] spufs: invalidate SLB translation before adding a new entry
      [POWERPC] spufs: serialize SLB invalidation against SLB loading

Bob Nelson (1):
      [POWERPC] OProfile: enable callgraph support for Cell

Eric Dujardin (1):
      [POWERPC] Add export for mpc52xx_set_psc_clkdiv

Jens Osterkamp (2):
      [POWERPC] move celleb DABRX definitions
      [POWERPC] enable hardware watchpoints on cell blades

Jeremy Kerr (3):
      [POWERPC] spufs: fix context destruction during psmap fault
      [POWERPC] spufs: fix invalid scheduling of forgotten contexts
      [POWERPC] spufs: fix order of sputrace thread IDs

Josh Boyer (1):
      [POWERPC] 4xx: Use correct board info structure in cuboot wrappers

Michael Ellerman (8):
      [POWERPC] Clearup cell IOMMU fixed mapping terminology
      [POWERPC] Use it_offset not pte_offset in cell IOMMU code
      [POWERPC] Remove unused pte_offset variable
      [POWERPC] Move allocation of cell IOMMU pad page
      [POWERPC] Split setup of IOMMU stab and ptab, allocate dynamic/fixed ptabs separately
      [POWERPC] Cell IOMMU: n_pte_pages is in 4K page units, not IOMMU_PAGE_SIZE
      [POWERPC] Allow for different IOMMU page sizes in cell IOMMU code
      [POWERPC] Convert the cell IOMMU fixed mapping to 16M IOMMU pages

Stefan Roese (2):
      [POWERPC] 4xx: Fix Haleakala PCIe compatibility problem in dts
      [POWERPC] 4xx: Fix L1 cache size in katmai DTS

Stephen Neuendorffer (1):
      [POWERPC] Xilinx: hwicap cleanup

Valentine Barshak (1):
      [POWERPC] 44x: add missing define TARGET_4xx and TARGET_440GX to cuboot-taishan

