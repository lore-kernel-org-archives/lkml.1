Return-Path: <linux-kernel-owner+w=401wt.eu-S1765100AbXHNVcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765100AbXHNVcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbXHNVXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:13 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38424 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753743AbXHNVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:08 -0400
Date: Tue, 14 Aug 2007 23:22:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, bfields@fieldses.org,
       neilb@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make fs/nfsd/nfs4callback.c:do_probe_callback() static
Message-ID: <20070814212258.GH18945@stusta.de>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 01:51:06AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm1:
>...
>  git-nfsd.patch
>...
>  git trees
>...


do_probe_callback() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8177c6f652deb91fcb43c8ca86f7703a61468ba9 
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index afdf66b..c17a520 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -369,7 +369,7 @@ nfsd4_lookupcred(struct nfs4_client *clp, int taskflags)
 /* Reference counting, callback cleanup, etc., all look racy as heck.
  * And why is cb_set an atomic? */
 
-int do_probe_callback(void *data)
+static int do_probe_callback(void *data)
 {
 	struct nfs4_client *clp = data;
 	struct nfs4_callback *cb = &clp->cl_callback;

