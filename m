Return-Path: <linux-kernel-owner+w=401wt.eu-S934296AbZHENFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934296AbZHENFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933658AbZHENFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:05:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46625 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480AbZHENFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:05:06 -0400
Date: Wed, 5 Aug 2009 10:04:53 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] perf report: Add missing command line options to man
	page
Message-ID: <20090805130453.GC10688@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

