Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZIVNqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZIVNqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZIVNqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:46:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38836 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZIVNqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:46:07 -0400
Date: Tue, 22 Sep 2009 13:45:38 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090922123424.GD19453@kryten>
References: <20090922123424.GD19453@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Update PERF_EVENT_FORK header definition
Message-ID: <tip-a6f10a2f5d8c2738b3ac05974bdbea3b68a2aecd@git.kernel.org>
Git-Commit-ID: a6f10a2f5d8c2738b3ac05974bdbea3b68a2aecd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 13:45:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6f10a2f5d8c2738b3ac05974bdbea3b68a2aecd
Gitweb:     http://git.kernel.org/tip/a6f10a2f5d8c2738b3ac05974bdbea3b68a2aecd
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 22 Sep 2009 22:34:24 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 15:42:01 +0200

perf_event: Update PERF_EVENT_FORK header definition

PERF_EVENT_FORK always outputs the time field, so update the header
to reflect this.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090922123424.GD19453@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 +-
 include/linux/perf_event.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 368bd70..7b7fbf4 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -361,7 +361,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
-	 *	{ u64				time;     } && PERF_SAMPLE_TIME
+	 *	u64				time;
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index acefaf7..3a9d36d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -357,7 +357,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
-	 *	{ u64				time;     } && PERF_SAMPLE_TIME
+	 *	u64				time;
 	 * };
 	 */
 	PERF_RECORD_FORK			= 7,
