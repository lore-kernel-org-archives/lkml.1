Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYKKKW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYKKKW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYKKKWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:22:51 -0500
Received: from ozlabs.org ([203.10.76.45]:44498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbYKKKWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:22:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18713.23791.466776.67008@cargo.ozlabs.ibm.com>
Date: Tue, 11 Nov 2008 21:22:39 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

It's mostly defconfig updates, but there are also fixes for a few
regressions, oopses, serious bugs, and documentation errors on
powerpc.

Thanks,
Paul.

 Documentation/powerpc/booting-without-of.txt      |   65 +----
 arch/powerpc/boot/dts/gef_sbc610.dts              |    2 
 arch/powerpc/configs/83xx/asp8347_defconfig       |  121 +++++----
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |  158 +++++++-----
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |  158 +++++++-----
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |  125 +++++----
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |  136 ++++++----
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |  171 +++++++++----
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |  121 +++++----
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |  123 +++++----
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |  126 +++++----
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |  119 +++++----
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |  123 +++++----
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |  155 +++++++----
 arch/powerpc/configs/83xx/sbc834x_defconfig       |  119 +++++----
 arch/powerpc/configs/85xx/ksi8560_defconfig       |   87 ++++--
 arch/powerpc/configs/85xx/mpc8536_ds_defconfig    |  143 +++++++++--
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |   74 ++++-
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig    |  143 +++++++++--
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |   90 +++++--
 arch/powerpc/configs/85xx/mpc8568mds_defconfig    |   93 +++++--
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig    |  143 +++++++++--
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |   91 +++++--
 arch/powerpc/configs/85xx/sbc8548_defconfig       |   75 ++++--
 arch/powerpc/configs/85xx/sbc8560_defconfig       |   78 ++++--
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |  115 ++++++--
 arch/powerpc/configs/85xx/tqm8540_defconfig       |   91 +++++--
 arch/powerpc/configs/85xx/tqm8541_defconfig       |   96 +++++--
 arch/powerpc/configs/85xx/tqm8548_defconfig       |   98 +++++--
 arch/powerpc/configs/85xx/tqm8555_defconfig       |   96 +++++--
 arch/powerpc/configs/85xx/tqm8560_defconfig       |   96 +++++--
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |  281 +++++++++++++++------
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |  177 +++++++++----
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |  175 +++++++++----
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |  152 +++++++----
 arch/powerpc/configs/adder875_defconfig           |   69 +++--
 arch/powerpc/configs/c2k_defconfig                |  179 ++++++++-----
 arch/powerpc/configs/chrp32_defconfig             |  159 +++++++++---
 arch/powerpc/configs/ep8248e_defconfig            |  113 +++++---
 arch/powerpc/configs/ep88xc_defconfig             |   67 +++--
 arch/powerpc/configs/g5_defconfig                 |  142 ++++++++--
 arch/powerpc/configs/iseries_defconfig            |  114 ++++++--
 arch/powerpc/configs/linkstation_defconfig        |  122 +++++++--
 arch/powerpc/configs/maple_defconfig              |  142 ++++++++--
 arch/powerpc/configs/mgcoge_defconfig             |  234 ++++++++++++++---
 arch/powerpc/configs/mgsuvd_defconfig             |  107 +++++---
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |   78 ++++--
 arch/powerpc/configs/mpc8272_ads_defconfig        |  113 +++++---
 arch/powerpc/configs/mpc83xx_defconfig            |  156 +++++++----
 arch/powerpc/configs/mpc85xx_defconfig            |  145 +++++++++--
 arch/powerpc/configs/mpc866_ads_defconfig         |   77 ++++--
 arch/powerpc/configs/mpc86xx_defconfig            |  144 +++++++++--
 arch/powerpc/configs/mpc885_ads_defconfig         |   67 +++--
 arch/powerpc/configs/pmac32_defconfig             |  160 +++++++++---
 arch/powerpc/configs/ppc64_defconfig              |  174 ++++++++++---
 arch/powerpc/configs/ppc6xx_defconfig             |  286 +++++++++++++++------
 arch/powerpc/configs/pq2fads_defconfig            |  137 ++++++----
 arch/powerpc/configs/prpmc2800_defconfig          |  126 +++++++--
 arch/powerpc/configs/pseries_defconfig            |  169 ++++++++++--
 arch/powerpc/configs/storcenter_defconfig         |   83 ++++--
 arch/powerpc/include/asm/immap_cpm2.h             |    9 -
 arch/powerpc/include/asm/immap_qe.h               |    5 
 arch/powerpc/kernel/misc_32.S                     |    4 
 arch/powerpc/kernel/signal_32.c                   |   18 +
 drivers/watchdog/booke_wdt.c                      |    5 
 65 files changed, 5305 insertions(+), 2315 deletions(-)

Andreas Schwab (1):
      powerpc: Fix msr check in compat_sys_swapcontext

Kumar Gala (2):
      powerpc/fsl-booke: Fix synchronization bug w/local tlb invalidates
      powerpc: Updated Freescale PPC related defconfigs

Li Yang (1):
      powerpc: Update QE/CPM2 usb_ctlr structures for USB support

Martyn Welch (1):
      powerpc/86xx: Correct SOC bus-frequency in GE Fanuc SBC610 DTS

Matthias Fuchs (1):
      powerpc: Fix Book-E watchdog timer interval setting

Paul Mackerras (1):
      powerpc: Update desktop/server defconfigs

Trent Piepho (1):
      powerpc: Repair device bindings documentation

