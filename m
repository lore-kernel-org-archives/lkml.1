Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYKVHlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYKVHlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYKVHlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:41:20 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:1622 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbYKVHlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:41:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=qCCrayeYBCgNbkmpovd0GOb0wIttrF5LdU/o8CjKXeT15ad0ASYaquv35iqManHWTN
         CnaGwnkcmOTK2Uq7ZKM+M/cHl6UAMMmIZhMH3VYdC7w3JqgMQQ/njhdCjbcpbqU2mWCW
         /U4lhnPFqwYULI0qGvXctTJMdv5tZU1QWyt0E=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/net/chelsio/sge.c: remove redundant argument
 comments
Date: Sat, 22 Nov 2008 15:41:03 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <4927b79c.08486e0a.6977.048a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove redundant argument comments

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
index d6c7d2a..7092df5 100644
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -1035,10 +1035,6 @@ MODULE_PARM_DESC(copybreak, "Receive copy threshold");
  *	@pdev: the PCI device that received the packet
  *	@fl: the SGE free list holding the packet
  *	@len: the actual packet length, excluding any SGE padding
- *	@dma_pad: padding at beginning of buffer left by SGE DMA
- *	@skb_pad: padding to be used if the packet is copied
- *	@copy_thres: length threshold under which a packet should be copied
- *	@drop_thres: # of remaining buffers before we start dropping packets
  *
  *	Get the next packet from a free list and complete setup of the
  *	sk_buff.  If the packet is small we make a copy and recycle the

