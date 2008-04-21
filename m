Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYDUIui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYDUIui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYDUIuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:50:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35494 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbYDUIt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:49:59 -0400
Date: Mon, 21 Apr 2008 11:49:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make struct o2cb_stack_ops static
Message-ID: <20080421084931.GT26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct o2cb_stack_ops static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
eb3ca85e31f3ddec51aaab0fd2243962d7ce1bc6 diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index ac1d74c..bbd1667 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -385,7 +385,7 @@ static int o2cb_cluster_this_node(unsigned int *node)
 	return 0;
 }
 
-struct ocfs2_stack_operations o2cb_stack_ops = {
+static struct ocfs2_stack_operations o2cb_stack_ops = {
 	.connect	= o2cb_cluster_connect,
 	.disconnect	= o2cb_cluster_disconnect,
 	.hangup		= o2cb_cluster_hangup,

