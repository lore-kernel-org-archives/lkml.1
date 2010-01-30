Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589Ab0A3Xey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0A3Xey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 18:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131Ab0A3Xey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 18:34:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:43299 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab0A3Xex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 18:34:53 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 10:34:40 +1100
Message-ID: <1264894480.8287.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some more defconfig updates that I missed before LCA and a
few PCI related fixes, some of them actually fixing regressions and
one of them (the 4xx one) trivial enough that's really not worth
delaying it.

Cheers,
Ben.

The following changes since commit b04da8bfdfbbd79544cab2fadfdc12e87eb01600:
  Greg Kroah-Hartman (1):
        fnctl: f_modown should call write_lock_irqsave/restore

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (4):
      powerpc/pci: Add calls to set_pcie_port_type() and set_pcie_hotplug_bridge()
      powerpc/pci: Add missing hookup to pci_slot
      powerpc/pci: Add missing call to header fixup
      Merge commit 'jwb/merge' into merge

Josh Boyer (2):
      powerpc/44x: Update PowerPC 44x board defconfigs
      powerpc/40x: Update the PowerPC 40x board defconfigs

Stef van Os (1):
      powerpc/4xx: Add pcix type 1 transactions

 arch/powerpc/configs/40x/acadia_defconfig      |  241 ++++++++++++++-----
 arch/powerpc/configs/40x/ep405_defconfig       |  307 ++++++++++++++++++------
 arch/powerpc/configs/40x/hcu4_defconfig        |  256 +++++++++++++++-----
 arch/powerpc/configs/40x/kilauea_defconfig     |  140 ++++++++---
 arch/powerpc/configs/40x/makalu_defconfig      |  190 ++++++++++-----
 arch/powerpc/configs/40x/walnut_defconfig      |  257 +++++++++++++++-----
 arch/powerpc/configs/44x/arches_defconfig      |  135 ++++++++---
 arch/powerpc/configs/44x/bamboo_defconfig      |  255 +++++++++++++++-----
 arch/powerpc/configs/44x/canyonlands_defconfig |  141 ++++++++---
 arch/powerpc/configs/44x/ebony_defconfig       |  258 +++++++++++++++-----
 arch/powerpc/configs/44x/eiger_defconfig       |  128 +++++++---
 arch/powerpc/configs/44x/katmai_defconfig      |  253 +++++++++++++++-----
 arch/powerpc/configs/44x/rainier_defconfig     |  254 +++++++++++++++-----
 arch/powerpc/configs/44x/redwood_defconfig     |  274 +++++++++++++++------
 arch/powerpc/configs/44x/sam440ep_defconfig    |  284 +++++++++++++++-------
 arch/powerpc/configs/44x/sequoia_defconfig     |  202 +++++++++++-----
 arch/powerpc/configs/44x/taishan_defconfig     |  258 +++++++++++++++-----
 arch/powerpc/configs/44x/warp_defconfig        |  228 ++++++++++++------
 arch/powerpc/configs/ppc40x_defconfig          |  292 ++++++++++++++++-------
 arch/powerpc/configs/ppc44x_defconfig          |  309 +++++++++++++++++-------
 arch/powerpc/kernel/pci_of_scan.c              |   10 +
 arch/powerpc/sysdev/ppc4xx_pci.c               |    3 +-
 drivers/pci/probe.c                            |    4 +-
 include/linux/pci.h                            |    4 +
 24 files changed, 3409 insertions(+), 1274 deletions(-)


