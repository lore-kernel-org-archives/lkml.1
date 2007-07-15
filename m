Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbXGOUDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbXGOUDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbXGOUBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:01:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39949 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbXGOUBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:01:12 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fallout from constified seq_operations
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1IAAHI-00056G-2M@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:01:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/atm/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index 88154da..99fc1fe 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -110,7 +110,7 @@ static inline void *vcc_walk(struct vcc_state *state, loff_t l)
 }
 
 static int __vcc_seq_open(struct inode *inode, struct file *file,
-	int family, struct seq_operations *ops)
+	int family, const struct seq_operations *ops)
 {
 	struct vcc_state *state;
 	struct seq_file *seq;
-- 
1.5.3.GIT


