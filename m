Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbZDHLv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbZDHLv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254AbZDHL2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:47 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47447 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764660AbZDHL1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:37 -0400
X-Sasl-enc: MbtF8q+0HHfgPqrdsOceNZMfvi9TzXrz10/o13HhKcOk 1239190055
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 34/56] nfs: Remove void casts
Date: Wed,  8 Apr 2009 12:22:06 +0100
Message-Id: <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/nfs/inode.c   |    2 +-
 fs/nfs/nfs2xdr.c |    2 +-
 fs/nfs/nfs3xdr.c |    2 +-
 fs/nfs/nfs4xdr.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 64f8719..c6aceaf 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1342,7 +1342,7 @@ void nfs4_clear_inode(struct inode *inode)
 struct inode *nfs_alloc_inode(struct super_block *sb)
 {
 	struct nfs_inode *nfsi;
-	nfsi = (struct nfs_inode *)kmem_cache_alloc(nfs_inode_cachep, GFP_KERNEL);
+	nfsi = kmem_cache_alloc(nfs_inode_cachep, GFP_KERNEL);
 	if (!nfsi)
 		return NULL;
 	nfsi->flags = 0UL;
diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index c862c93..a9017a6 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -627,7 +627,7 @@ nfs_xdr_readlinkres(struct rpc_rqst *req, __be32 *p, void *dummy)
 	}
 
 	/* NULL terminate the string we got */
-	kaddr = (char *)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = kmap_atomic(rcvbuf->pages[0], KM_USER0);
 	kaddr[len+rcvbuf->page_base] = '\0';
 	kunmap_atomic(kaddr, KM_USER0);
 	return 0;
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index e6a1932..48ccc17 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -859,7 +859,7 @@ nfs3_xdr_readlinkres(struct rpc_rqst *req, __be32 *p, struct nfs_fattr *fattr)
 	}
 
 	/* NULL terminate the string we got */
-	kaddr = (char*)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = kmap_atomic(rcvbuf->pages[0], KM_USER0);
 	kaddr[len+rcvbuf->page_base] = '\0';
 	kunmap_atomic(kaddr, KM_USER0);
 	return 0;
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 1690f0e..a283caa 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3565,7 +3565,7 @@ static int decode_readlink(struct xdr_stream *xdr, struct rpc_rqst *req)
 	 * and and null-terminate the text (the VFS expects
 	 * null-termination).
 	 */
-	kaddr = (char *)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = kmap_atomic(rcvbuf->pages[0], KM_USER0);
 	kaddr[len+rcvbuf->page_base] = '\0';
 	kunmap_atomic(kaddr, KM_USER0);
 	return 0;
-- 
1.5.4.3

