Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbZBSJmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbZBSJmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZBSJmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:42:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59411 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbZBSJmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:42:10 -0500
Message-ID: <499D29C9.8040405@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 17:43:37 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCHv2 05/11]Replace all DMA_35BIT_MASK macro with DMA_BIT_MASK(35)
References: <499CFDC8.1070600@cn.fujitsu.com> <499D0221.9090407@cn.fujitsu.com> <20090219081403.GA5400@elte.hu> <499D1ED9.4040005@cn.fujitsu.com> <499D2728.1080208@cn.fujitsu.com>
In-Reply-To: <499D2728.1080208@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all DMA_35BIT_MASK macro with DMA_BIT_MASK(35)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>

---
 drivers/net/netxen/netxen_nic_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 8bea4cb..2d4e41b 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -183,8 +183,8 @@ static int nx_set_dma_mask(struct netxen_adapter *adapter, uint8_t revision_id)
 		adapter->dma_mask = DMA_BIT_MASK(39);
 		mask = DMA_BIT_MASK(39);
 	} else if (revision_id == NX_P2_C1) {
-		adapter->dma_mask = DMA_35BIT_MASK;
-		mask = DMA_35BIT_MASK;
+		adapter->dma_mask = DMA_BIT_MASK(35);
+		mask = DMA_BIT_MASK(35);
 	} else {
 		adapter->dma_mask = DMA_32BIT_MASK;
 		mask = DMA_32BIT_MASK;
-- 
1.6.0.3

-- 
Regards
Yang Hongyang
