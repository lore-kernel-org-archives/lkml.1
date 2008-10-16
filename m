Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYJPVaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYJPVaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYJPV35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:29:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:51668 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbYJPV34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:29:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,426,1220252400"; 
   d="scan'208";a="61026498"
Subject: [git pull] async-tx/dmaengine update for 2.6.28
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, timur@freescale.com,
       julia@diku.dk, leoli@freescale.com, maciej.sosnowski@intel.com
Content-Type: text/plain
Date: Thu, 16 Oct 2008 14:30:33 -0700
Message-Id: <1224192633.19075.2.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from: 

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

to receive:

Andrew Morton (1):
      drivers/dma/dmatest.c: switch a GFP_ATOMIC to GFP_KERNEL

Dan Williams (1):
      async_tx: make async_tx_run_dependencies() easier to read

Julia Lawall (1):
      drivers/dma/ioat_dma.c: drop code after return

Timur Tabi (3):
      dmatest: properly handle duplicate DMA channels
      fsldma: remove internal self-test from Freescale Elo DMA driver
      fsldma: allow Freescale Elo DMA driver to be compiled as a module

 crypto/async_tx/async_tx.c |   34 +++---
 drivers/dma/Kconfig        |   10 +-
 drivers/dma/dmatest.c      |    7 +-
 drivers/dma/fsldma.c       |  270 ++++++++++++++-----------------------------
 drivers/dma/fsldma.h       |    1 +
 drivers/dma/ioat_dma.c     |    2 -
 6 files changed, 116 insertions(+), 208 deletions(-)

This update is primarily cleanup work from Timur on the fsldma driver
along with a smattering of other fixups.  It has had exposure in
linux-next and survives a test-merge with your current tree.

Thanks,
Dan


