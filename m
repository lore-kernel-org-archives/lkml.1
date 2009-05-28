Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbZE1WEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbZE1WEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZE1WEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:04:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:50876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZE1WEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:04:13 -0400
Date: Thu, 28 May 2009 22:03:34 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Document '--' option parsing terminator
Message-ID: <tip-9e09675366695405412b709e91709c1ce2925c90@git.kernel.org>
Git-Commit-ID: 9e09675366695405412b709e91709c1ce2925c90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 May 2009 22:03:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e09675366695405412b709e91709c1ce2925c90
Gitweb:     http://git.kernel.org/tip/9e09675366695405412b709e91709c1ce2925c90
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 28 May 2009 16:25:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 00:02:33 +0200

perf_counter tools: Document '--' option parsing terminator

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../perf_counter/Documentation/perf-record.txt     |    1 +
 .../perf_counter/Documentation/perf-stat.txt       |    1 +
 Documentation/perf_counter/builtin-record.c        |    3 ++-
 Documentation/perf_counter/builtin-stat.c          |    1 +
 4 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/Documentation/perf-record.txt b/Documentation/perf_counter/Documentation/perf-record.txt
index 353db1b..a93d2ec 100644
--- a/Documentation/perf_counter/Documentation/perf-record.txt
+++ b/Documentation/perf_counter/Documentation/perf-record.txt
@@ -9,6 +9,7 @@ SYNOPSIS
 --------
 [verse]
 'perf record' [-e <EVENT> | --event=EVENT] [-l] [-a] <command>
+'perf record' [-e <EVENT> | --event=EVENT] [-l] [-a] -- <command> [<options>]
 
 DESCRIPTION
 -----------
diff --git a/Documentation/perf_counter/Documentation/perf-stat.txt b/Documentation/perf_counter/Documentation/perf-stat.txt
index 7fcab27..828c59f 100644
--- a/Documentation/perf_counter/Documentation/perf-stat.txt
+++ b/Documentation/perf_counter/Documentation/perf-stat.txt
@@ -9,6 +9,7 @@ SYNOPSIS
 --------
 [verse]
 'perf stat' [-e <EVENT> | --event=EVENT] [-l] [-a] <command>
+'perf stat' [-e <EVENT> | --event=EVENT] [-l] [-a] -- <command> [<options>]
 
 DESCRIPTION
 -----------
diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 4a06866..23d1224 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -397,7 +397,8 @@ static int __cmd_record(int argc, const char **argv)
 }
 
 static const char * const record_usage[] = {
-	"perf record [<options>] <command>",
+	"perf record [<options>] [<command>]",
+	"perf record [<options>] -- <command> [<options>]",
 	NULL
 };
 
diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index ce661e2..ac14086 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -212,6 +212,7 @@ static void skip_signal(int signo)
 
 static const char * const stat_usage[] = {
 	"perf stat [<options>] <command>",
+	"perf stat [<options>] -- <command> [<options>]",
 	NULL
 };
 
