Return-Path: <linux-kernel-owner+w=401wt.eu-S2993130AbXDSHBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993130AbXDSHBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993128AbXDSHBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:01:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46345 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161328AbXDSHBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:01:19 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] nfsd/nfs4state: Remove unnecessary daemonize call.
Date: Thu, 19 Apr 2007 00:55:56 -0600
Message-Id: <11769658123779-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/nfsd/nfs4state.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 678f3be..3cc8ce4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1326,8 +1326,6 @@ do_recall(void *__dp)
 {
 	struct nfs4_delegation *dp = __dp;
 
-	daemonize("nfsv4-recall");
-
 	nfsd4_cb_recall(dp);
 	return 0;
 }
-- 
1.5.0.g53756

