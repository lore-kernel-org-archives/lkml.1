Return-Path: <linux-kernel-owner+w=401wt.eu-S935294AbXGTPPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294AbXGTPPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934548AbXGTPPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:15:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51348 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934421AbXGTPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:15:32 -0400
Date: Fri, 20 Jul 2007 16:15:28 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] ANSIfy a couple of functions in netfilter
Message-ID: <20070720151528.GI21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	It's C, not C++...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b1179dd..ca10df4 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -194,7 +194,7 @@ static struct nf_ct_ext_type helper_extend __read_mostly = {
 	.id	= NF_CT_EXT_HELPER,
 };
 
-int nf_conntrack_helper_init()
+int nf_conntrack_helper_init(void)
 {
 	int err;
 
@@ -216,7 +216,7 @@ err1:
 	return err;
 }
 
-void nf_conntrack_helper_fini()
+void nf_conntrack_helper_fini(void)
 {
 	nf_ct_extend_unregister(&helper_extend);
 	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_vmalloc,
