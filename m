Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYKGL47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYKGL47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYKGL4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:56:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:65449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbYKGL4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:56:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,564,1220252400"; 
   d="scan'208";a="357311568"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 0/4] I/OAT fixes
To: dan.j.williams@intel.com
Cc: tom.s.picard@intel.com, mark_rustad@Xiotech.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Date: Fri, 07 Nov 2008 12:45:16 +0100
Message-ID: <20081107114325.25190.5419.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains couple of fixes for I/OAT DMA and DCA.

Maciej Sosnowski (3):
    I/OAT: fix channel resources free for not allocated channels
    I/OAT: fix dma_pin_iovec_pages() error handling
    I/OAT: fix async_tx.callback checking

Dan Williams (1):
    dca: fixup initialization dependency

 drivers/dca/dca-core.c |    2 +-
 drivers/dma/ioat_dma.c |   11 +++++++++--
 drivers/dma/iovlock.c  |   17 ++++++-----------
 3 files changed, 16 insertions(+), 14 deletions(-)

--
Maciej
