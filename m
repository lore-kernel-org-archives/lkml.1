Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0CAXrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:47:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37219 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0CAXrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:47:09 -0500
Date: Mon, 1 Mar 2010 23:46:51 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm request 2
Message-ID: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1095652538-1267487211=:4099"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1095652538-1267487211=:4099
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Same tree as yesterday with a warning + PPC build fix + fix for build on 
x86 after PPC (I think I just validated Ingo).

The following changes since commit 60b341b778cc2929df16c0a504c91621b3c6a4ad:
  Linus Torvalds (1):
        Linux 2.6.33

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Alex Deucher (34):
      drm/radeon/kms: add radeon i2c algo
      drm/radeon/kms: add support for hw i2c on r1xx-r5xx
      drm/radeon/kms: add workaround for rn50/rv100 servers
      drm/radeon/kms: add support for hardcoded edids in rom (v2)
      drm/radeon/kms: clean up some low-hanging magic numbers
      drm/radeon/kms: rework pll algo selection
      drm/radeon/kms: add pll quirk for toshiba laptop panel
      drm/radeon/kms/atom: clean up spread spectrum code
      drm/radeon/kms/atom: add a helper function to get the radeon connector priv
      drm/radeon/kms/r600: reduce gpu cache flushing
      drm/radeon/kms: consolidate crtc count in rdev
      drm/radeon/kms: add functions to get current pcie lanes
      drm/radeon/kms: pull power mode info from bios tables (v3)
      drm/radeon/kms: add a power state type based on power state flags
      drm/radeon/kms: add code to select power state
      drm/radeon/kms: use power states for dynamic reclocking
      drm/radeon/kms: dynclks fixes
      drm/radeon/kms: take the pm mutex when using hw i2c
      drm/radeon/kms: update atombios.h to latest upstream.
      drm/radeon/kms: add initial Evergreen support (Radeon HD 5xxx)
      drm/radeon/kms: fix prescale calculations
      drm/radeon/kms/atom: replace 0/1 in crtc code with ATOM_DISABLE/ATOM_ENABLE
      drm/radeon/kms/evergreen: fix multi-head
      drm/radeon/kms/evergreen: adapt to i2c changes
      drm/radeon/r600: fix warnings in CS checker
      drm/radeon/kms: add LVDS pll quirk for Dell Studio 15
      drm/radeon/kms: remove HDP flushes from fence emit (v2)
      drm/radeon/kms: remove unused r600_gart_clear_page
      drm/radeon/rv740: fix backend setup
      drm/radeon: fixes for r6xx/r7xx gfx init
      drm/radeon/kms/evergreen: fix typo in cursor code
      drm/radeon/kms: update new pll algo
      drm/radeon/kms/atom: fix shr/shl ops
      drm/radeon: fix typo in Makefile

Andy Shevchenko (1):
      drivers/gpu/drm/drm_fb_helper.c: don't use private implementation of atoi()

Ben Skeggs (17):
      drm/nv50: switch to indirect push buffer controls
      drm/nouveau: remove PUSHBUF_CAL macro
      drm/nv50: make pushbuf dma object cover entire vm
      drm/nouveau: new gem pushbuf interface, bump to 0.0.16
      drm/nouveau: allow retrieval of vbios image from debugfs
      drm/nouveau: rename parsed_dcb_gpio to dcb_gpio_table
      drm/nouveau: merge parsed_dcb and bios_parsed_dcb into dcb_table
      drm/nouveau: merge nvbios and nouveau_bios_info
      drm/nouveau: reorganise bios header, add dcb connector type enums
      drm/nouveau: parse dcb gpio/connector tables after encoders
      drm/nouveau: check for known dcb connector types
      drm/nouveau: construct a connector table for cards that lack a real one
      drm/nouveau: use dcb connector table for creating drm connectors
      drm/nv50: enable hpd on any connector we know the gpio line for
      drm/nouveau: use dcb connector types throughout the driver
      drm/nouveau: support version 0x20 displayport tables
      drm/nouveau: report unknown connector state if lid closed

Chris Wilson (2):
      drm/i915: Replace open-coded eviction in i915_gem_idle()
      drm/i915: Record batch buffer following GPU error

