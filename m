Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYCYDcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYCYDcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 23:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbYCYDcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 23:32:19 -0400
Received: from ozlabs.org ([203.10.76.45]:39340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbYCYDcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 23:32:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18408.29239.941431.655259@cargo.ozlabs.ibm.com>
Date: Tue, 25 Mar 2008 14:32:07 +1100
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

once more.  Kumar sent me a defconfig update for the Freescale
platforms, and there is another 1-line fix from Grant Likely that only
affects MPC5200B machines.

Thanks,
Paul.

 arch/powerpc/boot/dts/lite5200b.dts          |    2 
 arch/powerpc/configs/ep8248e_defconfig       |   74 +++++++---
 arch/powerpc/configs/ep88xc_defconfig        |   56 +++++--
 arch/powerpc/configs/linkstation_defconfig   |  131 +++++++++++------
 arch/powerpc/configs/mpc7448_hpc2_defconfig  |  119 ++++++++++++----
 arch/powerpc/configs/mpc8272_ads_defconfig   |   75 ++++++++--
 arch/powerpc/configs/mpc8313_rdb_defconfig   |  114 ++++++++++-----
 arch/powerpc/configs/mpc8315_rdb_defconfig   |  110 ++++++++++-----
 arch/powerpc/configs/mpc832x_mds_defconfig   |  101 +++++++++----
 arch/powerpc/configs/mpc832x_rdb_defconfig   |  106 +++++++++-----
 arch/powerpc/configs/mpc834x_itx_defconfig   |  111 +++++++++------
 arch/powerpc/configs/mpc834x_itxgp_defconfig |  109 +++++++++-----
 arch/powerpc/configs/mpc834x_mds_defconfig   |  104 +++++++++-----
 arch/powerpc/configs/mpc836x_mds_defconfig   |  102 +++++++++----
 arch/powerpc/configs/mpc837x_mds_defconfig   |  197 ++++++++++++++------------
 arch/powerpc/configs/mpc837x_rdb_defconfig   |   83 +++++++----
 arch/powerpc/configs/mpc83xx_defconfig       |   88 ++++++++----
 arch/powerpc/configs/mpc8540_ads_defconfig   |  121 ++++++++++++----
 arch/powerpc/configs/mpc8544_ds_defconfig    |  127 ++++++++++++-----
 arch/powerpc/configs/mpc8560_ads_defconfig   |  126 +++++++++++++----
 arch/powerpc/configs/mpc8568mds_defconfig    |  106 ++++++++++----
 arch/powerpc/configs/mpc8572_ds_defconfig    |  127 ++++++++++++-----
 arch/powerpc/configs/mpc85xx_cds_defconfig   |  131 +++++++++++++----
 arch/powerpc/configs/mpc85xx_defconfig       |  111 ++++++++++-----
 arch/powerpc/configs/mpc8610_hpcd_defconfig  |  131 ++++++++++++++---
 arch/powerpc/configs/mpc8641_hpcn_defconfig  |  115 ++++++++++-----
 arch/powerpc/configs/mpc866_ads_defconfig    |  112 +++++++++++----
 arch/powerpc/configs/mpc885_ads_defconfig    |   56 +++++--
 arch/powerpc/configs/pq2fads_defconfig       |   89 +++++++++---
 arch/powerpc/configs/prpmc2800_defconfig     |  160 +++++++++++++++------
 arch/powerpc/configs/sbc834x_defconfig       |   78 +++++++---
 arch/powerpc/configs/sbc8548_defconfig       |  115 ++++++++++++---
 arch/powerpc/configs/sbc8560_defconfig       |  124 +++++++++++++---
 arch/powerpc/configs/storcenter_defconfig    |  102 ++++++++-----
 arch/powerpc/configs/stx_gp3_defconfig       |  154 +++++++++++++++-----
 arch/powerpc/configs/tqm8540_defconfig       |  133 +++++++++++++-----
 arch/powerpc/configs/tqm8541_defconfig       |  133 +++++++++++++-----
 arch/powerpc/configs/tqm8555_defconfig       |  133 +++++++++++++-----
 arch/powerpc/configs/tqm8560_defconfig       |  133 +++++++++++++-----
 39 files changed, 3032 insertions(+), 1267 deletions(-)

commit 5492a7e4cba8e38419d489f0865de0a67c737e8a
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Sat Mar 22 14:25:15 2008 +1100

    [POWERPC] mpc5200: Fix incorrect compatible string for the mdio node
    
    The MDIO node in the lite5200b.dts file needs to also claim compatibility
    with the older mpc5200 chip.  Otherwise the driver won't find the device.
    
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit eff2f1ec37c114fda63ac1dd15c9ca9ac7e68db4
Author: Kumar Gala <galak@kernel.crashing.org>
Date:   Mon Mar 24 08:56:06 2008 -0500

    [POWERPC] Update some defconfigs
    
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
