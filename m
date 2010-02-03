Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0BCTAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:00:41 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:56846 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab0BCTAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:00:38 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/3] OF Device tree merge patches
To: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       benh@kernel.crashing.org
Date: Wed, 03 Feb 2010 12:00:34 -0700
Message-ID: <20100203185753.26862.6818.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone.  Here are a few patches that I've got sitting in my
test-devicetree branch, but I haven't posted for review yet.  Please
take a look and let me know if they are okay.  Once I've collected
acks I'll move them over to my next-devicetree branch.

Thanks,
g.

---

Grant Likely (3):
      of/flattree: merge early_init_dt_scan_memory() common code
      of: add 'of_' prefix to machine_is_compatible()
      microblaze: remove early_init_dt_scan_cpus() and phyp_dump_*()


 arch/microblaze/include/asm/prom.h            |    4 
 arch/microblaze/kernel/prom.c                 |  284 -------------------------
 arch/powerpc/include/asm/prom.h               |    4 
 arch/powerpc/kernel/pci_64.c                  |    2 
 arch/powerpc/kernel/prom.c                    |  149 ++-----------
 arch/powerpc/platforms/85xx/xes_mpc85xx.c     |    4 
 arch/powerpc/platforms/cell/cbe_powerbutton.c |    2 
 arch/powerpc/platforms/cell/ras.c             |    2 
 arch/powerpc/platforms/pasemi/cpufreq.c       |    4 
 arch/powerpc/platforms/powermac/cpufreq_32.c  |   14 +
 arch/powerpc/platforms/powermac/cpufreq_64.c  |   14 +
 arch/powerpc/platforms/powermac/feature.c     |    2 
 arch/powerpc/platforms/powermac/smp.c         |   12 +
 arch/powerpc/platforms/powermac/time.c        |    8 -
 arch/powerpc/platforms/powermac/udbg_scc.c    |    6 -
 arch/powerpc/sysdev/grackle.c                 |    4 
 arch/sparc/kernel/prom_common.c               |   12 -
 drivers/char/hvc_beat.c                       |    2 
 drivers/gpu/drm/radeon/radeon_combios.c       |   44 ++--
 drivers/macintosh/adb.c                       |    4 
 drivers/macintosh/therm_pm72.c                |    8 -
 drivers/macintosh/therm_windtunnel.c          |    2 
 drivers/macintosh/via-pmu-backlight.c         |    8 -
 drivers/macintosh/via-pmu.c                   |    8 -
 drivers/macintosh/windfarm_core.c             |    6 -
 drivers/macintosh/windfarm_cpufreq_clamp.c    |    6 -
 drivers/macintosh/windfarm_lm75_sensor.c      |    6 -
 drivers/macintosh/windfarm_max6690_sensor.c   |    6 -
 drivers/macintosh/windfarm_pm112.c            |    2 
 drivers/macintosh/windfarm_pm121.c            |    2 
 drivers/macintosh/windfarm_pm81.c             |    4 
 drivers/macintosh/windfarm_pm91.c             |    2 
 drivers/macintosh/windfarm_smu_sensors.c      |    6 -
 drivers/net/mace.c                            |    2 
 drivers/of/Kconfig                            |    4 
 drivers/of/base.c                             |   98 ++++++++-
 drivers/of/fdt.c                              |   50 ++++
 drivers/serial/pmac_zilog.c                   |    6 -
 drivers/video/aty/aty128fb.c                  |   14 +
 drivers/video/aty/atyfb_base.c                |    8 -
 drivers/video/aty/radeon_backlight.c          |    6 -
 include/linux/of.h                            |    6 +
 include/linux/of_fdt.h                        |    5 
 sound/ppc/awacs.c                             |   24 +-
 sound/ppc/burgundy.c                          |    4 
 sound/ppc/pmac.c                              |   18 +-
 sound/soc/fsl/efika-audio-fabric.c            |    2 
 sound/soc/fsl/pcm030-audio-fabric.c           |    2 
 48 files changed, 317 insertions(+), 575 deletions(-)

-- 
Signature
