Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbXIUOuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbXIUOuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759017AbXIUOtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:49:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710AbXIUOtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:49:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/22] CacheFiles: Export things for CacheFiles
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:48:05 +0100
Message-ID: <20070921144805.8323.79399.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export a number of functions for CacheFiles's use.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 fs/super.c       |    2 ++
 kernel/auditsc.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 28e7370..0e8c0e2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -270,6 +270,8 @@ int fsync_super(struct super_block *sb)
 	return sync_blockdev(sb->s_bdev);
 }
 
+EXPORT_SYMBOL_GPL(fsync_super);
+
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()
  *	@sb: superblock to kill
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 282e041..4448a33 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1531,6 +1531,8 @@ add_names:
 	}
 }
 
+EXPORT_SYMBOL_GPL(__audit_inode_child);
+
 /**
  * auditsc_get_stamp - get local copies of audit_context values
  * @ctx: audit_context for the task

