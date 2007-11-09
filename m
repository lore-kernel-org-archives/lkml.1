Return-Path: <linux-kernel-owner+w=401wt.eu-S1763145AbXKIXeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763145AbXKIXeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXKIXeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:34:07 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57095 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbXKIXeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:34:06 -0500
Message-id: <5566687663573801@pripojeni.net>
In-reply-to: <4827138842526222333@pripojeni.net>
Subject: [PATCH 5/5] Net: sunrpc, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <tom@opengridcomputing.com>
Cc: <okir@monad.swb.de>
Cc: <cel@netapp.com>
Date: Fri, 9 Nov 2007 18:34:06 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sunrpc, remove SPIN_LOCK_UNLOCKED

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d5e782e62a4fe2663a012571c3444445d9887b02
tree b993038b020d8c619f6ffdad412fbb992c073513
parent 828042d12cc0aa515e049889aa76d4066df100c0
author Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 12:00:13 +0200
committer Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 12:00:13 +0200

 net/sunrpc/xprt.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 282a9a2..cd641c8 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -62,7 +62,7 @@ static inline void	do_xprt_reserve(struct rpc_task *);
 static void	xprt_connect_status(struct rpc_task *task);
 static int      __xprt_get_cong(struct rpc_xprt *, struct rpc_task *);
 
-static spinlock_t xprt_list_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(xprt_list_lock);
 static LIST_HEAD(xprt_list);
 
 /*
