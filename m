Return-Path: <linux-kernel-owner+w=401wt.eu-S966611AbZLHV7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966611AbZLHV7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966559AbZLHV7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:59:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966555AbZLHV7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:59:38 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 8/8] perf probe: Update perf-probe document
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 08 Dec 2009 17:03:30 -0500
Message-ID: <20091208220330.10142.73296.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --list and --del option descriptions to perf-probe.txt.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 tools/perf/Documentation/perf-probe.txt |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 9270594..8fa6bf9 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -8,10 +8,13 @@ perf-probe - Define new dynamic tracepoints
 SYNOPSIS
 --------
 [verse]
-'perf probe' [options] --add 'PROBE' [--add 'PROBE' ...]
+'perf probe' [options] --add='PROBE' [...]
 or
-'perf probe' [options] 'PROBE' ['PROBE' ...]
-
+'perf probe' [options] PROBE
+or
+'perf probe' [options] --del='[GROUP:]EVENT' [...]
+or
+'perf probe' --list
 
 DESCRIPTION
 -----------
@@ -31,8 +34,16 @@ OPTIONS
         Be more verbose (show parsed arguments, etc).
 
 -a::
---add::
-	Define a probe point (see PROBE SYNTAX for detail)
+--add=::
+	Define a probe event (see PROBE SYNTAX for detail).
+
+-d::
+--del=::
+	Delete a probe event.
+
+-l::
+--list::
+	List up current probe events.
 
 PROBE SYNTAX
 ------------


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
