Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZLIH2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZLIH2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZLIH2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:28:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:45809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbZLIH2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:28:18 -0500
Date: Wed, 9 Dec 2009 07:26:29 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091208220330.10142.73296.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220330.10142.73296.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Update perf-probe document
Message-ID: <tip-c937fe20cb6d9e24c6ad5f9f0c64d64c78411057@git.kernel.org>
Git-Commit-ID: c937fe20cb6d9e24c6ad5f9f0c64d64c78411057
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c937fe20cb6d9e24c6ad5f9f0c64d64c78411057
Gitweb:     http://git.kernel.org/tip/c937fe20cb6d9e24c6ad5f9f0c64d64c78411057
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Dec 2009 17:03:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 07:26:54 +0100

perf probe: Update perf-probe document

Add --list and --del option descriptions to perf-probe.txt.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
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
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091208220330.10142.73296.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
