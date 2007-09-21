Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbXIUB1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbXIUB1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXIUB1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:27:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:57453 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbXIUB1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:27:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,280,1186383600"; 
   d="scan'208";a="283290354"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Cc: akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com,
       shannon.nelson@intel.com
Date: Thu, 20 Sep 2007 18:27:35 -0700
Message-ID: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple bugs and provide documentation for the async_tx api.

Neil, please 'ack' patch #3.

git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus

Dan Williams (3):
      async_tx: usage documentation and developer notes
      async_tx: fix dma_wait_for_async_tx
      raid5: fix ops_complete_biofill

Documentation/crypto/async-tx-api.txt |  217 +++++++++++++++++++++++++++++++++
crypto/async_tx/async_tx.c            |   12 ++-
drivers/md/raid5.c                    |   90 +++++++-------
3 files changed, 273 insertions(+), 46 deletions(-)

--
Dan
