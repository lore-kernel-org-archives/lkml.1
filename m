Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbYGXH0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbYGXH0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYGXH0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:26:08 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:60898 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750737AbYGXH0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:26:07 -0400
Date: Thu, 24 Jul 2008 17:22:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200807240722.m6O7MuPk025610@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68knommu arch updates
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull to get the m68knommu architecture updates.

Thanks, Greg.


The following changes since commit deca05c3e81df4fcc38aa891eb8d8add14bce68b:
  Greg Ungerer (1):
        m68knommu: change to a configs directory for board configurations

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (6):
      m68knommu: defconfig for M5249EVB board
      m68knommu: defconfig for M5275EVB board
      m68knommu: defconfig for M5307C3 board
      m68knommu: defconfig for M5407C3 board
      m68knommu: remove last use of CONFIG_FADS and CONFIG_RPXCLASSIC
      m68knommu: put ColdFire head code into .text.head section

Sebastian Siewior (11):
      m68knommu: Add Coldfire DMA Timer support
      m68knommu: m68knommu: add old stack trace method
      m68knommu: move code within time.c
      m68knommu: complete generic time
      m68knommu: add sched_clock() for the DMA timer
      m68knommu: add ffs and __ffs plattform which support ISA A+ or ISA C
      m68knommu: add byteswap assembly opcode for ISA A+
      m68knommu: add read_barrier_depends() and irqs_disabled_flags()
      m68knommu: MCF5307 PIT GENERIC_CLOCKEVENTS support
      m68knommu: fec: remove FADS
      m68knommu: remove RPXCLASSIC from the m68k tree

 arch/m68knommu/Kconfig                       |   15 +
 arch/m68knommu/Makefile                      |   11 +-
 arch/m68knommu/configs/m5249evb_defconfig    |  497 ++++++++++++++++++++
 arch/m68knommu/configs/m5275evb_defconfig    |  627 +++++++++++++++++++++++++
 arch/m68knommu/configs/m5307c3_defconfig     |  580 +++++++++++++++++++++++
 arch/m68knommu/configs/m5407c3_defconfig     |  641 ++++++++++++++++++++++++++
 arch/m68knommu/kernel/time.c                 |   40 +-
 arch/m68knommu/kernel/traps.c                |   38 ++-
 arch/m68knommu/kernel/vmlinux.lds.S          |    1 +
 arch/m68knommu/platform/coldfire/Makefile    |    2 +-
 arch/m68knommu/platform/coldfire/dma_timer.c |   84 ++++
 arch/m68knommu/platform/coldfire/head.S      |    3 +-
 arch/m68knommu/platform/coldfire/pit.c       |   91 ++++-
 drivers/net/fec.c                            |   54 +---
 include/asm-m68knommu/bitops.h               |   30 ++
 include/asm-m68knommu/byteorder.h            |   16 +-
 include/asm-m68knommu/commproc.h             |   19 -
 include/asm-m68knommu/system.h               |   11 +
 18 files changed, 2643 insertions(+), 117 deletions(-)
 create mode 100644 arch/m68knommu/configs/m5249evb_defconfig
 create mode 100644 arch/m68knommu/configs/m5275evb_defconfig
 create mode 100644 arch/m68knommu/configs/m5307c3_defconfig
 create mode 100644 arch/m68knommu/configs/m5407c3_defconfig
 create mode 100644 arch/m68knommu/platform/coldfire/dma_timer.c

