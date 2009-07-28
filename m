Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZG1XFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZG1XFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbZG1XFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:05:25 -0400
Received: from kroah.org ([198.145.64.141]:43067 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbZG1XEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:45 2009
Message-Id: <20090728225945.404737377@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 30/37] ipsec: Fix name of CAST algorithm
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=ipsec-fix-name-of-cast-algorithm.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

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


