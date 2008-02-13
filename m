Return-Path: <linux-kernel-owner+w=401wt.eu-S1764925AbYBMVcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764925AbYBMVcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762835AbYBMV3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:29:55 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55649 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762729AbYBMV3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:29:54 -0500
Date: Wed, 13 Feb 2008 23:29:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Teigland <teigland@redhat.com>, pcaulfie@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make dlm_print_rsb() static
Message-ID: <20080213212938.GG3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dlm_print_rsb() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/dlm/lock.c |    2 +-
 fs/dlm/lock.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

95f682b14f6bcea2cb8f3ff7acb3c5a11593e354 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ff4a198..8f99a57 100644
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
index 27b6ed3..3b31b07 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -13,7 +13,6 @@
 #ifndef __LOCK_DOT_H__
 #define __LOCK_DOT_H__
 
-void dlm_print_rsb(struct dlm_rsb *r);
 void dlm_dump_rsb(struct dlm_rsb *r);
 void dlm_print_lkb(struct dlm_lkb *lkb);
 void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms);

