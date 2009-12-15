Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZLOJ2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZLOJ2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbZLOJ2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:28:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:48380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbZLOJ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:28:19 -0500
Date: Tue, 15 Dec 2009 09:27:34 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/diff] perf diff: Improve the help text
Message-ID: <tip-0afd1f750292da52e4b1129be82de9c065275764@git.kernel.org>
Git-Commit-ID: 0afd1f750292da52e4b1129be82de9c065275764
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0afd1f750292da52e4b1129be82de9c065275764
Gitweb:     http://git.kernel.org/tip/0afd1f750292da52e4b1129be82de9c065275764
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 15 Dec 2009 10:24:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 10:24:08 +0100

perf diff: Improve the help text

Fix the short line displayed by 'perf' and also fix some other
details in the longer text.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-diff.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index bd1ee55..b7c393b 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -3,7 +3,7 @@ perf-diff(1)
 
 NAME
 ----
-perf-diff - Read perf.data (created by perf record) and display the profile
+perf-diff - Read two perf.data files and display the differential profile
 
 SYNOPSIS
 --------
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This command displays the performance difference among two perf.data files
+This command displays the performance difference amongst two perf.data files
 captured via perf record.
 
 If no parameters are passed it will assume perf.data.old and perf.data.
@@ -21,10 +21,10 @@ OPTIONS
 -------
 -p::
 --percentage::
-	Show percentages instead of raw counters
+	Show percentages instead of raw counts
 -v::
 --verbose::
-	Be verbose, for instance, show the raw counters in addition to the
+	Be verbose, for instance, show the raw counts in addition to the
 	diff.
 SEE ALSO
 --------
