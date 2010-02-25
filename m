Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0BYDoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:44:07 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49649 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0BYDms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:42:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ptDLPeEsveXXFSim5RAlKRIwx/hvLMv5qKIYq9J5GWIslDiT8kXklMmxr64QH0wo+P
         x9VHyp0KHG8MeFN9DoGsA1RhjOC5f9SDrXAOYI1ti4JxNAZ/ATu3z3S2lotpW97l8AiM
         OIEEq3e60tNSZiE0TF0kridBE52NWAdWTG85o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/10] perf/scripts: Remove check-perf-trace from listed scripts
Date: Thu, 25 Feb 2010 04:42:36 +0100
Message-Id: <1267069361-10909-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
References: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

The check-perf-trace script only checks Perl functionality, and
doesn't really need to be listed as as user script anyway.

This only removes the '-report' shell script, so although it doesn't
appear in the listing, the '-record' shell script and the check perf
trace perl script itself is still available and can still be run
manually as such:

$ libexec/perf-core/scripts/perl/bin/check-perf-trace-record
$ perf trace -s libexec/perf-core/scripts/perl/check-perf-trace.pl

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1264580883-15324-6-git-send-email-tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 .../perf/scripts/perl/bin/check-perf-trace-record  |    5 -----
 .../perf/scripts/perl/bin/check-perf-trace-report  |    6 ------
 2 files changed, 0 insertions(+), 11 deletions(-)
 delete mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-report

diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-record b/tools/perf/scripts/perl/bin/check-perf-trace-record
index c7ec5de..3c15744 100644
--- a/tools/perf/scripts/perl/bin/check-perf-trace-record
+++ b/tools/perf/scripts/perl/bin/check-perf-trace-record
@@ -1,7 +1,2 @@
 #!/bin/bash
 perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry
-
-
-
-
-
diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-report b/tools/perf/scripts/perl/bin/check-perf-trace-report
deleted file mode 100644
index 7fc4a03..0000000
--- a/tools/perf/scripts/perl/bin/check-perf-trace-report
+++ /dev/null
@@ -1,6 +0,0 @@
-#!/bin/bash
-# description: useless but exhaustive test script
-perf trace -s ~/libexec/perf-core/scripts/perl/check-perf-trace.pl
-
-
-
-- 
1.6.2.3

