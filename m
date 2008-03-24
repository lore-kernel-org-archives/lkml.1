Return-Path: <linux-kernel-owner+w=401wt.eu-S1761915AbYCXRrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915AbYCXRrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760660AbYCXRr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:47:27 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4214 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760341AbYCXRrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:47:25 -0400
Subject: Subject: [PATCH 2/2] include/linux/icmpv6.h - neaten prototypes
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080323.221815.84933913.davem@davemloft.net>
References: <1205106928.656.102.camel@localhost>
	 <20080323.221815.84933913.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 10:46:39 -0700
Message-Id: <1206380799.4845.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-23 at 22:18 -0700, David Miller wrote:
> Does not apply to net-2.6.26, dropped.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/icmpv6.h |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index c1a30c7..5f39689 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -166,26 +166,19 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
 	return (struct icmp6hdr *)skb_transport_header(skb);
 }
 
-extern void				icmpv6_send(struct sk_buff *skb,
-						    int type, int code,
-						    __u32 info, 
-						    struct net_device *dev);
-
-extern int				icmpv6_init(void);
-extern int				icmpv6_err_convert(int type, int code,
-							   int *err);
-extern void				icmpv6_cleanup(void);
-extern void				icmpv6_param_prob(struct sk_buff *skb,
-							  int code, int pos);
+extern void icmpv6_send(struct sk_buff *skb, int type, int code, __u32 info, 
+			struct net_device *dev);
+
+extern int icmpv6_init(void);
+extern int icmpv6_err_convert(int type, int code, int *err);
+extern void icmpv6_cleanup(void);
+extern void icmpv6_param_prob(struct sk_buff *skb, int code, int pos);
 
 struct flowi;
 struct in6_addr;
-extern void				icmpv6_flow_init(struct sock *sk,
-							 struct flowi *fl,
-							 u8 type,
-							 const struct in6_addr *saddr,
-							 const struct in6_addr *daddr,
-							 int oif);
+extern void icmpv6_flow_init(struct sock *sk, struct flowi *fl, u8 type,
+			     const struct in6_addr *saddr,
+			     const struct in6_addr *daddr, int oif);
 #endif
 
 #endif
-- 
1.5.4.rc2



