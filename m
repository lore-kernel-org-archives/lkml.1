Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZLWA1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZLWA1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZLWA1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:27:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:38671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZLWA1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:27:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,439,1257148800"; 
   d="scan'208";a="478484776"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] ioatdma fixes for 2.6.33-rc
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: maciej.sosnowski@intel.com
Date: Tue, 22 Dec 2009 17:25:50 -0700
Message-ID: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These fix recently discovered issues with the ioatdma driver and are
tagged for -stable.  They are currently on the 'fixes' branch of
async_tx.git and will head upstream shortly.

     git://git.kernel.org/linux/kernel/git/djbw/async_tx.git fixes

---

Dan Williams (3):
      ioat2,3: put channel hardware in known state at init
      async_tx: expand async raid6 test to cover ioatdma corner case
      ioat3: fix p-disabled q-continuation


 crypto/async_tx/raid6test.c  |    7 ++++
 drivers/dma/ioat/dma.c       |    2 +
 drivers/dma/ioat/dma.h       |   18 +++++++++++
 drivers/dma/ioat/dma_v2.c    |   69 ++++++++++++++++++++++++++++++++----------
 drivers/dma/ioat/dma_v2.h    |    2 +
 drivers/dma/ioat/dma_v3.c    |   60 +++++++++++++++++++++++++++----------
 drivers/dma/ioat/registers.h |    1 +
 7 files changed, 125 insertions(+), 34 deletions(-)

