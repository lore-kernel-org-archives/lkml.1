Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZIKStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZIKStT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZIKStS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:49:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZIKSsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:47 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [21/21] HWPOISON: Enable error_remove_page on btrfs
Message-Id: <20090911184850.46E81B1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: chris.mason@oracle.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/btrfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/fs/btrfs/inode.c
===================================================================
--- linux.orig/fs/btrfs/inode.c
+++ linux/fs/btrfs/inode.c
@@ -5269,6 +5269,7 @@ static struct address_space_operations b
 	.invalidatepage = btrfs_invalidatepage,
 	.releasepage	= btrfs_releasepage,
 	.set_page_dirty	= btrfs_set_page_dirty,
+	.error_remove_page = generic_error_remove_page,
 };
 
 static struct address_space_operations btrfs_symlink_aops = {
