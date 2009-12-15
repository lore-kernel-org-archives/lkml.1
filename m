Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbZLOJl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbZLOJl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbZLOJlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:41:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:59225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759410AbZLOJlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:41:08 -0500
Date: Tue, 15 Dec 2009 09:40:43 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260867220-15699-7-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-7-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace/scripting: Update Documentation
Message-ID: <tip-a6005123ce22770dbd91bc3cb637ce0807ab959b@git.kernel.org>
Git-Commit-ID: a6005123ce22770dbd91bc3cb637ce0807ab959b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6005123ce22770dbd91bc3cb637ce0807ab959b
Gitweb:     http://git.kernel.org/tip/a6005123ce22770dbd91bc3cb637ce0807ab959b
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 15 Dec 2009 02:53:40 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 10:31:33 +0100

perf trace/scripting: Update Documentation

Update the perf-trace page with new and missing options and
remove some unused ones.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <1260867220-15699-7-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-trace.txt |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 07065ef..60e5900 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -8,18 +8,43 @@ perf-trace - Read perf.data (created by perf record) and display trace output
 SYNOPSIS
 --------
 [verse]
-'perf trace' [-i <file> | --input=file] symbol_name
+'perf trace' {record <script> | report <script> [args] }
 
 DESCRIPTION
 -----------
 This command reads the input file and displays the trace recorded.
 
+There are several variants of perf trace:
+
+  'perf trace' to see a detailed trace of the workload that was
+  recorded.
+
+  'perf trace record <script>' to record the events required for 'perf
+  trace report'.  <script> is the name displayed in the output of
+  'perf trace --list' i.e. the actual script name minus any language
+  extension.
+
+  'perf trace report <script>' to run and display the results of
+  <script>.  <script> is the name displayed in the output of 'perf
+  trace --list' i.e. the actual script name minus any language
+  extension.  The perf.data output from a previous run of 'perf trace
+  record <script>' is used and should be present for this command to
+  succeed.
+
 OPTIONS
 -------
 -D::
 --dump-raw-trace=::
         Display verbose dump of the trace data.
 
+-L::
+--Latency=::
+        Show latency attributes (irqs/preemption disabled, etc).
+
+-l::
+--list=::
+        Display a list of available trace scripts.
+
 -s::
 --script=::
         Process trace data with the given script ([lang]:script[.ext]).
