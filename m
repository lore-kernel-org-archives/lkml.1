Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYGKLqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYGKLqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbYGKLqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:46:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:2648 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864AbYGKLqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:46:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,344,1212390000"; 
   d="scan'208";a="590927220"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 0/2] I/OAT: watchdog/reset and tcp_dma_copybreak
To: dan.j.williams@intel.com
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 13:36:38 +0200
Message-ID: <20080711113553.337.50006.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
