Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYKCMTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYKCMTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 07:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYKCMTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 07:19:04 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:54225 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbYKCMTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 07:19:02 -0500
Date: Mon, 3 Nov 2008 20:19:08 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: [PATCH] nets: remove two duplicated #include
Message-ID: <20081103121908.GA24634@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] nets: remove two duplicated #include

Removed duplicated #include <rdma/ib_verbs.h> in net/9p/trans_rdma.c
		and  #include <linux/thread_info.h> in net/socket.c

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 net/9p/trans_rdma.c |    1 -
 net/socket.c        |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 8d6cc47..a7fe63f 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -45,7 +45,6 @@
 #include <net/9p/transport.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
-#include <rdma/ib_verbs.h>
 
 #define P9_PORT			5640
 #define P9_RDMA_SQ_DEPTH	32
diff --git a/net/socket.c b/net/socket.c
index 57550c3..d7128b7 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -69,7 +69,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/mutex.h>
-#include <linux/thread_info.h>
 #include <linux/wanrouter.h>
 #include <linux/if_bridge.h>
 #include <linux/if_frad.h>
-- 
1.5.6.3

