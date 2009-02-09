Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZBIMl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZBIMl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZBIMlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:41:18 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:23163 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbZBIMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=kzivU2mbkPev6LDOCwLAOunITMWwaTrvylIoskGqKfj1WgbbIdcj1LlYsWsCyFNHT6
         S8hctUS1USFKm0BnVrUKWW7n9SJijRPMYXazZoLtD6/RNrOsIJZTggJg6+ur5bWYu4PR
         YUNPwEEx9/LkKurSlR7eVs0PLMBG2CgCqZmGA=
Message-ID: <49902469.044e6e0a.6ef4.6a60@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove redundant codes for split_state()
Date: Mon, 9 Feb 2009 20:41:10 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two lines are needless, remove them.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 37d43b5..ebe6b29 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -415,8 +415,6 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 
 	node = tree_insert(&tree->state, prealloc->end, &prealloc->rb_node);
 	if (node) {
-		struct extent_state *found;
-		found = rb_entry(node, struct extent_state, rb_node);
 		free_extent_state(prealloc);
 		return -EEXIST;
 	}

