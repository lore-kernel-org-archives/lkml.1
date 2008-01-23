Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYAWAxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYAWAxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbYAWAqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:46:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464AbYAWApn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:45:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/27] CacheFiles: Export things for CacheFiles
To: Trond.Myklebust@netapp.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 23 Jan 2008 00:45:37 +0000
Message-ID: <20080123004537.15602.12748.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080123004344.15602.35710.stgit@warthog.procyon.org.uk>
References: <20080123004344.15602.35710.stgit@warthog.procyon.org.uk>
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

