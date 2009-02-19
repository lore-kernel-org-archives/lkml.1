Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZBSJhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZBSJhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZBSJhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:37:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53975 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbZBSJhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:37:06 -0500
Message-ID: <499D289A.7010305@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 17:38:34 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCHv2 02/11]Replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)
References: <499CFDC8.1070600@cn.fujitsu.com> <499D0221.9090407@cn.fujitsu.com> <20090219081403.GA5400@elte.hu> <499D1ED9.4040005@cn.fujitsu.com> <499D2728.1080208@cn.fujitsu.com>
In-Reply-To: <499D2728.1080208@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>

---
 drivers/net/dl2k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/dl2k.c b/drivers/net/dl2k.c
index c749e9f..4a1b554 100644
--- a/drivers/net/dl2k.c
+++ b/drivers/net/dl2k.c
@@ -714,7 +714,7 @@ rio_interrupt (int irq, void *dev_instance)
 
 static inline dma_addr_t desc_to_dma(struct netdev_desc *desc)
 {
-	return le64_to_cpu(desc->fraginfo) & DMA_48BIT_MASK;
+	return le64_to_cpu(desc->fraginfo) & DMA_BIT_MASK(48);
 }
 
 static void
-- 
1.6.0.3


-- 
Regards
Yang Hongyang
