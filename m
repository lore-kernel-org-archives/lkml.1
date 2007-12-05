Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXLETq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXLETq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbXLETkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:40:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355AbXLETkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:40:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/28] CacheFiles: Export things for CacheFiles [try #2]
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 05 Dec 2007 19:39:45 +0000
Message-ID: <20071205193945.24617.18263.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
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
index ceaf2e3..cd199ae 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -266,6 +266,7 @@ int fsync_super(struct super_block *sb)
 	__fsync_super(sb);
 	return sync_blockdev(sb->s_bdev);
 }
+EXPORT_SYMBOL_GPL(fsync_super);
 
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()

