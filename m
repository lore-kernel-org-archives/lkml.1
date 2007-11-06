Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXKFOQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXKFOQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbXKFOP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:15:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbXKFOPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:15:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] IGET: Use ino_t consistently for vxfs_iget() and its
	declaration
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 06 Nov 2007 14:15:54 +0000
Message-ID: <20071106141554.17691.1661.stgit@warthog.procyon.org.uk>
In-Reply-To: 20071106022505.f32b1bff.akpm@linux-foundation.org
References: 20071106022505.f32b1bff.akpm@linux-foundation.org
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use ino_t consistently for vxfs_iget() and its declaration, rather than using
ino_t for one and unsigned long for the other.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/freevxfs/vxfs_extern.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/freevxfs/vxfs_extern.h b/fs/freevxfs/vxfs_extern.h
index f307694..2b46064 100644
--- a/fs/freevxfs/vxfs_extern.h
+++ b/fs/freevxfs/vxfs_extern.h
@@ -58,7 +58,7 @@ extern struct inode *		vxfs_get_fake_inode(struct super_block *,
 extern void			vxfs_put_fake_inode(struct inode *);
 extern struct vxfs_inode_info *	vxfs_blkiget(struct super_block *, u_long, ino_t);
 extern struct vxfs_inode_info *	vxfs_stiget(struct super_block *, ino_t);
-extern struct inode *		vxfs_iget(struct super_block *, unsigned long);
+extern struct inode *		vxfs_iget(struct super_block *, ino_t);
 extern void			vxfs_clear_inode(struct inode *);
 
 /* vxfs_lookup.c */

