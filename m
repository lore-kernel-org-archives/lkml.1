Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbZDHRBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbZDHRBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934421AbZDHQ7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:59:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:39163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934427AbZDHQ7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:59:49 -0400
Date: Wed, 8 Apr 2009 16:58:21 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090408130409.036984214@chello.nl>
References: <20090408130409.036984214@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add some comments
Message-ID: <tip-8740f9418c78dcad694b46ab25d1645d5aef1f5e@git.kernel.org>
Git-Commit-ID: 8740f9418c78dcad694b46ab25d1645d5aef1f5e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:58:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8740f9418c78dcad694b46ab25d1645d5aef1f5e
Gitweb:     http://git.kernel.org/tip/8740f9418c78dcad694b46ab25d1645d5aef1f5e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Apr 2009 15:01:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:53:29 +0200

perf_counter: add some comments

Add a few comments because I was forgetting what field what for what
functionality.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090408130409.036984214@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 4809ae1..8bf764f 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -344,10 +344,12 @@ struct file;
 
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
-	int				nr_pages;
-	atomic_t			wakeup;
-	atomic_t			head;
-	atomic_t			events;
+	int				nr_pages;	/* nr of data pages  */
+
+	atomic_t			wakeup;		/* POLL_ for wakeups */
+	atomic_t			head;		/* write position    */
+	atomic_t			events;		/* event limit       */
+
 	struct perf_counter_mmap_page   *user_page;
 	void 				*data_pages[0];
 };
