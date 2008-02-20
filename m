Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbYBTQNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbYBTQNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764799AbYBTQIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:08:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759666AbYBTQIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:08:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/37] CacheFiles: Export things for CacheFiles
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:07:40 +0000
Message-ID: <20080220160740.4715.96103.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export a number of functions for CacheFiles's use.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/fs/super.c b/fs/super.c
index 88811f6..1133b43 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -267,6 +267,7 @@ int fsync_super(struct super_block *sb)
 	__fsync_super(sb);
 	return sync_blockdev(sb->s_bdev);
 }
+EXPORT_SYMBOL_GPL(fsync_super);
 
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()

