Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYKZPzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYKZPzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYKZPy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:54:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:29667 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbYKZPyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:54:55 -0500
Message-ID: <154e089b0811260754y191856bfl522f33febfc6e633@mail.gmail.com>
Date: Wed, 26 Nov 2008 16:54:53 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Christoph Hellwig" <hch@infradead.org>,
       "David Chinner" <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] [XFS] fix sparse warning
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warning

Fix the following sparse warning:

  fs/xfs/xfs_inode.h:326:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 fs/xfs/xfs_inode.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c6e295e..7a828cb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -323,7 +323,7 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 static inline void xfs_destroy_inode(struct xfs_inode *ip)
 {
 	make_bad_inode(VFS_I(ip));
-	return destroy_inode(VFS_I(ip));
+	destroy_inode(VFS_I(ip));
 }

 /*
