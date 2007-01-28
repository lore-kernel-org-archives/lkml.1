Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbXA1ALs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbXA1ALs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 19:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbXA1ALs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 19:11:48 -0500
Received: from imf21aec.mail.bellsouth.net ([205.152.59.69]:35386 "EHLO
	imf21aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932155AbXA1ALq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 19:11:46 -0500
Date: Sat, 27 Jan 2007 18:11:45 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, akpm@osdl.org
Subject: [PATCH 2.6.20-rc5 2/4] atl1: add missing include dma-mapping.h
Message-ID: <20070128001145.GB10269@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jay Cliburn <jacliburn@bellsouth.com>

Include dma-mapphing.h to provide DMA_32BIT_MASK and DMA_64BIT_MASK.
Discovered by and modification suggested by Andrew Morton.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---

 drivers/net/atl1/atl1_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 68e6cd1..a9e02d1 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -66,6 +66,7 @@
 #include <linux/hardirq.h>
 #include <linux/interrupt.h>
 #include <linux/irqflags.h>
+#include <linux/dma-mapping.h>
 #include <linux/net.h>
 #include <linux/pm.h>
 #include <linux/in.h>
