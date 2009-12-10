Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbZLJN7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbZLJN7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760829AbZLJN6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:58:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760519AbZLJN6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:58:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/7] NOMMU: ramfs: Drop unused local var
To: vapier.adi@gmail.com, lethal@linux-sh.org, jie.zhang@analog.com,
       stefani@seibold.net, gerg@snapgear.com
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Dec 2009 13:58:27 +0000
Message-ID: <20091210135826.6325.75634.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk>
References: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 32fae40..2efc571 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -60,7 +60,7 @@ const struct inode_operations ramfs_file_inode_operations = {
  */
 int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 {
-	unsigned long npages, xpages, loop, limit;
+	unsigned long npages, xpages, loop;
 	struct page *pages;
 	unsigned order;
 	void *data;

