Return-Path: <linux-kernel-owner+w=401wt.eu-S1763535AbYBTDqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763535AbYBTDqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYBTDqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:46:25 -0500
Received: from ozlabs.org ([203.10.76.45]:49196 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYBTDqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:46:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18363.41603.210217.163071@cargo.ozlabs.ibm.com>
Date: Wed, 20 Feb 2008 14:46:11 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get a few more bug and warning fixes for powerpc.  The diffstat is
bloated by the defconfig updates -- the actual code changes are only a
few dozen lines.

Thanks,
Paul.

 arch/powerpc/boot/Makefile             |    8 
 arch/powerpc/boot/dts/bamboo.dts       |    3 
 arch/powerpc/boot/dts/ebony.dts        |    2 
 arch/powerpc/boot/dts/katmai.dts       |    2 
 arch/powerpc/boot/dts/kilauea.dts      |    3 
 arch/powerpc/boot/dts/makalu.dts       |    3 
 arch/powerpc/boot/dts/rainier.dts      |    4 
 arch/powerpc/boot/dts/sequoia.dts      |    4 
 arch/powerpc/boot/dts/taishan.dts      |    4 
 arch/powerpc/configs/bamboo_defconfig  |   81 ++-
 arch/powerpc/configs/ebony_defconfig   |   79 ++-
 arch/powerpc/configs/ep405_defconfig   |   92 ++-
 arch/powerpc/configs/kilauea_defconfig |   69 ++
 arch/powerpc/configs/makalu_defconfig  |   69 ++
 arch/powerpc/configs/ppc44x_defconfig  |  904 ++++++++++++++++++++++++++++++++
 arch/powerpc/configs/rainier_defconfig |   82 ++-
 arch/powerpc/configs/sequoia_defconfig |   77 ++-
 arch/powerpc/configs/taishan_defconfig |   81 ++-
 arch/powerpc/configs/walnut_defconfig  |   81 ++-
 arch/powerpc/configs/warp_defconfig    |  139 +++--
 arch/powerpc/kernel/kprobes.c          |    9 
 arch/powerpc/kernel/prom.c             |   13 
 arch/powerpc/platforms/44x/Kconfig     |   10 
 arch/powerpc/platforms/pseries/power.c |    2 
 arch/ppc/platforms/4xx/ibm440ep.c      |    6 
 drivers/net/ibm_newemac/rgmii.c        |    1 
 26 files changed, 1497 insertions(+), 331 deletions(-)
 create mode 100644 arch/powerpc/configs/ppc44x_defconfig

Ananth N Mavinakayanahalli (1):
      [POWERPC] Kill sparse warnings in kprobes

Becky Bruce (1):
      [POWERPC] Fix dt_mem_next_cell() to read the full address

Josh Boyer (4):
      [POWERPC] 4xx: Update defconfigs for 2.6.25
      [POWERPC] 44x: Fix Kconfig formatting
      [POWERPC] 44x: Add multiplatform defconfig
      [POWERPC] Fix bootwrapper builds with older gcc versions

Stefan Roese (2):
      [POWERPC] net: NEWEMAC: Remove "rgmii-interface" from rgmii matching table
      [POWERPC] 4xx: Remove "i2c" and "xxmii-interface" device_types from dts

Stephen Rothwell (1):
      [POWERPC] Fix warning in pseries/power.c

Wolfgang Ocker (1):
      [POWERPC] PPC440EP Interrupt Triggering and Level Settings

