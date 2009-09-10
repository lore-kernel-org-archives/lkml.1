Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZIJVvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZIJVvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbZIJVvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:51:50 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50440 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbZIJVvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:51:49 -0400
Date: Thu, 10 Sep 2009 14:51:46 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: force bridge module(s) to be GPL
Message-ID: <20090910145146.3ee30338@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only valid usage for the bridge frame hooks are by a
GPL components (such as the bridge module).
The kernel should not leave a crack in the door for proprietary
networking stacks to slip in.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/net/core/dev.c	2009-09-10 14:27:59.076074483 -0700
+++ b/net/core/dev.c	2009-09-10 14:28:43.659314263 -0700
@@ -2116,7 +2116,7 @@ static inline int deliver_skb(struct sk_
 /* This hook is defined here for ATM LANE */
 int (*br_fdb_test_addr_hook)(struct net_device *dev,
 			     unsigned char *addr) __read_mostly;
-EXPORT_SYMBOL(br_fdb_test_addr_hook);
+EXPORT_SYMBOL_GPL(br_fdb_test_addr_hook);
 #endif
 
 /*
@@ -2125,7 +2125,7 @@ EXPORT_SYMBOL(br_fdb_test_addr_hook);
  */
 struct sk_buff *(*br_handle_frame_hook)(struct net_bridge_port *p,
 					struct sk_buff *skb) __read_mostly;
-EXPORT_SYMBOL(br_handle_frame_hook);
+EXPORT_SYMBOL_GPL(br_handle_frame_hook);
 
 static inline struct sk_buff *handle_bridge(struct sk_buff *skb,
 					    struct packet_type **pt_prev, int *ret,
