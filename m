Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZFTFXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZFTFXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 01:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZFTFXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 01:23:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35509 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZFTFXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 01:23:41 -0400
Date: Sat, 20 Jun 2009 06:23:41 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm: previous pull req + 1.
Message-ID: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-991109102-1245475421=:27130"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-991109102-1245475421=:27130
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This is the same tree from the previous pull request + the fix from Pierre 
that actually makes the PAE/GEM combination on i965 work. \o/

Dave.

 drivers/char/agp/agp.h                   |   12 +-
 drivers/char/agp/ali-agp.c               |   28 +-
 drivers/char/agp/amd-k7-agp.c            |    2 +-
 drivers/char/agp/amd64-agp.c             |    2 +-
 drivers/char/agp/ati-agp.c               |   23 +-
 drivers/char/agp/backend.c               |    8 +-
 drivers/char/agp/efficeon-agp.c          |    5 +-
 drivers/char/agp/generic.c               |   69 ++---
 drivers/char/agp/hp-agp.c                |    9 +-
 drivers/char/agp/i460-agp.c              |   47 ++--
 drivers/char/agp/intel-agp.c             |   49 ++--
 drivers/char/agp/nvidia-agp.c            |    2 +-
 drivers/char/agp/parisc-agp.c            |   20 +-
 drivers/char/agp/sgi-agp.c               |    9 +-
 drivers/char/agp/sworks-agp.c            |    2 +-
 drivers/char/agp/uninorth-agp.c          |   30 ++-
 drivers/gpu/drm/drm_agpsupport.c         |   14 +-
 drivers/gpu/drm/drm_auth.c               |    4 +-
 drivers/gpu/drm/drm_bufs.c               |  140 ++++------
 drivers/gpu/drm/drm_context.c            |    4 +-
 drivers/gpu/drm/drm_debugfs.c            |    9 +-
 drivers/gpu/drm/drm_dma.c                |   31 +--
 drivers/gpu/drm/drm_drawable.c           |   25 +-
 drivers/gpu/drm/drm_drv.c                |   18 +-
 drivers/gpu/drm/drm_edid.c               |  100 ++++---
 drivers/gpu/drm/drm_fops.c               |    8 +-
 drivers/gpu/drm/drm_gem.c                |    8 +-
 drivers/gpu/drm/drm_hashtab.c            |    6 +-
 drivers/gpu/drm/drm_ioctl.c              |   14 +-
 drivers/gpu/drm/drm_irq.c                |   44 +--
 drivers/gpu/drm/drm_memory.c             |   33 +--
 drivers/gpu/drm/drm_mm.c                 |   48 +---
 drivers/gpu/drm/drm_pci.c                |   53 +----
 drivers/gpu/drm/drm_proc.c               |    8 +-
 drivers/gpu/drm/drm_scatter.c            |   33 +--
 drivers/gpu/drm/drm_sman.c               |   29 +-
 drivers/gpu/drm/drm_stub.c               |   19 +-
 drivers/gpu/drm/drm_vm.c                 |   12 +-
 drivers/gpu/drm/i810/i810_dma.c          |    6 +-
 drivers/gpu/drm/i830/i830_dma.c          |    6 +-
 drivers/gpu/drm/i915/i915_dma.c          |   45 +--
 drivers/gpu/drm/i915/i915_drv.h          |    2 +
 drivers/gpu/drm/i915/i915_gem.c          |   86 ++++--
 drivers/gpu/drm/i915/i915_gem_debugfs.c  |    4 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c   |   67 ++++-
 drivers/gpu/drm/i915/i915_mem.c          |   24 +-
 drivers/gpu/drm/i915/intel_bios.c        |    6 +-
 drivers/gpu/drm/i915/intel_display.c     |   20 +-
 drivers/gpu/drm/i915/intel_fb.c          |    6 +-
 drivers/gpu/drm/i915/intel_tv.c          |   11 +-
 drivers/gpu/drm/mga/mga_dma.c            |   14 +-
 drivers/gpu/drm/r128/r128_cce.c          |   12 +-
 drivers/gpu/drm/r128/r128_state.c        |   84 +++---
 drivers/gpu/drm/radeon/r100.c            |   85 +++---
 drivers/gpu/drm/radeon/r300.c            |  478 ++++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/r300.h            |   36 +++
 drivers/gpu/drm/radeon/radeon.h          |    9 +-
 drivers/gpu/drm/radeon/radeon_asic.h     |   15 +-
 drivers/gpu/drm/radeon/radeon_atombios.c |    2 -
 drivers/gpu/drm/radeon/radeon_combios.c  |    9 +
 drivers/gpu/drm/radeon/radeon_cp.c       |    9 +-
 drivers/gpu/drm/radeon/radeon_device.c   |    4 +
 drivers/gpu/drm/radeon/radeon_display.c  |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_i2c.c      |    6 +-
 drivers/gpu/drm/radeon/radeon_kms.c      |    4 +-
 drivers/gpu/drm/radeon/radeon_mem.c      |   24 +-
 drivers/gpu/drm/radeon/radeon_reg.h      |    1 +
 drivers/gpu/drm/radeon/radeon_state.c    |   16 +-
 drivers/gpu/drm/radeon/radeon_ttm.c      |    8 +-
 drivers/gpu/drm/radeon/rv515.c           |   58 ++++
 drivers/gpu/drm/savage/savage_bci.c      |   21 +-
 drivers/gpu/drm/savage/savage_state.c    |   17 +-
 drivers/gpu/drm/sis/sis_drv.c            |    6 +-
 drivers/gpu/drm/ttm/ttm_agp_backend.c    |    3 +-
 drivers/gpu/drm/ttm/ttm_bo.c             |   11 +-
 drivers/gpu/drm/ttm/ttm_tt.c             |   11 +-
 drivers/gpu/drm/via/via_map.c            |    8 +-
 include/drm/drmP.h                       |   52 ----
 include/drm/drm_edid.h                   |   92 +++---
 include/drm/drm_memory_debug.h           |  309 -------------------
 include/drm/drm_mm.h                     |   21 +-
 include/linux/agp_backend.h              |    2 +-
 83 files changed, 1391 insertions(+), 1300 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/r300.h
 delete mode 100644 include/drm/drm_memory_debug.h

