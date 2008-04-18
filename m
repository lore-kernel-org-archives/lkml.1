Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbYDRSTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbYDRSTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760418AbYDRSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:19:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760419AbYDRSTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:19:30 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 2/6] dlm: make dlm_print_rsb() static
Date: Fri, 18 Apr 2008 13:12:44 -0500
Message-Id: <1208542368-13417-3-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

dlm_print_rsb() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    2 +-
 fs/dlm/lock.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 8f250ac..1e9e8eb 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -165,7 +165,7 @@ void dlm_print_lkb(struct dlm_lkb *lkb)
 	       lkb->lkb_grmode, lkb->lkb_wait_type, lkb->lkb_ast_type);
 }
 
-void dlm_print_rsb(struct dlm_rsb *r)
+static void dlm_print_rsb(struct dlm_rsb *r)
 {
 	printk(KERN_ERR "rsb: nodeid %d flags %lx first %x rlc %d name %s\n",
 	       r->res_nodeid, r->res_flags, r->res_first_lkid,
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 05d9c82..88e93c8 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -13,7 +13,6 @@
 #ifndef __LOCK_DOT_H__
 #define __LOCK_DOT_H__
 
-void dlm_print_rsb(struct dlm_rsb *r);
 void dlm_dump_rsb(struct dlm_rsb *r);
 void dlm_print_lkb(struct dlm_lkb *lkb);
 void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms);
-- 
1.5.3.3

