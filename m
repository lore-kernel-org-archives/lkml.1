Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYGNAt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYGNAt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYGNAtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:49:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55415 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbYGNAtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:49:18 -0400
Date: Mon, 14 Jul 2008 01:49:15 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm tree reorganisation for merge window
Message-ID: <alpine.DEB.0.82.0807140147500.9419@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-reorg' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-reorg

This contains a moving around of a lot of the DRM into a more Linux like 
tree and makes it a lot nicer going forward for merging new features.

Dave.

 drivers/Makefile                                   |    1 +
 drivers/char/Makefile                              |    1 -
 drivers/char/drm/Makefile                          |   40 --------------------
 drivers/gpu/Makefile                               |    1 +
 drivers/{char => gpu}/drm/Kconfig                  |    0 
 drivers/gpu/drm/Makefile                           |   26 +++++++++++++
 drivers/{char => gpu}/drm/README.drm               |    0 
 drivers/{char => gpu}/drm/ati_pcigart.c            |    0 
 drivers/{char => gpu}/drm/drm_agpsupport.c         |    0 
 drivers/{char => gpu}/drm/drm_auth.c               |    0 
 drivers/{char => gpu}/drm/drm_bufs.c               |    0 
 drivers/{char => gpu}/drm/drm_context.c            |    0 
 drivers/{char => gpu}/drm/drm_dma.c                |    0 
 drivers/{char => gpu}/drm/drm_drawable.c           |    0 
 drivers/{char => gpu}/drm/drm_drv.c                |    0 
 drivers/{char => gpu}/drm/drm_fops.c               |    0 
 drivers/{char => gpu}/drm/drm_hashtab.c            |    0 
 drivers/{char => gpu}/drm/drm_ioc32.c              |    0 
 drivers/{char => gpu}/drm/drm_ioctl.c              |    0 
 drivers/{char => gpu}/drm/drm_irq.c                |    0 
 drivers/{char => gpu}/drm/drm_lock.c               |    0 
 drivers/{char => gpu}/drm/drm_memory.c             |    0 
 drivers/{char => gpu}/drm/drm_mm.c                 |    0 
 drivers/{char => gpu}/drm/drm_pci.c                |    0 
 drivers/{char => gpu}/drm/drm_proc.c               |    0 
 drivers/{char => gpu}/drm/drm_scatter.c            |    0 
 drivers/{char => gpu}/drm/drm_sman.c               |    0 
 drivers/{char => gpu}/drm/drm_stub.c               |    0 
 drivers/{char => gpu}/drm/drm_sysfs.c              |    0 
 drivers/{char => gpu}/drm/drm_vm.c                 |    0 
 drivers/gpu/drm/i810/Makefile                      |    8 ++++
 drivers/{char/drm => gpu/drm/i810}/i810_dma.c      |    0 
 drivers/{char/drm => gpu/drm/i810}/i810_drv.c      |    0 
 drivers/{char/drm => gpu/drm/i810}/i810_drv.h      |    0 
 drivers/gpu/drm/i830/Makefile                      |    8 ++++
 drivers/{char/drm => gpu/drm/i830}/i830_dma.c      |    0 
 drivers/{char/drm => gpu/drm/i830}/i830_drv.c      |    0 
 drivers/{char/drm => gpu/drm/i830}/i830_drv.h      |    0 
 drivers/{char/drm => gpu/drm/i830}/i830_irq.c      |    0 
 drivers/gpu/drm/i915/Makefile                      |   10 +++++
 drivers/{char/drm => gpu/drm/i915}/i915_dma.c      |    0 
 drivers/{char/drm => gpu/drm/i915}/i915_drv.c      |    0 
 drivers/{char/drm => gpu/drm/i915}/i915_drv.h      |    0 
 drivers/{char/drm => gpu/drm/i915}/i915_ioc32.c    |    0 
 drivers/{char/drm => gpu/drm/i915}/i915_irq.c      |    0 
 drivers/{char/drm => gpu/drm/i915}/i915_mem.c      |    0 
 drivers/gpu/drm/mga/Makefile                       |   11 +++++
 drivers/{char/drm => gpu/drm/mga}/mga_dma.c        |    0 
 drivers/{char/drm => gpu/drm/mga}/mga_drv.c        |    0 
 drivers/{char/drm => gpu/drm/mga}/mga_drv.h        |    0 
 drivers/{char/drm => gpu/drm/mga}/mga_ioc32.c      |    0 
 drivers/{char/drm => gpu/drm/mga}/mga_irq.c        |    0 
 drivers/{char/drm => gpu/drm/mga}/mga_state.c      |    0 
 drivers/{char/drm => gpu/drm/mga}/mga_ucode.h      |    0 
 drivers/{char/drm => gpu/drm/mga}/mga_warp.c       |    0 
 drivers/gpu/drm/r128/Makefile                      |   10 +++++
 drivers/{char/drm => gpu/drm/r128}/r128_cce.c      |    0 
 drivers/{char/drm => gpu/drm/r128}/r128_drv.c      |    0 
 drivers/{char/drm => gpu/drm/r128}/r128_drv.h      |    0 
 drivers/{char/drm => gpu/drm/r128}/r128_ioc32.c    |    0 
 drivers/{char/drm => gpu/drm/r128}/r128_irq.c      |    0 
 drivers/{char/drm => gpu/drm/r128}/r128_state.c    |    0 
 drivers/gpu/drm/radeon/Makefile                    |   10 +++++
 drivers/{char/drm => gpu/drm/radeon}/r300_cmdbuf.c |    0 
 drivers/{char/drm => gpu/drm/radeon}/r300_reg.h    |    0 
 drivers/{char/drm => gpu/drm/radeon}/radeon_cp.c   |    0 
 drivers/{char/drm => gpu/drm/radeon}/radeon_drv.c  |    0 
 drivers/{char/drm => gpu/drm/radeon}/radeon_drv.h  |    0 
 .../{char/drm => gpu/drm/radeon}/radeon_ioc32.c    |    0 
 drivers/{char/drm => gpu/drm/radeon}/radeon_irq.c  |    0 
 drivers/{char/drm => gpu/drm/radeon}/radeon_mem.c  |    0 
 .../drm => gpu/drm/radeon}/radeon_microcode.h      |    0 
 .../{char/drm => gpu/drm/radeon}/radeon_state.c    |    0 
 drivers/gpu/drm/savage/Makefile                    |    9 ++++
 drivers/{char/drm => gpu/drm/savage}/savage_bci.c  |    0 
 drivers/{char/drm => gpu/drm/savage}/savage_drv.c  |    0 
 drivers/{char/drm => gpu/drm/savage}/savage_drv.h  |    0 
 .../{char/drm => gpu/drm/savage}/savage_state.c    |    0 
 drivers/gpu/drm/sis/Makefile                       |   10 +++++
 drivers/{char/drm => gpu/drm/sis}/sis_drv.c        |    0 
 drivers/{char/drm => gpu/drm/sis}/sis_drv.h        |    0 
 drivers/{char/drm => gpu/drm/sis}/sis_mm.c         |    0 
 drivers/gpu/drm/tdfx/Makefile                      |    8 ++++
 drivers/{char/drm => gpu/drm/tdfx}/tdfx_drv.c      |    0 
 drivers/{char/drm => gpu/drm/tdfx}/tdfx_drv.h      |    0 
 drivers/gpu/drm/via/Makefile                       |    8 ++++
 drivers/{char/drm => gpu/drm/via}/via_3d_reg.h     |    0 
 drivers/{char/drm => gpu/drm/via}/via_dma.c        |    0 
 drivers/{char/drm => gpu/drm/via}/via_dmablit.c    |    0 
 drivers/{char/drm => gpu/drm/via}/via_dmablit.h    |    0 
 drivers/{char/drm => gpu/drm/via}/via_drv.c        |    0 
 drivers/{char/drm => gpu/drm/via}/via_drv.h        |    0 
 drivers/{char/drm => gpu/drm/via}/via_irq.c        |    0 
 drivers/{char/drm => gpu/drm/via}/via_map.c        |    0 
 drivers/{char/drm => gpu/drm/via}/via_mm.c         |    0 
 drivers/{char/drm => gpu/drm/via}/via_verifier.c   |    0 
 drivers/{char/drm => gpu/drm/via}/via_verifier.h   |    0 
 drivers/{char/drm => gpu/drm/via}/via_video.c      |    0 
 drivers/video/Kconfig                              |    2 +-
 include/Kbuild                                     |    1 +
 include/drm/Kbuild                                 |   10 +++++
 {drivers/char => include}/drm/drm.h                |    0 
 {drivers/char => include}/drm/drmP.h               |    0 
 {drivers/char => include}/drm/drm_core.h           |    0 
 {drivers/char => include}/drm/drm_hashtab.h        |    0 
 {drivers/char => include}/drm/drm_memory.h         |    0 
 {drivers/char => include}/drm/drm_memory_debug.h   |    0 
 {drivers/char => include}/drm/drm_os_linux.h       |    0 
 {drivers/char => include}/drm/drm_pciids.h         |    0 
 {drivers/char => include}/drm/drm_sarea.h          |    0 
 {drivers/char => include}/drm/drm_sman.h           |    0 
 {drivers/char => include}/drm/i810_drm.h           |    0 
 {drivers/char => include}/drm/i830_drm.h           |    0 
 {drivers/char => include}/drm/i915_drm.h           |    0 
 {drivers/char => include}/drm/mga_drm.h            |    0 
 {drivers/char => include}/drm/r128_drm.h           |    0 
 {drivers/char => include}/drm/radeon_drm.h         |    0 
 {drivers/char => include}/drm/savage_drm.h         |    0 
 {drivers/char => include}/drm/sis_drm.h            |    0 
 {drivers/char => include}/drm/via_drm.h            |    0 
 120 files changed, 132 insertions(+), 42 deletions(-)
 delete mode 100644 drivers/char/drm/Makefile
 create mode 100644 drivers/gpu/Makefile
 rename drivers/{char => gpu}/drm/Kconfig (100%)
 create mode 100644 drivers/gpu/drm/Makefile
 rename drivers/{char => gpu}/drm/README.drm (100%)
 rename drivers/{char => gpu}/drm/ati_pcigart.c (100%)
 rename drivers/{char => gpu}/drm/drm_agpsupport.c (100%)
 rename drivers/{char => gpu}/drm/drm_auth.c (100%)
 rename drivers/{char => gpu}/drm/drm_bufs.c (100%)
 rename drivers/{char => gpu}/drm/drm_context.c (100%)
 rename drivers/{char => gpu}/drm/drm_dma.c (100%)
 rename drivers/{char => gpu}/drm/drm_drawable.c (100%)
 rename drivers/{char => gpu}/drm/drm_drv.c (100%)
 rename drivers/{char => gpu}/drm/drm_fops.c (100%)
 rename drivers/{char => gpu}/drm/drm_hashtab.c (100%)
 rename drivers/{char => gpu}/drm/drm_ioc32.c (100%)
 rename drivers/{char => gpu}/drm/drm_ioctl.c (100%)
 rename drivers/{char => gpu}/drm/drm_irq.c (100%)
 rename drivers/{char => gpu}/drm/drm_lock.c (100%)
 rename drivers/{char => gpu}/drm/drm_memory.c (100%)
 rename drivers/{char => gpu}/drm/drm_mm.c (100%)
 rename drivers/{char => gpu}/drm/drm_pci.c (100%)
 rename drivers/{char => gpu}/drm/drm_proc.c (100%)
 rename drivers/{char => gpu}/drm/drm_scatter.c (100%)
 rename drivers/{char => gpu}/drm/drm_sman.c (100%)
 rename drivers/{char => gpu}/drm/drm_stub.c (100%)
 rename drivers/{char => gpu}/drm/drm_sysfs.c (100%)
 rename drivers/{char => gpu}/drm/drm_vm.c (100%)
 create mode 100644 drivers/gpu/drm/i810/Makefile
 rename drivers/{char/drm => gpu/drm/i810}/i810_dma.c (100%)
 rename drivers/{char/drm => gpu/drm/i810}/i810_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/i810}/i810_drv.h (100%)
 create mode 100644 drivers/gpu/drm/i830/Makefile
 rename drivers/{char/drm => gpu/drm/i830}/i830_dma.c (100%)
 rename drivers/{char/drm => gpu/drm/i830}/i830_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/i830}/i830_drv.h (100%)
 rename drivers/{char/drm => gpu/drm/i830}/i830_irq.c (100%)
 create mode 100644 drivers/gpu/drm/i915/Makefile
 rename drivers/{char/drm => gpu/drm/i915}/i915_dma.c (100%)
 rename drivers/{char/drm => gpu/drm/i915}/i915_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/i915}/i915_drv.h (100%)
 rename drivers/{char/drm => gpu/drm/i915}/i915_ioc32.c (100%)
 rename drivers/{char/drm => gpu/drm/i915}/i915_irq.c (100%)
 rename drivers/{char/drm => gpu/drm/i915}/i915_mem.c (100%)
 create mode 100644 drivers/gpu/drm/mga/Makefile
 rename drivers/{char/drm => gpu/drm/mga}/mga_dma.c (100%)
 rename drivers/{char/drm => gpu/drm/mga}/mga_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/mga}/mga_drv.h (100%)
 rename drivers/{char/drm => gpu/drm/mga}/mga_ioc32.c (100%)
 rename drivers/{char/drm => gpu/drm/mga}/mga_irq.c (100%)
 rename drivers/{char/drm => gpu/drm/mga}/mga_state.c (100%)
 rename drivers/{char/drm => gpu/drm/mga}/mga_ucode.h (100%)
 rename drivers/{char/drm => gpu/drm/mga}/mga_warp.c (100%)
 create mode 100644 drivers/gpu/drm/r128/Makefile
 rename drivers/{char/drm => gpu/drm/r128}/r128_cce.c (100%)
 rename drivers/{char/drm => gpu/drm/r128}/r128_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/r128}/r128_drv.h (100%)
 rename drivers/{char/drm => gpu/drm/r128}/r128_ioc32.c (100%)
 rename drivers/{char/drm => gpu/drm/r128}/r128_irq.c (100%)
 rename drivers/{char/drm => gpu/drm/r128}/r128_state.c (100%)
 create mode 100644 drivers/gpu/drm/radeon/Makefile
 rename drivers/{char/drm => gpu/drm/radeon}/r300_cmdbuf.c (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/r300_reg.h (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/radeon_cp.c (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/radeon_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/radeon_drv.h (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/radeon_ioc32.c (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/radeon_irq.c (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/radeon_mem.c (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/radeon_microcode.h (100%)
 rename drivers/{char/drm => gpu/drm/radeon}/radeon_state.c (100%)
 create mode 100644 drivers/gpu/drm/savage/Makefile
 rename drivers/{char/drm => gpu/drm/savage}/savage_bci.c (100%)
 rename drivers/{char/drm => gpu/drm/savage}/savage_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/savage}/savage_drv.h (100%)
 rename drivers/{char/drm => gpu/drm/savage}/savage_state.c (100%)
 create mode 100644 drivers/gpu/drm/sis/Makefile
 rename drivers/{char/drm => gpu/drm/sis}/sis_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/sis}/sis_drv.h (100%)
 rename drivers/{char/drm => gpu/drm/sis}/sis_mm.c (100%)
 create mode 100644 drivers/gpu/drm/tdfx/Makefile
 rename drivers/{char/drm => gpu/drm/tdfx}/tdfx_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/tdfx}/tdfx_drv.h (100%)
 create mode 100644 drivers/gpu/drm/via/Makefile
 rename drivers/{char/drm => gpu/drm/via}/via_3d_reg.h (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_dma.c (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_dmablit.c (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_dmablit.h (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_drv.c (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_drv.h (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_irq.c (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_map.c (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_mm.c (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_verifier.c (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_verifier.h (100%)
 rename drivers/{char/drm => gpu/drm/via}/via_video.c (100%)
 create mode 100644 include/drm/Kbuild
 rename {drivers/char => include}/drm/drm.h (100%)
 rename {drivers/char => include}/drm/drmP.h (100%)
 rename {drivers/char => include}/drm/drm_core.h (100%)
 rename {drivers/char => include}/drm/drm_hashtab.h (100%)
 rename {drivers/char => include}/drm/drm_memory.h (100%)
 rename {drivers/char => include}/drm/drm_memory_debug.h (100%)
 rename {drivers/char => include}/drm/drm_os_linux.h (100%)
 rename {drivers/char => include}/drm/drm_pciids.h (100%)
 rename {drivers/char => include}/drm/drm_sarea.h (100%)
 rename {drivers/char => include}/drm/drm_sman.h (100%)
 rename {drivers/char => include}/drm/i810_drm.h (100%)
 rename {drivers/char => include}/drm/i830_drm.h (100%)
 rename {drivers/char => include}/drm/i915_drm.h (100%)
 rename {drivers/char => include}/drm/mga_drm.h (100%)
 rename {drivers/char => include}/drm/r128_drm.h (100%)
 rename {drivers/char => include}/drm/radeon_drm.h (100%)
 rename {drivers/char => include}/drm/savage_drm.h (100%)
 rename {drivers/char => include}/drm/sis_drm.h (100%)
 rename {drivers/char => include}/drm/via_drm.h (100%)

commit c0e09200dc0813972442e550a5905a132768e56c
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu May 29 10:09:59 2008 +1000

    drm: reorganise drm tree to be more future proof.
    
    With the coming of kernel based modesetting and the memory manager stuff,
    the everything in one directory approach was getting very ugly and
    starting to be unmanageable.
    
    This restructures the drm along the lines of other kernel components.
    
    It creates a drivers/gpu/drm directory and moves the hw drivers into
    subdirectores. It moves the includes into an include/drm, and
    sets up the unifdef for the userspace headers we should be exporting.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
