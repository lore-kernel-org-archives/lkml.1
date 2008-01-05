Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYAEMEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYAEMEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 07:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYAEMDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 07:03:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYAEMDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 07:03:00 -0500
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] SUNRPC: export svc_sock_update_bufs
Date: Sat,  5 Jan 2008 07:02:18 -0500
Message-Id: <1199534542-3384-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199534542-3384-2-git-send-email-jlayton@redhat.com>
References: <1199534542-3384-1-git-send-email-jlayton@redhat.com>
 <1199534542-3384-2-git-send-email-jlayton@redhat.com>
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
1.5.3.6

