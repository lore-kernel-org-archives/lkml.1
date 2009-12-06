Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbZLFNE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbZLFNE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 08:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZLFNE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 08:04:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:55726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159AbZLFNE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 08:04:27 -0500
Date: Sun, 6 Dec 2009 13:04:01 GMT
From: tip-bot for Frank Rowand <frank.rowand@am.sony.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, frank.rowand@am.sony.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, frank.rowand@am.sony.com,
       mingo@elte.hu
In-Reply-To: <4B05BE7D.30500@am.sony.com>
References: <4B05BE7D.30500@am.sony.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockstat: Add usage info to Documentation/lockstat.txt
Message-ID: <tip-f5754bfd107b08edddaf871d676ec6fe0792d07a@git.kernel.org>
Git-Commit-ID: f5754bfd107b08edddaf871d676ec6fe0792d07a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5754bfd107b08edddaf871d676ec6fe0792d07a
Gitweb:     http://git.kernel.org/tip/f5754bfd107b08edddaf871d676ec6fe0792d07a
Author:     Frank Rowand <frank.rowand@am.sony.com>
AuthorDate: Thu, 19 Nov 2009 13:54:05 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 13:20:02 +0100

lockstat: Add usage info to Documentation/lockstat.txt

Add usage info to Documentation/lockstat.txt

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4B05BE7D.30500@am.sony.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/lockstat.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index 9cb9138..65f4c79 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -62,8 +62,20 @@ applicable).
 It also tracks 4 contention points per class. A contention point is a call site
 that had to wait on lock acquisition.
 
+ - CONFIGURATION
+
+Lock statistics are enabled via CONFIG_LOCK_STATS.
+
  - USAGE
 
+Enable collection of statistics:
+
+# echo 1 >/proc/sys/kernel/lock_stat
+
+Disable collection of statistics:
+
+# echo 0 >/proc/sys/kernel/lock_stat
+
 Look at the current lock statistics:
 
 ( line numbers not part of actual output, done for clarity in the explanation
