Return-Path: <linux-kernel-owner+w=401wt.eu-S1765451AbZDHNHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765451AbZDHNHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765354AbZDHNDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765343AbZDHNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:33 -0400
Message-Id: <20090408130409.036984214@chello.nl>
References: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:29 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/9] perf_counter: add some comments
Content-Disposition: inline; filename=perf_counter-more-comments.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a few comments because I was forgetting what field what for what
functionality.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -347,10 +347,12 @@ struct file;
 
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

-- 

