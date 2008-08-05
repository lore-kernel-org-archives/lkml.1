Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbYHEJ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbYHEJ0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758354AbYHEJ0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:26:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756942AbYHEJ0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:26:17 -0400
Message-ID: <48981BDE.70201@cn.fujitsu.com>
Date: Tue, 05 Aug 2008 17:22:38 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Add (struct sock*) sk parameter for send_ack()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add (struct sock*) sk parameter for send_ack.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 include/net/request_sock.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 8d6e991..cac811e 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -33,7 +33,7 @@ struct request_sock_ops {
 	struct kmem_cache	*slab;
 	int		(*rtx_syn_ack)(struct sock *sk,
 				       struct request_sock *req);
-	void		(*send_ack)(struct sk_buff *skb,
+	void		(*send_ack)(struct sock *sk, struct sk_buff *skb,
 				    struct request_sock *req);
 	void		(*send_reset)(struct sock *sk,
 				      struct sk_buff *skb);
-- 
1.5.3