Daniel Vetter (11):
      drm/i915: overlay: nuke readback to flush wc caches
      drm/i915: overlay: drop superflous gpu flushes
      drm/i915: move a gtt flush to the correct place
      drm/i915: blow away userspace mappings before fence change
      drm/i915: reuse i915_gem_object_put_fence_reg for fence stealing code
      drm/i915: fixup active list locking in object_unbind
      drm/i915: extract fence stealing code
      drm/i915: ensure lru ordering of fence_list
      drm/i915: reuse i915_gpu_idle helper
      drm/i915: clean-up i915_gem_flush_gpu_write_domain
      drm/i915: check for multiple write domains in pin_and_relocate

Dave Airlie (21):
      drm/radeon/kms: switch all KMS driver ioctls to unlocked.
      drm/radeon/kms: use udelay for short delays
      drm: switch all GEM/KMS ioctls to unlocked ioctl status.
      drm/kms: fix fb_changed = true else statement
      drm/radeon/kms: check for valid PCI bios and not OF rom
      drm/radeon/kms: set gart pages to invalid on unbind and point to dummy page
      drm/radeon/kms: flush HDP cache on GART table updates.
      [rfc] drm/radeon/kms: pm debugging check for vbl.
      Merge remote branch 'korg/drm-core-next' into drm-next-stage
      Merge remote branch 'anholt/drm-intel-next' into drm-next-stage
      fb: for framebuffer handover don't exit the loop early.
      Merge remote branch 'korg/drm-radeon-testing' into drm-next-stage
      Merge remote branch 'korg/drm-core-next' into drm-next-stage
      Merge remote branch 'nouveau/for-airlied' into drm-next-stage
      Merge remote branch 'anholt/drm-intel-next' into drm-next-stage
      drm/radeon: r100/r200 ums: block ability for userspace app to trash 0 page and beyond
      Merge branch 'drm-radeon-testing' of /ssd/git/drm-radeon-next into drm-next-stage
      vga_switcheroo: initial implementation (v15)
      Merge branch 'gpu-switcher' of /ssd/git//linux-2.6 into drm-next-stage
      drm/radeon/kms: bump the KMS version number for square tiling support.
      vga_switcheroo: fix build on platforms with no ACPI

Eric Anholt (13):
      drm/i915: Don't reserve compatibility fence regs in KMS mode.
      agp/intel: Add support for Sandybridge.
      drm/i915: Add initial bits for VGA modesetting bringup on Sandybridge.
      drm/i915: Set up fence registers on sandybridge.
      drm/i915: Fix sandybridge status page setup.
      agp/intel: Use a non-reserved value for the cache field of the PTEs.
      drm/i915: Disable the surface tile swizzling on Sandybridge.
      drm/i915: Correct locking in the modesetting failure path, fixing a BUG_ON.
      agp/intel: Add a new Sandybridge HB/IG PCI ID combo.
      drm/i915: Add a new mobile Sandybridge PCI ID.
      drm/i915: Disable the hangcheck reset on Sandybridge until we add support.
      drm/i915: Correct the Sandybridge chipset info structs.
      drm/i915: More s/IS_IRONLAKE/HAS_PCH_SPLIT for Sandybridge.

Jerome Glisse (9):
      drm/radeon/kms: bogus cs recorder utilities
      drm/radeon/kms: r600/r700 command stream checker
      drm/radeon/kms: fix r600/r700 cs checker to avoid double kfree
      drm/radeon/kms: fix indirect buffer management V2
      drm/radeon/kms: fix bo's fence association
      drm/radeon/kms: simplify memory controller setup V2
      drm/radeon/kms: fix R3XX/R4XX memory controller initialization
      drm/radeon/kms: force pinning buffer into visible VRAM
      drm/radeon/kms: initialize set_surface_reg reg for rs600 asic

Jesse Barnes (6):
      drm/i915: add dynamic performance control support for Ironlake
      drm/i915: fix drps disable so unload & re-load works
      drm/i915: provide FBC status in debugfs
      drm/i915: provide self-refresh status in debugfs
      drm/i915: give up on 8xx lid status
      drm/i915: enable/disable LVDS port at DPMS time

Li Peng (2):
      drm/i915: enable memory self refresh on 9xx
      drm/i915: Fix OGLC performance regression on 945

Luca Barbieri (3):
      drm: introduce drm_gem_object_[handle_]unreference_unlocked
      Use drm_gem_object_[handle_]unreference_unlocked where possible
      drm/nouveau: fix missing spin_unlock in failure path

Maarten Maathuis (2):
      drm/ttm: handle OOM in ttm_tt_swapout
      drm/nouveau: protect channel create/destroy and irq handler with a spinlock

