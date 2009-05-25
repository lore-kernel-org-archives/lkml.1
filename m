Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbZEYNE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbZEYNE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZEYNET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:04:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:53283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZEYNES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:04:18 -0400
Date: Mon, 25 May 2009 13:03:44 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525124600.116035832@chello.nl>
References: <20090525124600.116035832@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Remove unused ABI bits
Message-ID: <tip-e527ea312f31e88a7fa5472b71db71c565b0d44f@git.kernel.org>
Git-Commit-ID: e527ea312f31e88a7fa5472b71db71c565b0d44f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 13:03:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e527ea312f31e88a7fa5472b71db71c565b0d44f
Gitweb:     http://git.kernel.org/tip/e527ea312f31e88a7fa5472b71db71c565b0d44f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 May 2009 14:45:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 14:55:00 +0200

perf_counter: Remove unused ABI bits

extra_config_len isn't used for anything, remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525124600.116035832@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 2ddf5e3..b1f2bac 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
