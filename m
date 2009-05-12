Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZEMAgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZEMAgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZEMAfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:35:44 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:58531
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754973AbZEMAfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:35:43 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] Xen dom0 swiotlb updates
Date: Tue, 12 May 2009 14:50:41 -0700
Message-Id: <1242165051-6636-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's the Xen swiotlb changes with ack tags added, minor cleanups, etc.

This is logically a continuation of the tip/x86/xen/dom0/pci branch.

Thanks,
	J

The following changes since commit e03834d7bc255b4fc35d894141a747a32a6b9cfd:
  Jeremy Fitzhardinge (1):
        xen: define BIOVEC_PHYS_MERGEABLE()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-ingo/xen/dom0/swiotlb

Ian Campbell (4):
      xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER
      xen: add hooks for mapping phys<->bus addresses in swiotlb
      xen/swiotlb: add hook for swiotlb_arch_range_needs_mapping
      xen: enable swiotlb for xen domain 0.

Jeremy Fitzhardinge (6):
      xen: make sure swiotlb allocation is physically contigious
      swiotlb: use swiotlb_alloc_boot to allocate emergency pool
      xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
      xen/swiotlb: add sync functions
      xen/swiotlb: make sure prototypes are in scope for swiotlb functions
      xen/swiotlb: define xen_wants_swiotlb when PCI_XEN is not enabled

 arch/x86/kernel/pci-swiotlb.c |   30 +++---------------
 arch/x86/xen/Kconfig          |    1 +
 arch/x86/xen/Makefile         |    1 +
 arch/x86/xen/pci-swiotlb.c    |   53 +++++++++++++++++++++++++++++++
 drivers/pci/xen-iommu.c       |   69 ++++++++++++++++++++++++++++++++++++++--
 include/xen/swiotlb.h         |   18 +++++++++++
 lib/swiotlb.c                 |    3 +-
 7 files changed, 145 insertions(+), 30 deletions(-)
 create mode 100644 arch/x86/xen/pci-swiotlb.c
 create mode 100644 include/xen/swiotlb.h

