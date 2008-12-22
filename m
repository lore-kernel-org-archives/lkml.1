Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYLVScc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYLVScc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbYLVSbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:31:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:55102 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755808AbYLVSba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:31:30 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/LKqVsde/LCrvKw/TsXGRASYXAs144ESfSGSjG+W
	4jISRr2bmPRCKA
Date: Mon, 22 Dec 2008 19:31:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4 v5] i.MX31: dmaengine and framebuffer drivers
Message-ID: <Pine.LNX.4.64.0812221922200.5241@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 5 of dmaengine and framebuffer drivers for i.MX31.

Changes since version 4: addressed comments from Sascha Hauer, apart from: 
the idmac driver still uses two locks - a mutex and a spinlock, the "ugly" 
construction like "to_ipu(to_idmac(ichan->dma_chan.device));" is still 
there, still all 144 IRQs are registered. So now the driver is under 
drivers/dma, also fixed all docbook comments.

Changes since version 3: fixed idmac_issue_pending() to not reset the 
current buffer, fixed return value from idmac_tx_submit(), fixed 
framebuffer panning.

Changes since version 2: now uses a tasklet to clean up completed 
transaction descriptors, as suggested by Dan Williams.

Changes since version 1: rebased on the updated dmaengine framework.

Aimed at 2.6.29.

Based on linux-next as of commit f0e0e8954d03b414927650a6129ace01d554afdc.

Thanks
Guennadi
---
Guennadi Liakhovetski
