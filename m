Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbZDWXeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbZDWXeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZDWXee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:34:34 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:38221 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753851AbZDWXed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:34:33 -0400
Date: Fri, 24 Apr 2009 09:33:29 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200904232333.n3NNXTKV005460@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68knommu arch fixes
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull to get a small set of fixes for the m68knommu arch,
and updates to the defconfigs.

Regards
Greg



The following changes since commit ccc5ff94c66e628d3c501b26ace5d4339667715d:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../mason/btrfs-unstable

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (9):
      m68knommu: fix missing .data.cacheline_aligned section
      m68knommu: remove unused kernel stats offsets
      m68knommu: fix DMA support for ColdFire
      m68knommu: update the defconfig for the ColdFire 5208evb board
      m68knommu: add a defconfig for the ColdFire M5272C3 board
      m68knommu: update the default config for the ColdFire 5249EVB.
      m68knommu: update the default config for the ColdFire 5257EVB board
      m68knommu: update the default config for the ColdFire 5307C3 board
      m68knommu: update the default config for the ColdFire 5407C3 board

Richard Retanubun (1):
      m68knommu: Fixed GPIO pin initialization for CONFIG_M5271 FEC.

 arch/m68knommu/Kconfig                    |    1 +
 arch/m68knommu/configs/m5208evb_defconfig |  163 +++++----
 arch/m68knommu/configs/m5249evb_defconfig |  268 ++++++++++---
 arch/m68knommu/configs/m5272c3_defconfig  |  645 +++++++++++++++++++++++++++++
 arch/m68knommu/configs/m5275evb_defconfig |  167 +++++----
 arch/m68knommu/configs/m5307c3_defconfig  |  231 ++++++++---
 arch/m68knommu/configs/m5407c3_defconfig  |  179 +++++----
 arch/m68knommu/kernel/asm-offsets.c       |    6 -
 arch/m68knommu/kernel/dma.c               |   37 ++-
 arch/m68knommu/kernel/vmlinux.lds.S       |    2 +
 arch/m68knommu/platform/527x/config.c     |    5 +
 11 files changed, 1346 insertions(+), 358 deletions(-)
 create mode 100644 arch/m68knommu/configs/m5272c3_defconfig
