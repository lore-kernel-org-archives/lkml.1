Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbZIXMUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbZIXMUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZIXMUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:20:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:46746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZIXMT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:19:59 -0400
Subject: [PATCH] net: fix htmldocs sunrpc, clnt.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>,
       Benny Halevy <bhalevy@panasas.com>, Andy Adamson <andros@netapp.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, linux-nfs@vger.kernel.org,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 17:49:41 +0530
Message-Id: <1253794781.5860.29.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  DOCPROC Documentation/DocBook/networking.xml
  Warning(net/sunrpc/clnt.c:647): No description found for parameter 'req'
  Warning(net/sunrpc/clnt.c:647): No description found for parameter 'tk_ops'
  Warning(net/sunrpc/clnt.c:647): Excess function parameter 'ops' description in 'rpc_run_bc_task'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>
Cc: Benny Halevy <bhalevy@panasas.com>
Cc: Andy Adamson <andros@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Miller <davem@davemloft.net>
---
 net/sunrpc/clnt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index a417d5a..38829e2 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -640,10 +640,11 @@ EXPORT_SYMBOL_GPL(rpc_call_async);
 /**
  * rpc_run_bc_task - Allocate a new RPC task for backchannel use, then run
  * rpc_execute against it
- * @ops: RPC call ops
+ * @req: RPC request
+ * @tk_ops: RPC call ops
  */
 struct rpc_task *rpc_run_bc_task(struct rpc_rqst *req,
-					const struct rpc_call_ops *tk_ops)
+				const struct rpc_call_ops *tk_ops)
 {
 	struct rpc_task *task;
 	struct xdr_buf *xbufp = &req->rq_snd_buf;
-- 
1.6.0.6


