Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYAXQ7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYAXQ7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbYAXQ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247AbYAXQ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:34 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/19] dlm: don't print common non-errors
Date: Thu, 24 Jan 2008 10:50:26 -0600
Message-Id: <1201193442-8260-4-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log_error() to log_debug() for conditions that can occur in
large number in normal operation.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 7bc6ad9..63fe74d 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4258,7 +4258,7 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 	put_rsb(r);
  out:
 	if (error)
-		log_print("recover_master_copy %d %x", error, rl->rl_lkid);
+		log_debug(ls, "recover_master_copy %d %x", error, rl->rl_lkid);
 	rl->rl_result = error;
 	return error;
 }
-- 
1.5.3.3

