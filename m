Return-Path: <linux-kernel-owner+w=401wt.eu-S1946157AbXBIWzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946157AbXBIWzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946135AbXBIWyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:17 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60492 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423374AbXBIWxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:46 -0500
Subject: [PATCH 20/22] [PATCH] gfs: check nlink count
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:43 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225343.BA9E6B45@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---

 lxc-dave/fs/gfs2/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/gfs2/inode.c~gfs-check-nlink-count fs/gfs2/inode.c
--- lxc/fs/gfs2/inode.c~gfs-check-nlink-count	2007-02-09 14:26:59.000000000 -0800
+++ lxc-dave/fs/gfs2/inode.c	2007-02-09 14:26:59.000000000 -0800
@@ -169,6 +169,7 @@ static int gfs2_dinode_in(struct gfs2_in
 	 * to do that.
 	 */
 	ip->i_inode.i_nlink = be32_to_cpu(str->di_nlink);
+	check_nlink(&ip->i_inode);
 	di->di_size = be64_to_cpu(str->di_size);
 	i_size_write(&ip->i_inode, di->di_size);
 	di->di_blocks = be64_to_cpu(str->di_blocks);
_
