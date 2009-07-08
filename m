Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbZGHQE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbZGHQE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbZGHQEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:04:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:53170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbZGHQED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:04:03 -0400
Subject: [PATCH 25/44] includecheck fix: drivers/net, smc911x.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Miller <davem@davemloft.net>, nico@cam.org,
       netdev <netdev@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:55:29 +0530
Message-Id: <1247066729.4382.72.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/net/smc911x.h: mach/dma.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/smc911x.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/smc911x.h b/drivers/net/smc911x.h
index 8140f7c..05adb6a 100644
--- a/drivers/net/smc911x.h
+++ b/drivers/net/smc911x.h
@@ -236,7 +236,6 @@ static inline void SMC_outsl(struct smc911x_local *lp, int reg,
  * Use a DMA for RX and TX packets.
  */
 #include <linux/dma-mapping.h>
-#include <mach/dma.h>
 
 static dma_addr_t rx_dmabuf, tx_dmabuf;
 static int rx_dmalen, tx_dmalen;
-- 
1.6.0.6



