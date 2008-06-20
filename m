Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYFTN3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYFTN3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYFTN3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:29:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:56081 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752905AbYFTN3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:29:41 -0400
From: David Sterba <dsterba@suse.cz>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH] [TRIVIAL] proc: misplaced export of find_get_pid
Date: Fri, 20 Jun 2008 15:29:40 +0200
Message-Id: <1213968580-26873-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.5.6.rc3.11.g5f54d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move EXPORT_SYMBOL right after the func

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 kernel/pid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 20d59fa..79d11dd 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -434,6 +434,7 @@ struct pid *find_get_pid(pid_t nr)
 
 	return pid;
 }
+EXPORT_SYMBOL_GPL(find_get_pid);
 
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
 {
@@ -496,7 +497,6 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 
 	return pid;
 }
-EXPORT_SYMBOL_GPL(find_get_pid);
 
 /*
  * The pid hash table is scaled according to the amount of memory in the
-- 
1.5.6.rc3.11.g5f54d

