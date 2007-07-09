Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbXGIQ33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbXGIQ33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbXGIQXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbXGIQXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>,
       Fabio Massimo Di Nitto <fabbione@ubuntu.com>,
       David Teigland <teigland@redhat.com>
Subject: [PATCH] [DLM] Compile fix
Date: Mon,  9 Jul 2007 17:02:25 +0100
Message-Id: <11839970282009-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183997026104-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

A one liner fix which got missed from the earlier patches.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Fabio Massimo Di Nitto <fabbione@ubuntu.com>
Cc: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index b47e6fd..2f8a5a7 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1098,7 +1098,7 @@ void dlm_scan_timeout(struct dlm_ls *ls)
 		}
 
 		if (do_cancel) {
-			log_debug(r->res_ls, "timeout cancel %x node %d %s",
+			log_debug(ls, "timeout cancel %x node %d %s",
 				  lkb->lkb_id, lkb->lkb_nodeid, r->res_name);
 			lkb->lkb_flags &= ~DLM_IFL_WATCH_TIMEWARN;
 			lkb->lkb_flags |= DLM_IFL_TIMEOUT_CANCEL;
-- 
1.5.1.2