commit 0b7af262aba912f52bc6ef76f1bc0960b01b8502
Author: Pierre Willenbrock <pierre@pirsoft.de>
Date:   Fri Jun 19 18:31:47 2009 +0200

    agp/intel: Make intel_i965_mask_memory use dma_addr_t for physical addresses
    
    Otherwise, the high bits to be stuffed in the unused lower bits of the
    page address are lost.
    
    Signed-off-by: Pierre Willenbrock <pierre@pirsoft.de>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a95fe463e73b8c7b2d97606ac86ce261f1270726
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jun 19 10:52:57 2009 +1000

    agp: add user mapping support to ATI AGP bridge.
    
    This should fix TTM/KMS on some of the original ATI IGP chipsets.
    (rs100/rs200)
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 95934f939c46ea2b37f3c91a4f8c82e003727761
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jun 19 10:29:20 2009 +1000

    drm/i915: enable GEM on PAE.
    
    In theory now that the AGP subsystem is using struct page, we should
    have on problems enabling GEM on PAE systems.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fc436d9d3720b382566e03bef2d7391a58714999
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jun 19 10:22:21 2009 +1000

    drm/radeon: fix unused variables warning
    
    just remove i variable left over from previous code.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 07613ba2f464f59949266f4337b75b91eb610795
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jun 12 14:11:41 2009 +1000

    agp: switch AGP to use page array instead of unsigned long array
    
    This switches AGP to use an array of pages for tracking the
    pages allocated to the GART. This should enable GEM on PAE to work
    a lot better as we can pass highmem pages to the PAT code and it will
    do the right thing with them.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2908826d045a89805714e0a3055a99dc40565d41
Author: Ondrej Zary <linux@rainbow-software.org>
Date:   Wed Jun 10 12:41:11 2009 -0700

    agpgart: detected ALi M???? chipset with M1621
    
    Add M1621 chipset name to ali-agp, preventing "Detected ALi M???? chipset"
    message.
    
    Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 068a117ca38f27c9641db7642f24fe9270d9424e
Author: Jerome Glisse <glisse@freedesktop.org>
Date:   Wed Jun 17 13:28:30 2009 +0200

    drm/radeon: command stream checker for r3xx-r5xx hardware
    
    For security purpose we want to make sure the userspace process doesn't
    access memory beyond buffer it owns. To achieve this we need to check
    states the userspace program. For color buffer and zbuffer we check that
    the clipping register will discard access beyond buffers set as color
    or zbuffer. For vertex buffer we check that no vertex fetch will happen
    beyond buffer end. For texture we check various texture states (number
    of mipmap level, texture size, texture depth, ...) to compute the amount
    of memory the texture fetcher might access.
    
    The command stream checking impact the performances so far quick benchmark
    shows an average of 3% decrease in fps of various applications. It can
    be optimized a bit more by caching result of checking and thus avoid a
    full recheck if no states changed since last check.
    
    Note that this patch is still incomplete on checking side as it doesn't
    check 2d rendering states.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8b5c744485b75d940ccb1c83c9a358b20eb91346
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Wed Jun 17 18:28:38 2009 +0200

    drm/radeon: Fully initialize LVDS info also when we can't get it from the ROM.
    
    This makes the panel on my PowerBook light up.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4e484e7dc5856ff5086b6329d82e36d4adaf1f02
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Jun 16 17:29:06 2009 +0200

    radeon: Fix CP byte order on big endian architectures with KMS.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 62369028c7e2039b821799b3db52f0d622f0e8b5
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Mon Jun 15 16:56:15 2009 +0200

    agp/uninorth: Handle user memory types.
    
    This adds support for TTM to the uninorth AGP bridge.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 46f4b3eab73e621bc239bfa62ebdc44dcc0a877a
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Mon Jun 15 16:56:13 2009 +0200

    drm/ttm: Add some powerpc cache flush code.
    
    Optimise the powerpc flushing path for TTM.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 919f32f1df228723f66bf5c5aed23e0ab076b1a1
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Mon Jun 15 16:56:09 2009 +0200

    radeon: Enable modesetting on non-x86.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 55c93278ec03c349af7b01933655b31c7f740df4
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Mon Jun 15 16:56:11 2009 +0200

    drm/radeon: Respect AGP cant_use_aperture flag.
    
    Some AGP devices can't map the aperture, radeon needs to tell TTM this.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0454beab0f6bc6d350860abd549b86959d2f6f40
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Mon Jun 15 16:56:07 2009 +0200

    drm: EDID endianness fixes.
    
    Mostly replacing bitfields with explicit masks and shifts.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 00fa28ae29f70c9f26023f9922c4d2e1ca1297e3
