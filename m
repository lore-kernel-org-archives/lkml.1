Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZHBNL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZHBNL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZHBNLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:11:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZHBNLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:11:24 -0400
Date: Sun, 2 Aug 2009 13:09:47 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, jeff@garzik.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jeff@garzik.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1248856508.6987.3041.camel@twins>
References: <1248856508.6987.3041.camel@twins>
Subject: [tip:perfcounters/core] tracing, perf_counter: Add help text to CONFIG_EVENT_PROFILE
Message-ID: <tip-470a1396c25c27b4aff08b14d5c9cd9b3da15e09@git.kernel.org>
Git-Commit-ID: 470a1396c25c27b4aff08b14d5c9cd9b3da15e09
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:09:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  470a1396c25c27b4aff08b14d5c9cd9b3da15e09
Gitweb:     http://git.kernel.org/tip/470a1396c25c27b4aff08b14d5c9cd9b3da15e09
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 29 Jul 2009 10:50:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 13:47:53 +0200

tracing, perf_counter: Add help text to CONFIG_EVENT_PROFILE

Explain what tracepoint profiling sources are about.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jeff Garzik <jeff@garzik.org>
LKML-Reference: <1248856508.6987.3041.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 init/Kconfig |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index cb2c092..823ee0a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -961,9 +961,17 @@ config PERF_COUNTERS
 	  Say Y if unsure.
 
 config EVENT_PROFILE
-	bool "Tracepoint profile sources"
+	bool "Tracepoint profiling sources"
 	depends on PERF_COUNTERS && EVENT_TRACING
 	default y
+	help
+	 Allow the use of tracepoints as software performance counters.
+
+	 When this is enabled, you can create perf counters based on
+	 tracepoints using PERF_TYPE_TRACEPOINT and the tracepoint ID
+	 found in debugfs://tracing/events/*/*/id. (The -e/--events
+	 option to the perf tool can parse and interpret symbolic
+	 tracepoints, in the subsystem:tracepoint_name format.)
 
 endmenu
 
