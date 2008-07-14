Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYGNNdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYGNNdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYGNNdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:33:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:56238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYGNNdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:33:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,359,1212390000"; 
   d="scan'208";a="314822235"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 0/2] I/OAT: watchdog/reset and tcp_dma_copybreak
To: dan.j.williams@intel.com
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       net-dev@vger.kernel.org
Date: Mon, 14 Jul 2008 15:23:40 +0200
Message-ID: <20080714132215.26830.90819.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am resending these patches also to netdev list.

It has been a while since last ioatdma update.
Here are two patches that are a result of 
ioatdma sustaining and performance tuning efforts
for both I/OAT versions 1.2 and 2.0.

This patches apply to kernel 2.6.26-rc9.

Maciej Sosnowski (2):
     I/OAT: Add watchdog/reset functionality to ioatdma driver
     I/OAT: tcp_dma_copybreak default value dependant on I/OAT version

 drivers/dma/dmaengine.c   |    3 
 drivers/dma/ioat_dma.c    |  273 +++++++++++++++++++++++++++++++++++-
 drivers/dma/ioatdma.h     |   10 +
 include/linux/dmaengine.h |    2 
 4 files changed, 281 insertions(+), 7 deletions(-)

--
Maciej
