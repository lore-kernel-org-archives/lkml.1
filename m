Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZEYMrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZEYMrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZEYMrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:47:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:47585 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZEYMrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:47:06 -0400
Message-Id: <20090525124600.116035832@chello.nl>
References: <20090525124523.010479297@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 25 May 2009 14:45:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/5] perf_counter: remove unused ABI bits.
Content-Disposition: inline; filename=perf_counter-cleanup-abi.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extra_config_len isn't used for anything, remove it.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -154,11 +154,11 @@ struct perf_counter_hw_event {
 
 				__reserved_1   : 51;
 
-	__u32			extra_config_len;
 	__u32			wakeup_events;	/* wakeup every n events */
+	__u32			__reserved_2;
 
-	__u64			__reserved_2;
 	__u64			__reserved_3;
+	__u64			__reserved_4;
 };
 
 /*

-- 

