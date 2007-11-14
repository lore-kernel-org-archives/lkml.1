Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbXKNCKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbXKNCKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761794AbXKNCFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:41 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4792 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761727AbXKNCFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:39 -0500
Subject: [PATCH] - [15/15] - remove defconfig ptr comparisons to 0 -
	net/sunrpc
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       Networking Team <netdev@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfs@lists.sourceforge.net
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:39 -0800
Message-Id: <1195005939.5163.101.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 76be83e..1600df2 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -157,7 +157,7 @@ static struct rpc_clnt * rpc_new_client(struct rpc_xprt *xprt, char *servname, s
 	clnt->cl_server = clnt->cl_inline_name;
 	if (len > sizeof(clnt->cl_inline_name)) {
 		char *buf = kmalloc(len, GFP_KERNEL);
-		if (buf != 0)
+		if (buf)
 			clnt->cl_server = buf;
 		else
 			len = sizeof(clnt->cl_inline_name);


