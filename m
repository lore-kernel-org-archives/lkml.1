Return-Path: <linux-kernel-owner+w=401wt.eu-S934470AbZHEONO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470AbZHEONO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934404AbZHEONN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:13:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:44206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934333AbZHEONM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:13:12 -0400
Date: Wed, 5 Aug 2009 14:12:40 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090805130453.GC10688@ghostprotocols.net>
References: <20090805130453.GC10688@ghostprotocols.net>
Subject: [tip:perfcounters/urgent] perf report: Add missing command line options to man page
Message-ID: <tip-386c0b702b1ea81c0f54f5c9832a3d4a52270f14@git.kernel.org>
Git-Commit-ID: 386c0b702b1ea81c0f54f5c9832a3d4a52270f14
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 14:12:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  386c0b702b1ea81c0f54f5c9832a3d4a52270f14
Gitweb:     http://git.kernel.org/tip/386c0b702b1ea81c0f54f5c9832a3d4a52270f14
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 5 Aug 2009 10:04:53 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Aug 2009 16:09:28 +0200

perf report: Add missing command line options to man page

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090805130453.GC10688@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-record.txt |   60 ++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 1dbc1ee..6be696b 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -29,13 +29,67 @@ OPTIONS
 	Select the PMU event. Selection can be a symbolic event name
 	(use 'perf list' to list all events) or a raw PMU
 	event (eventsel+umask) in the form of rNNN where NNN is a
-	 hexadecimal event descriptor.
+	hexadecimal event descriptor.
 
 -a::
-        system-wide collection
+        System-wide collection.
 
 -l::
-        scale counter values
+        Scale counter values.
+
+-p::
+--pid=::
+	Record events on existing pid.
+
+-r::
+--realtime=::
+	Collect data with this RT SCHED_FIFO priority.
+-A::
+--append::
+	Append to the output file to do incremental profiling.
+
+-f::
+--force::
+	Overwrite existing data file.
+
+-c::
+--count=::
+	Event period to sample.
+
+-o::
+--output=::
+	Output file name.
+
+-i::
+--inherit::
+	Child tasks inherit counters.
+-F::
+--freq=::
+	Profile at this frequency.
+
+-m::
+--mmap-pages=::
+	Number of mmap data pages.
+
+-g::
+--call-graph::
+	Do call-graph (stack chain/backtrace) recording.
+
+-v::
+--verbose::
+	Be more verbose (show counter open errors, etc).
+
+-s::
+--stat::
+	Per thread counts.
+
+-d::
+--data::
+	Sample addresses.
+
+-n::
+--no-samples::
+	Don't sample.
 
 SEE ALSO
 --------
