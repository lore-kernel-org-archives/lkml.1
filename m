Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZHMUOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZHMUOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZHMT7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:14 -0400
Received: from kroah.org ([198.145.64.141]:41635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbZHMT7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:25 2009
Message-Id: <20090813195125.214786279@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 04/74] ipsec: Fix name of CAST algorithm
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=ipsec-fix-name-of-cast-algorithm.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 245acb87729bc76ba65c7476665c01837e0cdccb ]

Our CAST algorithm is called cast5, not cast128.  Clearly nobody
has ever used it :)

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/xfrm/xfrm_algo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -292,8 +292,8 @@ static struct xfrm_algo_desc ealg_list[]
 	}
 },
 {
-	.name = "cbc(cast128)",
-	.compat = "cast128",
+	.name = "cbc(cast5)",
+	.compat = "cast5",
 
 	.uinfo = {
 		.encr = {