Author: Dave Airlie <airlied@itt42.(none)>
Date:   Thu Jun 18 18:08:33 2009 +1000

    drm/radeon: this VRAM vs aperture test is wrong, just remove it.
    
    Its quite valid to have VRAM < aperture size.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 87ef92092fd092936535ba057ee19b97bb6a709a
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jun 17 12:29:57 2009 +0200

    drm/ttm: fix an error path to exit function correctly
    
    Just a goto instead of a direct exit.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 89579f778266d5a4d08d0c64c46b1565218de9f9
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jun 17 12:29:56 2009 +0200

    drm: Apply "Memory fragmentation from lost alignment blocks"
    
    also for the atomic path by using a common code-path.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 78ecf091aa592a9e160ebbbfa5873c2bb2e2d0f8
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jun 17 12:29:55 2009 +0200

    ttm: Return -ERESTART when a signal interrupts bo eviction.
    
    A bug caused the ttm code to just terminate the wait when a signal
    was received while waiting for the GPU to release a buffer object that
    was to be evicted.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9a298b2acd771d8a5c0004d8f8e4156c65b11f6b
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Mar 24 12:23:04 2009 -0700

    drm: Remove memory debugging infrastructure.
    
    It hasn't been used in ages, and having the user tell your how much
    memory is being freed at free time is a recipe for disaster even if it
    was ever used.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 52dc7d32b88156248167864f77a9026abe27b432
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sat Jun 6 09:46:01 2009 +0100

    drm/i915: Clear fence register on tiling stride change.
    
    The fence register value also depends upon the stride of the object, so we
    need to clear the fence if that is changed as well.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    [anholt: Added 8xx and 965 paths, and renamed the confusing
    i915_gem_object_tiling_ok function to i915_gem_object_fence_offset_ok]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 8c4b8c3f34de4e2da20df042bba173fe557f8b45
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Jun 17 22:08:52 2009 +0100

    drm/i915: Install fence register for tiled scanout on i915
    
    With the work by Jesse Barnes to eliminate allocation of fences during
    execbuffer, it becomes possible to write to the scan-out buffer with it
    never acquiring a fence (simply by only ever writing to the object using
    tiled GPU commands and never writing to it via the GTT). So for pre-i965
    chipsets which require fenced access for tiled scan-out buffers, we need
    to obtain a fence register.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit d78b47b9a527bf46cb6081555847facd6efd5f81
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Jun 17 21:52:49 2009 +0100

    drm/i915: detach/attach get/put pages symmetry
    
    After performing an operation over the page list for a buffer retrieved by
    i915_gem_object_get_pages() the pages need to be returned with
    i915_gem_object_put_pages(). This was not being observed for the phys
    objects which were thus leaking references to their backing pages.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    CC: Dave Airlie <airlied@gmail.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 76cff81ad1cfa3bd8b52b5e4510702ce2ed28335
Author: Ben Gamari <bgamari.foss@gmail.com>
Date:   Wed Jun 10 18:26:20 2009 -0400

    drm/i915: A few debugfs formatting fixes
    
    Signed-Off-By: Ben Gamari <bgamari.foss@gmail.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 049b77cb2ad8bd36308a4a424ca4f2eb4d65d2af
Author: Ben Gamari <bgamari.foss@gmail.com>
Date:   Thu Jun 11 00:44:26 2009 -0400

    drm/i915: Warn when inteldrmfb fails to restore its framebuffer config
    
    While sifting through the inteldrmfb code trying to solve #22040 I found that
    the fb restore path doesn't check the return value of
    drm_crtc_helper_set_config(), which seems to have all sorts of potential
    failure modes. We should warn someone if one of these is triggered.
    
    Signed-Off-By: Ben Gamari <bgamari.foss@gmail.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    [anholt: hand-applied, failures are mine]
    Signed-off-by: Eric Anholt <eric@anholt.net>
--29444707-991109102-1245475421=:27130--
