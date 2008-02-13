Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbYBMVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbYBMVlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYBMVap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:45 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47512 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760117AbYBMVam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:42 -0500
Date: Wed, 13 Feb 2008 23:30:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "J. Bruce Fields" <bfields@citi.umich.edu>, neilb@suse.de
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make nfsd_create_setattr() static
Message-ID: <20080213213026.GD3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global nfsd_create_setattr() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
7cfb17a22a0cf76477fbf1fbe6bf586108a13a44 diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index cc75e4f..035204f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1151,7 +1151,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 }
 #endif /* CONFIG_NFSD_V3 */
 
-__be32
+static __be32
 nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
 			struct iattr *iap)
 {

