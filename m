Return-Path: <linux-kernel-owner+w=401wt.eu-S934067AbYBMVlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbYBMVlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbYBMVao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:44 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55717 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760199AbYBMVak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:40 -0500
Date: Wed, 13 Feb 2008 23:30:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>, phillip@hellewell.homeip.net
Cc: ecryptfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove ecryptfs_header_cache_0
Message-ID: <20080213213024.GC3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used ecryptfs_header_cache_0.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
69fea065531a3c5542d818376c85efa7e4386cfb diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index a066e10..dcbbb2b 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1246,7 +1246,6 @@ ecryptfs_write_header_metadata(char *virt,
 	(*written) = 6;
 }
 
-struct kmem_cache *ecryptfs_header_cache_0;
 struct kmem_cache *ecryptfs_header_cache_1;
 struct kmem_cache *ecryptfs_header_cache_2;
 

