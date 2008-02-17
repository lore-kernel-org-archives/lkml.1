Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbYBQIY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbYBQIY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbYBQIVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:21:10 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37016 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198AbYBQIVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:21:08 -0500
Date: Sun, 17 Feb 2008 10:20:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ocfs: make dlm_do_assert_master() static
Message-ID: <20080217082041.GV3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global dlm_do_assert_master() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d30e20106688e15d199297957c5fe1f6d79f23c9 diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index a54d33d..c92d1b1 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1695,9 +1695,9 @@ send_response:
  * can periodically run all locks owned by this node
  * and re-assert across the cluster...
  */
-int dlm_do_assert_master(struct dlm_ctxt *dlm,
-			 struct dlm_lock_resource *res,
-			 void *nodemap, u32 flags)
+static int dlm_do_assert_master(struct dlm_ctxt *dlm,
+				struct dlm_lock_resource *res,
+				void *nodemap, u32 flags)
 {
 	struct dlm_assert_master assert;
 	int to, tmpret;

