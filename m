Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbZA1FAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbZA1FAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbZA1FA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:00:26 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:48914 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750718AbZA1FAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:00:25 -0500
Date: Wed, 28 Jan 2009 14:59:59 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200901280459.n0S4xxpn028965@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68knommu arch fixes
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull to get m68knommu architecture fixes.

Thanks
Greg



The following changes since commit 5ee810072175042775e39bdd3eaaa68884c27805:
  Linus Torvalds (1):
        Fix "multiple definition of `debugfs_create_size_t'"

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Adrian Bunk (3):
      m68knommu: set NO_DMA
      m68knommu: remove obsolete and unused eLIA board
      m68knommu: remove the no longer used PCI support option

Greg Ungerer (4):
      m68knommu: fix cache flushing for the 527x ColdFire processors
      m68knommu: remove the obsolete and long unused comempci chip support
      m68knommu: fix syscall restarting
      uclinux: add process name to allocation error message

John Adamson (1):
      m68knommu: fix ColdFire 5272 serial baud rates in mcf.c

Matt Waddel (3):
      m68knommu: add ColdFire M532x to the FEC configuration options
      m68knommu: correct the mii calculations for 532x ColdFire FEC
      m68knommu: fix 5329 ColdFire periphal addressing

Sebastian Siewior (1):
      m68knommu: use one exist from execption

 arch/m68k/include/asm/cacheflush_no.h    |   11 +-
 arch/m68k/include/asm/dma-mapping_no.h   |    4 -
 arch/m68k/include/asm/system_no.h        |    2 +-
 arch/m68knommu/Kconfig                   |   27 +-
 arch/m68knommu/Makefile                  |    1 -
 arch/m68knommu/kernel/Makefile           |    1 -
 arch/m68knommu/kernel/comempci.c         |  980 ------------------------------
 arch/m68knommu/kernel/signal.c           |   15 +
 arch/m68knommu/kernel/syscalltable.S     |    2 +-
 arch/m68knommu/platform/5307/config.c    |    2 +-
 arch/m68knommu/platform/532x/config.c    |    8 +-
 arch/m68knommu/platform/coldfire/entry.S |   15 +-
 drivers/net/Kconfig                      |    2 +-
 drivers/net/fec.c                        |    2 +-
 drivers/serial/mcf.c                     |   11 +
 mm/nommu.c                               |    4 +-
 16 files changed, 52 insertions(+), 1035 deletions(-)
 delete mode 100644 arch/m68knommu/kernel/comempci.c
