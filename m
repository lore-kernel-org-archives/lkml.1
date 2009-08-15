Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbZHOKHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbZHOKHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZHOKHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:07:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:52692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbZHOKHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:07:33 -0400
Date: Sat, 15 Aug 2009 10:07:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, eranian@googlemail.com, cjashfor@us.ibm.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, cjashfor@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090813103655.334194326@chello.nl>
References: <20090813103655.334194326@chello.nl>
Subject: [tip:perfcounters/core] perf tools: Add some comments to the event definitions
Message-ID: <tip-18408ddc01136f505ae357c03f0d8e50b10e0db6@git.kernel.org>
Git-Commit-ID: 18408ddc01136f505ae357c03f0d8e50b10e0db6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 10:07:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18408ddc01136f505ae357c03f0d8e50b10e0db6
Gitweb:     http://git.kernel.org/tip/18408ddc01136f505ae357c03f0d8e50b10e0db6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 13 Aug 2009 11:47:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 12:00:09 +0200

perf tools: Add some comments to the event definitions

Just to make it clear that these are _not_ generic event
structures but do rely on the counter configuration.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey J Ashford <cjashfor@us.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
LKML-Reference: <20090813103655.334194326@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/event.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d26dc88..fa7c50b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -4,6 +4,9 @@
 #include "util.h"
 #include <linux/list.h>
 
+/*
+ * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
+ */
 struct ip_event {
 	struct perf_event_header header;
 	u64 ip;
@@ -38,6 +41,9 @@ struct lost_event {
 	u64 lost;
 };
 
+/*
+ * PERF_FORMAT_ENABLED | PERF_FORMAT_RUNNING | PERF_FORMAT_ID
+ */
 struct read_event {
 	struct perf_event_header header;
 	u32 pid,tid;
