Return-Path: <linux-kernel-owner+w=401wt.eu-S2992906AbXCCCjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992906AbXCCCjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 21:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992917AbXCCCjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 21:39:13 -0500
Received: from [63.64.152.142] ([63.64.152.142]:1460 "EHLO gitlost.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992906AbXCCCjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 21:39:10 -0500
From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH 0/9] I/OAT fixes
Date: Fri, 02 Mar 2007 18:22:38 -0800
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070303022238.31033.84558.stgit@gitlost.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton (1):
     I/OAT: warning fix

Chris Leech (6):
     ioatdma: Push pending transactions to hardware more frequently
     ioatdma: Remove the wrappers around read(bwl)/write(bwl) in ioatdma
     ioatdma: Remove the use of writeq from the ioatdma driver
     I/OAT: Add documentation for the tcp_dma_copybreak sysctl
     I/OAT: Add entries to MAINTAINERS for the DMA memcpy subsystem and ioatdma
     I/OAT: Only offload copies for TCP when there will be a context switch

Dan Aloni (1):
     I/OAT: fix I/OAT for kexec

Jeff Garzik (1):
     drivers/dma: handle sysfs errors

 Documentation/networking/ip-sysctl.txt |    6 +
 MAINTAINERS                            |   12 +++
 drivers/dma/dmaengine.c                |   22 +++++-
 drivers/dma/ioatdma.c                  |   81 ++++++++++++----------
 drivers/dma/ioatdma_io.h               |  118 ---------------------------------
 net/ipv4/tcp.c                         |   26 +++++--
 6 files changed, 100 insertions(+), 165 deletions(-)

--
Chris Leech <christopher.leech@intel.com>
I/O Acceleration Technology Software Development
LAN Access Division / Digital Enterprise Group 
