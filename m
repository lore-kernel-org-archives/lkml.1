Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbYLDAul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbYLDAul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYLDAqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:46:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:51341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848AbYLDAqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:46:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,710,1220252400"; 
   d="scan'208";a="86212414"
Subject: [PATCH 0/4] dmaengine redux continued
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Dec 2008 17:46:40 -0700
Message-ID: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few more dmaengine cleanups targeted for 2.6.29.  The bulk of the
change is fixing the dmaengine sysfs implementation.

It has been pushed out to the 'upstream' tree of async_tx.git[1] and will move
to -next shortly.

---

Dan Williams (4):
      dmaengine: bump initcall level to arch_initcall
      dmaengine: advertise all channels on a device to dma_filter_fn
      dmaengine: use idr for registering dma device numbers
      dmaengine: add a release for dma class devices and dependent infrastructure


 drivers/dca/dca-core.c    |    2 -
 drivers/dma/dmaengine.c   |  169 ++++++++++++++++++++++++++++++++-------------
 drivers/dma/dmatest.c     |   14 ++--
 drivers/dma/dw_dmac.c     |   91 +++++++++++++-----------
 drivers/dma/fsldma.c      |    2 -
 include/linux/dmaengine.h |   23 +++++-
 6 files changed, 201 insertions(+), 100 deletions(-)

-- 

[1] git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git upstream
