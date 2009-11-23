Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZKWRn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZKWRn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZKWRny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:43:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:41575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbZKWRnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:43:52 -0500
Date: Mon, 23 Nov 2009 17:43:21 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Include only linux/perf_event.h from kernel part of bp headers
Message-ID: <tip-e6db4876575f3fdd5b1df2cbff826df95ab9af6a@git.kernel.org>
Git-Commit-ID: e6db4876575f3fdd5b1df2cbff826df95ab9af6a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6db4876575f3fdd5b1df2cbff826df95ab9af6a
Gitweb:     http://git.kernel.org/tip/e6db4876575f3fdd5b1df2cbff826df95ab9af6a
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 23 Nov 2009 15:42:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 18:18:30 +0100

hw-breakpoints: Include only linux/perf_event.h from kernel part of bp headers

As userspace only needs the breakpoints enum types from the
breakpoints headers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hw_breakpoint.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 4659e0c..76a48ab 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_HW_BREAKPOINT_H
 #define _LINUX_HW_BREAKPOINT_H
 
-#include <linux/perf_event.h>
-
 enum {
 	HW_BREAKPOINT_LEN_1 = 1,
 	HW_BREAKPOINT_LEN_2 = 2,
@@ -19,6 +17,8 @@ enum {
 #ifdef __KERNEL__
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
+#include <linux/perf_event.h>
+
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
