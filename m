Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbZLOIyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbZLOIyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbZLOIx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:53:57 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53661 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164AbZLOIxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BbO10AKRsIybI4LjDgrXokjft27zs8DO34BVtXNtv2+Ng/HwRHLwOXa5qikQuGaQI4
         AL3zuF6Hh6AWvr61WVAcnjgZtqqLJmjDV2K4qgW/2DROxfoEUa93ClHY98ZbU8Og5iwG
         UNQ8XBviEqtgLIGyfV9hUIY9BrG/q2O6dSxXs=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 6/6] perf trace/scripting: update Documentation
Date: Tue, 15 Dec 2009 02:53:40 -0600
Message-Id: <1260867220-15699-7-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the perf-trace page with new and missing options and remove
some unused ones.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
-- 
1.6.4.GIT

