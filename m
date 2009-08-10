Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZHJCzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZHJCzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 22:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZHJCzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 22:55:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:37972 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174AbZHJCzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 22:55:39 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH resend 0/8] sparc: use asm-generic/dma-mapping-common.h and pci-dma-compat.h
Date: Mon, 10 Aug 2009 11:53:09 +0900
Message-Id: <1249872797-1314-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 10 Aug 2009 11:54:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the repost of the patchset (as Ingo asked me offline) :

http://lkml.org/lkml/2009/7/13/20

There is no functional change. I just added David's ack to #3-8
patches and Robert's Tested-by to #8 patch.

I confirmed that it can be applied cleanly to mainline, -next, and
-tip trees.

The git tree is also available:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git sparc

=
 arch/ia64/include/asm/dma-mapping.h      |    1 -
 arch/sparc/Kconfig                       |    2 +
 arch/sparc/include/asm/dma-mapping.h     |  145 ++++-------------------
 arch/sparc/include/asm/pci.h             |    3 +
 arch/sparc/include/asm/pci_32.h          |  105 ----------------
 arch/sparc/include/asm/pci_64.h          |   88 --------------
 arch/sparc/kernel/Makefile               |    2 +-
 arch/sparc/kernel/dma.c                  |  175 +--------------------------
 arch/sparc/kernel/dma.h                  |   14 --
 arch/sparc/kernel/iommu.c                |   20 ++-
 arch/sparc/kernel/ioport.c               |  190 ++++++++++++++++-------------
 arch/sparc/kernel/pci.c                  |    2 +-
 arch/sparc/kernel/pci_sun4v.c            |   30 ++----
 arch/x86/kernel/pci-nommu.c              |   27 ++++-
 include/asm-generic/dma-mapping-common.h |    6 -
 15 files changed, 183 insertions(+), 627 deletions(-)



