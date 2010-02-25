Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0BYKIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:08:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:47494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab0BYKIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:08:17 -0500
Date: Thu, 25 Feb 2010 10:07:41 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264580883-15324-6-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-6-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/scripts: Remove check-perf-trace from listed scripts
Message-ID: <tip-266fe2f217d1dc9f8041e395c0ab4569a5bad91a@git.kernel.org>
Git-Commit-ID: 266fe2f217d1dc9f8041e395c0ab4569a5bad91a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:07:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  266fe2f217d1dc9f8041e395c0ab4569a5bad91a
Gitweb:     http://git.kernel.org/tip/266fe2f217d1dc9f8041e395c0ab4569a5bad91a
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 27 Jan 2010 02:27:56 -0600
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 23 Feb 2010 20:58:59 +0100

perf/scripts: Remove check-perf-trace from listed scripts

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
