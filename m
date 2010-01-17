Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787Ab0AQVPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0AQVPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614Ab0AQVPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:15:54 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:45724 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab0AQVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:15:53 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH] trivial: Some typos/punctuation in comments and coding style for net.
Date: Sun, 17 Jan 2010 19:13:19 -0200
Message-Id: <1263762799-9049-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 net/core/net_namespace.c |    2 +-
 net/packet/af_packet.c   |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index bd8c471..53a1aec 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -454,7 +454,7 @@ int register_pernet_subsys(struct pernet_operations *ops)
 {
 	int error;
 	mutex_lock(&net_mutex);
-	error =  register_pernet_operations(first_device, ops);
+	error = register_pernet_operations(first_device, ops);
 	mutex_unlock(&net_mutex);
 	return error;
 }
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index f126d18..baf4ed5 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1,6 +1,6 @@
 /*
  * INET		An implementation of the TCP/IP protocol suite for the LINUX
- *		operating system.  INET is implemented using the  BSD Socket
+ *		operating system. INET is implemented using the BSD Socket
  *		interface as the means of communication with the user level.
  *
  *		PACKET - implements raw packet sockets.
@@ -88,10 +88,10 @@
 /*
    Assumptions:
    - if device has no dev->hard_header routine, it adds and removes ll header
-     inside itself. In this case ll header is invisible outside of device,
+     inside itself. In this case, ll header is invisible outside of device,
      but higher levels still should reserve dev->hard_header_len.
      Some devices are enough clever to reallocate skb, when header
-     will not fit to reserved space (tunnel), another ones are silly
+     will not fit to reserved space (tunnel), other ones are silly
      (PPP).
    - packet socket receives packets with pulled ll header,
      so that SOCK_RAW should push it back.
@@ -108,8 +108,8 @@ Outgoing, dev->hard_header!=NULL
    data       -> ll header
 
 Incoming, dev->hard_header==NULL
-   mac_header -> UNKNOWN position. It is very likely, that it points to ll
-		 header.  PPP makes it, that is wrong, because introduce
+   mac_header -> UNKNOWN position. It is very likely that it points to ll
+		 header.  PPP makes it. That is wrong, because it introduces
 		 assymetry between rx and tx paths.
    data       -> data
 
@@ -132,7 +132,7 @@ dev->hard_header == NULL (ll header is added by device, we cannot control it)
    mac_header -> data
    data       -> data
 
-   We should set nh.raw on output to correct posistion,
+   We should set nh.raw on output to correct position,
    packet classifier depends on it.
  */
 
-- 
1.6.6

