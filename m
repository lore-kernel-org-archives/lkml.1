Return-Path: <linux-kernel-owner+w=401wt.eu-S2993150AbXDSHMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993150AbXDSHMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993146AbXDSHIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:08:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46310 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161276AbXDSHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:00:19 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] nfs4state reclaimer: Remove unnecessary allow_signal
Date: Thu, 19 Apr 2007 00:55:57 -0600
Message-Id: <1176965814722-git-send-email-ebiederm@xmission.com>
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
 fs/nfs/nfs4state.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 5fffbdf..d16393f 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -775,8 +775,6 @@ static int reclaimer(void *ptr)
 	struct rpc_cred *cred;
 	int status = 0;
 
-	allow_signal(SIGKILL);
-
 	/* Ensure exclusive access to NFSv4 state */
 	lock_kernel();
 	down_write(&clp->cl_sem);
-- 
1.5.0.g53756