Marcin Ko¶cielnicki (2):
      drm/nv50: Implement ctxprog/state generation.
      drm/nouveau: Fix noaccel/nofbaccel option descriptions.

Marcin Slusarz (3):
      drm/nouveau: fix pramdac_table range checking
      drm/nouveau: fix nouveau_i2c_find bounds checking
      drm/nouveau: fix i2ctable bounds checking

Marek Ol¹ák (1):
      drm/radeon/kms: add support for square microtiles on r3xx-r5xx

Matt Turner (2):
      drm/nouveau: use ALIGN instead of open coding it
      drm/radeon: use ALIGN instead of open coding it

Matthew Garrett (1):
      drm/i915: Deobfuscate the render p-state obfuscation

Michel Dänzer (1):
      drm/radeon/kms: Test rdev->bios centrally in combios_get_table_offset().

Owain Ainsworth (1):
      drm/i915: reduce some of the duplication of tiling checking

Pauli Nieminen (5):
      drm/radeon/kms: Create asic structure for r300 pcie cards.
      drm/radeon: Add asic hook for dma copy to r200 cards.
      drm: Add generic multipart buffer.
      drm/radeon: Fix memory allocation failures in the preKMS command stream checking.
      drm/radeon: Fix printf type warning in 64bit system.

Pavel Roskin (1):
      drm/kms: fix spelling of "CLOCK"

Rafa³ Mi³ecki (13):
      drm/radeon/kms: add dynamic engine reclocking (V9)
      drm/radeon/kms: don't set pcie lanes for ignored power_state
      drm/radeon/kms: get_power_state early, not when processing IRQ
      drm/radeon/kms: use wait queue (events) for VBLANK sync
      drm/radeon/kms: isolate audio engine management, change fini order
      drm/radeon/kms: accept slightly overclocked power modes
      drm/radeon/kms: simplify picking power state
      drm/radeon/kms: simplify storing current and requested PM mode
      drm/radeon/kms: for downclocking non-mobility check PERFORMANCE state
      drm/radeon/kms: implement reading active PCIE lanes on R600+
      drm/radeon/kms: do not preset audio stuff and start timer when not using audio
      Revert "drm/radeon/kms: disable HDMI audio for now on rv710/rv730"
      drm/radeon/kms: do not disable audio engine twice

Randy Dunlap (1):
      drm/ttm: fix function prototype to match implementation

Zhao Yakui (1):
      drm/i915: Use a dmi quirk to skip a broken SDVO TV output.

