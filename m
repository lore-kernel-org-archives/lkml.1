Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZFFOW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZFFOW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZFFOWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:22:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:55093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZFFOWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:22:20 -0400
Date: Sat, 6 Jun 2009 14:21:39 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Tidy up manpage details
Message-ID: <tip-6e6b754ffdb6415723686c733f13275397e44422@git.kernel.org>
Git-Commit-ID: 6e6b754ffdb6415723686c733f13275397e44422
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 14:21:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e6b754ffdb6415723686c733f13275397e44422
Gitweb:     http://git.kernel.org/tip/6e6b754ffdb6415723686c733f13275397e44422
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 15 Apr 2008 22:39:31 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 15:15:48 +0200

perf_counter tools: Tidy up manpage details

Also fix a misalignment in usage string printing.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../perf_counter/Documentation/perf-help.txt       |    2 +-
 .../perf_counter/Documentation/perf-list.txt       |    4 ++--
 .../perf_counter/Documentation/perf-stat.txt       |    2 +-
 .../perf_counter/Documentation/perf-top.txt        |    2 +-
 Documentation/perf_counter/util/parse-options.c    |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/perf_counter/Documentation/perf-help.txt b/Documentation/perf_counter/Documentation/perf-help.txt
index f85fed5..5143918 100644
--- a/Documentation/perf_counter/Documentation/perf-help.txt
+++ b/Documentation/perf_counter/Documentation/perf-help.txt
@@ -1,5 +1,5 @@
 perf-help(1)
-===========
+============
 
 NAME
 ----
diff --git a/Documentation/perf_counter/Documentation/perf-list.txt b/Documentation/perf_counter/Documentation/perf-list.txt
index aa55a71..8290b94 100644
--- a/Documentation/perf_counter/Documentation/perf-list.txt
+++ b/Documentation/perf_counter/Documentation/perf-list.txt
@@ -1,5 +1,5 @@
 perf-list(1)
-==============
+============
 
 NAME
 ----
@@ -8,7 +8,7 @@ perf-list - List all symbolic event types
 SYNOPSIS
 --------
 [verse]
-'perf list
+'perf list'
 
 DESCRIPTION
 -----------
diff --git a/Documentation/perf_counter/Documentation/perf-stat.txt b/Documentation/perf_counter/Documentation/perf-stat.txt
index 5d95784..c368a72 100644
--- a/Documentation/perf_counter/Documentation/perf-stat.txt
+++ b/Documentation/perf_counter/Documentation/perf-stat.txt
@@ -1,5 +1,5 @@
 perf-stat(1)
-==========
+============
 
 NAME
 ----
diff --git a/Documentation/perf_counter/Documentation/perf-top.txt b/Documentation/perf_counter/Documentation/perf-top.txt
index c8eb7cf..539d012 100644
--- a/Documentation/perf_counter/Documentation/perf-top.txt
+++ b/Documentation/perf_counter/Documentation/perf-top.txt
@@ -1,5 +1,5 @@
 perf-top(1)
-==========
+===========
 
 NAME
 ----
diff --git a/Documentation/perf_counter/util/parse-options.c b/Documentation/perf_counter/util/parse-options.c
index e4d3533..b3affb1 100644
--- a/Documentation/perf_counter/util/parse-options.c
+++ b/Documentation/perf_counter/util/parse-options.c
@@ -387,7 +387,7 @@ int usage_with_options_internal(const char * const *usagestr,
 
 	fprintf(stderr, "\n usage: %s\n", *usagestr++);
 	while (*usagestr && **usagestr)
-		fprintf(stderr, "   or: %s\n", *usagestr++);
+		fprintf(stderr, "    or: %s\n", *usagestr++);
 	while (*usagestr) {
 		fprintf(stderr, "%s%s\n",
 				**usagestr ? "    " : "",
