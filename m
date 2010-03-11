Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab0CKNmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:42:13 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61272 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab0CKNmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:42:11 -0500
Message-ID: <4B98F32D.8020906@monstr.eu>
Date: Thu, 11 Mar 2010 14:42:05 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.34-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Microblaze changes to your tree. There is support for PCI 
and new DMA interface.

Thanks,
Michal


The following changes since commit 522dba7134d6b2e5821d3457f7941ec34f668e6d:
   Linus Torvalds (1):
         Merge branch 'for-linus' of 
git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Frans Pop (1):
       microblaze: remove trailing space in messages

Michal Simek (26):
       microblaze: Support DMA
       microblaze: Implement __dma_sync_page
       microblaze: Add {z,}alloc_maybe_bootmem functions
       microblaze: Add irq_create_{of_,}mapping functions
       microblaze: io.h include asm-generic/iomap.h
       microblaze: Add pci.h
       microblaze: Add pci-bridge.h
       microblaze: Add core PCI files
       microblaze: Enable PCI, missing files
       microblaze: Add support for Xilinx PCI host bridge
       microblaze: Add support from PREEMPT
       microblaze: Move cache function to cache.c
       microblaze: Preliminary support for dma drivers
       microblaze: Change temp register for cmdline
       microblaze: Use generic show_mem()
       microblaze: Preliminary support for dma drivers
       microblaze: Add define for ASM_LOOP
       microblaze: Remove VMALLOC_VMADDR
       microblaze: Remove ancient Kconfig option for consistent mapping
       microblaze: pgtable.h: move consistent functions
       microblaze: Add consistent code
       microblaze: Fix dma alloc and free coherent dma functions
       microblaze: PCI early support for noMMU system
       microblaze: Simplify entry.S - save/restore r3/r4 - ret_from_trap
       microblaze: Save current task directly
       microblaze: entry.S use delay slot for return handlers

  arch/microblaze/Kconfig                   |   64 +-
  arch/microblaze/Makefile                  |    1 +
  arch/microblaze/include/asm/device.h      |    4 +
  arch/microblaze/include/asm/dma-mapping.h |  154 +++-
  arch/microblaze/include/asm/io.h          |   31 +-
  arch/microblaze/include/asm/irq.h         |   37 +-
  arch/microblaze/include/asm/page.h        |   12 +-
  arch/microblaze/include/asm/pci-bridge.h  |  195 ++++
  arch/microblaze/include/asm/pci.h         |  178 ++++-
  arch/microblaze/include/asm/pgalloc.h     |    2 +-
  arch/microblaze/include/asm/pgtable.h     |   40 +-
  arch/microblaze/include/asm/prom.h        |   15 +
  arch/microblaze/include/asm/system.h      |    3 +
  arch/microblaze/include/asm/tlbflush.h    |    2 +-
  arch/microblaze/kernel/Makefile           |    2 +-
  arch/microblaze/kernel/asm-offsets.c      |    1 +
  arch/microblaze/kernel/cpu/cache.c        |  211 +++-
  arch/microblaze/kernel/dma.c              |  156 +++
  arch/microblaze/kernel/entry.S            |  116 +-
  arch/microblaze/kernel/head.S             |   13 +-
  arch/microblaze/kernel/irq.c              |   15 +
  arch/microblaze/kernel/setup.c            |   45 +-
  arch/microblaze/mm/Makefile               |    2 +-
  arch/microblaze/mm/consistent.c           |  246 +++++
  arch/microblaze/mm/init.c                 |   39 +-
  arch/microblaze/mm/pgtable.c              |    2 +-
  arch/microblaze/pci/Makefile              |    6 +
  arch/microblaze/pci/indirect_pci.c        |  163 +++
  arch/microblaze/pci/iomap.c               |   39 +
  arch/microblaze/pci/pci-common.c          | 1642 
+++++++++++++++++++++++++++++
  arch/microblaze/pci/pci_32.c              |  430 ++++++++
  arch/microblaze/pci/xilinx_pci.c          |  168 +++
  drivers/pci/Makefile                      |    1 +
  33 files changed, 3840 insertions(+), 195 deletions(-)
  create mode 100644 arch/microblaze/kernel/dma.c
  create mode 100644 arch/microblaze/mm/consistent.c
  create mode 100644 arch/microblaze/pci/Makefile
  create mode 100644 arch/microblaze/pci/indirect_pci.c
  create mode 100644 arch/microblaze/pci/iomap.c
  create mode 100644 arch/microblaze/pci/pci-common.c
  create mode 100644 arch/microblaze/pci/pci_32.c
  create mode 100644 arch/microblaze/pci/xilinx_pci.c


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
