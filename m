Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbZLOILZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbZLOILZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZLOILX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:11:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:33987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZLOILW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:11:22 -0500
Date: Tue, 15 Dec 2009 08:10:53 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260843322-6602-1-git-send-regression-fweisbec@gmail.com>
References: <1260843322-6602-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Make symbol_conf static
Message-ID: <tip-c249a4ce796b30b742bb4854bf3039ced12ef8e5@git.kernel.org>
Git-Commit-ID: c249a4ce796b30b742bb4854bf3039ced12ef8e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c249a4ce796b30b742bb4854bf3039ced12ef8e5
Gitweb:     http://git.kernel.org/tip/c249a4ce796b30b742bb4854bf3039ced12ef8e5
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 15 Dec 2009 03:15:22 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 08:52:31 +0100

perf tools: Make symbol_conf static

perf top, report and annotate all define their own symbol_conf,
it should be static.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1260843322-6602-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index beff7c0..40389c0 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,7 +52,7 @@ static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-struct symbol_conf	symbol_conf;
+static struct symbol_conf	symbol_conf;
 
 
 static size_t
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3b212bb..296e809 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -80,7 +80,7 @@ static int			dump_symtab                     =      0;
 static bool			hide_kernel_symbols		=  false;
 static bool			hide_user_symbols		=  false;
 static struct winsize		winsize;
-struct symbol_conf		symbol_conf;
+static struct symbol_conf	symbol_conf;
 
 /*
  * Source
