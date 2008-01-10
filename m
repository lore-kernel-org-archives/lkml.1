Return-Path: <linux-kernel-owner+w=401wt.eu-S1760361AbYAJSD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361AbYAJSD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbYAJSCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:02:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607AbYAJSCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:02:32 -0500
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org, neilb@suse.de
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] SUNRPC: export svc_sock_update_bufs
Date: Thu, 10 Jan 2008 13:01:33 -0500
Message-Id: <1199988096-19700-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199988096-19700-2-git-send-email-jlayton@redhat.com>
References: <1199988096-19700-1-git-send-email-jlayton@redhat.com>
 <1199988096-19700-2-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed since the plan is to not have a svc_create_thread helper and to
have current users of that function just call kthread_run directly.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 net/sunrpc/svcsock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 057c870..f2bef16 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1407,6 +1407,7 @@ svc_sock_update_bufs(struct svc_serv *serv)
 	}
 	spin_unlock_bh(&serv->sv_lock);
 }
+EXPORT_SYMBOL(svc_sock_update_bufs);
 
 /*
  * Receive the next request on any socket.  This code is carefully
-- 
1.5.3.7

