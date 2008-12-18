Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753392AbYLRN0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYLRN0J (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYLRNZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:25:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:38655 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750985AbYLRNZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:25:54 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+4WDdRv8a4zOJrgAv1A8EcIFj3Jd9SjWf8Jdg6lX
	7E4ErWUjlNWdjE
Date: Thu, 18 Dec 2008 14:26:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.arm.linux.org.uk,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4 v4] i.MX31: dmaengine and framebuffer drivers
Message-ID: <Pine.LNX.4.64.0812181406000.5510@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 4 of dmaengine and framebuffer drivers for i.MX31.

Changes since version 3: fixed idmac_issue_pending() to not reset the 
current buffer, fixed return value from idmac_tx_submit(), fixed 
framebuffer panning.

Changes since version 2: now uses a tasklet to clean up completed 
transaction descriptors, as suggested by Dan Williams.

Changes since version 1: rebased on the updated dmaengine framework.

I'd really like to get this in for 2.6.29, so, please, review and comment.

Based on linux-next as of commit f0e0e8954d03b414927650a6129ace01d554afdc.

Thanks
Guennadi
---
Guennadi Liakhovetski