Zhenyu Wang (4):
      drm/i915: Keep MCHBAR always enabled
      agp/intel: official names for Pineview and Ironlake
      drm/i915, agp/intel: Fix stolen memory size on Sandybridge
      drm/i915: Add dependency on the intel agp module

 drivers/char/agp/intel-agp.c                    |  123 +-
 drivers/gpu/drm/Makefile                        |    2 +-
 drivers/gpu/drm/drm_buffer.c                    |  184 +
 drivers/gpu/drm/drm_crtc_helper.c               |    6 +-
 drivers/gpu/drm/drm_drv.c                       |   44 +-
 drivers/gpu/drm/drm_edid.c                      |   30 +-
 drivers/gpu/drm/drm_fb_helper.c                 |   26 +-
 drivers/gpu/drm/drm_gem.c                       |   70 +-
 drivers/gpu/drm/i915/i915_debugfs.c             |  253 +-
 drivers/gpu/drm/i915/i915_dma.c                 |  326 +-
 drivers/gpu/drm/i915/i915_drv.c                 |   27 +-
 drivers/gpu/drm/i915/i915_drv.h                 |   69 +-
 drivers/gpu/drm/i915/i915_gem.c                 |  430 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c          |  169 +-
 drivers/gpu/drm/i915/i915_irq.c                 |  313 +-
 drivers/gpu/drm/i915/i915_reg.h                 |  170 +-
 drivers/gpu/drm/i915/i915_suspend.c             |   10 +
 drivers/gpu/drm/i915/intel_bios.c               |    3 +-
 drivers/gpu/drm/i915/intel_crt.c                |   14 +-
 drivers/gpu/drm/i915/intel_display.c            |  216 +-
 drivers/gpu/drm/i915/intel_dp.c                 |    6 +-
 drivers/gpu/drm/i915/intel_drv.h                |    2 +
 drivers/gpu/drm/i915/intel_fb.c                 |    2 +
 drivers/gpu/drm/i915/intel_hdmi.c               |    4 +-
 drivers/gpu/drm/i915/intel_i2c.c                |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c               |   41 +-
 drivers/gpu/drm/i915/intel_overlay.c            |   29 +-
 drivers/gpu/drm/i915/intel_sdvo.c               |   23 +-
 drivers/gpu/drm/nouveau/Makefile                |    2 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c          |  160 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c          |  339 +-
 drivers/gpu/drm/nouveau/nouveau_bios.h          |  126 +-
 drivers/gpu/drm/nouveau/nouveau_calc.c          |    4 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c       |   39 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c     |  167 +-
 drivers/gpu/drm/nouveau/nouveau_connector.h     |    3 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c       |   24 +
 drivers/gpu/drm/nouveau/nouveau_display.c       |    7 +-
 drivers/gpu/drm/nouveau/nouveau_dma.c           |  108 +-
 drivers/gpu/drm/nouveau/nouveau_dma.h           |   21 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c           |   13 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h           |   53 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c         |    6 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c           |  508 +-
 drivers/gpu/drm/nouveau/nouveau_hw.c            |    6 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.c           |   10 +-
 drivers/gpu/drm/nouveau/nouveau_irq.c           |    5 +
 drivers/gpu/drm/nouveau/nouveau_notifier.c      |    9 +-
 drivers/gpu/drm/nouveau/nouveau_state.c         |   40 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c             |    4 +-
 drivers/gpu/drm/nouveau/nv04_dac.c              |    8 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c              |    4 +-
 drivers/gpu/drm/nouveau/nv04_display.c          |   49 +-
 drivers/gpu/drm/nouveau/nv04_fbcon.c            |    2 +-
 drivers/gpu/drm/nouveau/nv04_fifo.c             |    5 +
 drivers/gpu/drm/nouveau/nv04_tv.c               |    2 +-
 drivers/gpu/drm/nouveau/nv17_tv.c               |    6 +-
 drivers/gpu/drm/nouveau/nv40_fifo.c             |    5 +
 drivers/gpu/drm/nouveau/nv50_crtc.c             |    4 +-
 drivers/gpu/drm/nouveau/nv50_dac.c              |    4 +-
 drivers/gpu/drm/nouveau/nv50_display.c          |   54 +-
 drivers/gpu/drm/nouveau/nv50_fbcon.c            |    2 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c             |   13 +-
 drivers/gpu/drm/nouveau/nv50_graph.c            |   74 +-
 drivers/gpu/drm/nouveau/nv50_grctx.c            | 2367 ++++++++
 drivers/gpu/drm/nouveau/nv50_instmem.c          |    2 +-
 drivers/gpu/drm/radeon/Makefile                 |    9 +-
 drivers/gpu/drm/radeon/atom.c                   |    4 -
 drivers/gpu/drm/radeon/atombios.h               | 7300 +++++++++++++----------
 drivers/gpu/drm/radeon/atombios_crtc.c          |  456 ++-
 drivers/gpu/drm/radeon/atombios_dp.c            |   64 +-
 drivers/gpu/drm/radeon/avivod.h                 |    2 +
 drivers/gpu/drm/radeon/evergreen.c              |  767 +++
 drivers/gpu/drm/radeon/evergreen_reg.h          |  176 +
 drivers/gpu/drm/radeon/r100.c                   |  176 +-
 drivers/gpu/drm/radeon/r200.c                   |   46 +
 drivers/gpu/drm/radeon/r300.c                   |  157 +-
 drivers/gpu/drm/radeon/r300_cmdbuf.c            |  280 +-
 drivers/gpu/drm/radeon/r300_reg.h               |    2 +
 drivers/gpu/drm/radeon/r420.c                   |   49 +-
 drivers/gpu/drm/radeon/r500_reg.h               |  100 +-
 drivers/gpu/drm/radeon/r520.c                   |   21 +-
 drivers/gpu/drm/radeon/r600.c                   |  190 +-
 drivers/gpu/drm/radeon/r600_audio.c             |   21 +-
 drivers/gpu/drm/radeon/r600_blit.c              |    2 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c          |   17 +-
 drivers/gpu/drm/radeon/r600_blit_shaders.c      |   10 -
 drivers/gpu/drm/radeon/r600_cp.c                |  262 +-
 drivers/gpu/drm/radeon/r600_cs.c                |  831 +++-
 drivers/gpu/drm/radeon/r600d.h                  |  467 ++-
 drivers/gpu/drm/radeon/radeon.h                 |  167 +-
 drivers/gpu/drm/radeon/radeon_agp.c             |    4 +
 drivers/gpu/drm/radeon/radeon_asic.h            |  172 +-
 drivers/gpu/drm/radeon/radeon_atombios.c        |  435 ++-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |  257 +
 drivers/gpu/drm/radeon/radeon_bios.c            |   50 +-
 drivers/gpu/drm/radeon/radeon_clocks.c          |   18 +-
 drivers/gpu/drm/radeon/radeon_combios.c         |  290 +-
 drivers/gpu/drm/radeon/radeon_connectors.c      |   20 +-
 drivers/gpu/drm/radeon/radeon_cp.c              |    1 +
 drivers/gpu/drm/radeon/radeon_cs.c              |    7 +-
 drivers/gpu/drm/radeon/radeon_cursor.c          |   50 +-
 drivers/gpu/drm/radeon/radeon_device.c          |  235 +-
 drivers/gpu/drm/radeon/radeon_display.c         |  332 +-
 drivers/gpu/drm/radeon/radeon_drv.c             |   14 +-
 drivers/gpu/drm/radeon/radeon_drv.h             |   46 +-
 drivers/gpu/drm/radeon/radeon_encoders.c        |  354 +-
 drivers/gpu/drm/radeon/radeon_family.h          |    5 +
 drivers/gpu/drm/radeon/radeon_fb.c              |   12 +-
 drivers/gpu/drm/radeon/radeon_gart.c            |   32 +-
 drivers/gpu/drm/radeon/radeon_gem.c             |   36 +-
 drivers/gpu/drm/radeon/radeon_i2c.c             |  768 +++-
 drivers/gpu/drm/radeon/radeon_kms.c             |   27 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |   29 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   20 +
 drivers/gpu/drm/radeon/radeon_mode.h            |   55 +-
 drivers/gpu/drm/radeon/radeon_object.c          |    3 +-
 drivers/gpu/drm/radeon/radeon_pm.c              |  399 ++-
 drivers/gpu/drm/radeon/radeon_reg.h             |   50 +-
 drivers/gpu/drm/radeon/radeon_ring.c            |   67 +
 drivers/gpu/drm/radeon/radeon_state.c           |  203 +-
 drivers/gpu/drm/radeon/radeon_test.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c             |   12 +-
 drivers/gpu/drm/radeon/reg_srcs/r600            |  837 +++
 drivers/gpu/drm/radeon/rs400.c                  |   39 +-
 drivers/gpu/drm/radeon/rs600.c                  |   56 +-
 drivers/gpu/drm/radeon/rs690.c                  |   41 +-
 drivers/gpu/drm/radeon/rv515.c                  |   21 +-
 drivers/gpu/drm/radeon/rv770.c                  |  259 +-
 drivers/gpu/drm/radeon/rv770d.h                 |    2 +
 drivers/gpu/drm/ttm/ttm_tt.c                    |   18 +-
 drivers/gpu/vga/Kconfig                         |   13 +
 drivers/gpu/vga/Makefile                        |    1 +
 drivers/gpu/vga/vga_switcheroo.c                |  450 ++
 drivers/video/console/fbcon.c                   |   18 +
 drivers/video/fbmem.c                           |    1 -
 include/drm/drmP.h                              |   28 +-
 include/drm/drm_buffer.h                        |  148 +
 include/drm/drm_crtc.h                          |    2 +
 include/drm/drm_edid.h                          |    3 +
 include/drm/drm_pciids.h                        |   36 +
 include/drm/nouveau_drm.h                       |   86 +-
 include/drm/radeon_drm.h                        |    1 +
 include/drm/ttm/ttm_bo_driver.h                 |    2 +-
 include/linux/fb.h                              |    2 +
 include/linux/vga_switcheroo.h                  |   57 +
 146 files changed, 18177 insertions(+), 6374 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_buffer.c
 create mode 100644 drivers/gpu/drm/nouveau/nv50_grctx.c
 create mode 100644 drivers/gpu/drm/radeon/evergreen.c
 create mode 100644 drivers/gpu/drm/radeon/evergreen_reg.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_atpx_handler.c
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/r600
 create mode 100644 drivers/gpu/vga/vga_switcheroo.c
 create mode 100644 include/drm/drm_buffer.h
 create mode 100644 include/linux/vga_switcheroo.h
--29444707-1095652538-1267487211=:4099--
