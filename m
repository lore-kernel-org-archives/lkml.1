Return-Path: <linux-kernel-owner+w=401wt.eu-S1763888AbZE0Hib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763888AbZE0Hib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216AbZE0HhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:37:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:59712 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbZE0HhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:37:17 -0400
Date: Wed, 27 May 2009 07:36:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Rename output.perf to perf.data
Message-ID: <tip-23ac9cbed82b00ca3520bb81dbe9ea3b7a936a1b@git.kernel.org>
Git-Commit-ID: 23ac9cbed82b00ca3520bb81dbe9ea3b7a936a1b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 07:36:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23ac9cbed82b00ca3520bb81dbe9ea3b7a936a1b
Gitweb:     http://git.kernel.org/tip/23ac9cbed82b00ca3520bb81dbe9ea3b7a936a1b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 May 2009 09:33:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 09:33:18 +0200

perf_counter tools: Rename output.perf to perf.data

output.perf is only output to perf-record - it's input to
perf-report. So change it to a more direction-neutral name.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../perf_counter/Documentation/perf-record.txt     |    4 ++--
 .../perf_counter/Documentation/perf-report.txt     |    4 ++--
 Documentation/perf_counter/builtin-record.c        |    2 +-
 Documentation/perf_counter/builtin-report.c        |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/perf_counter/Documentation/perf-record.txt b/Documentation/perf_counter/Documentation/perf-record.txt
index d07700e..353db1b 100644
--- a/Documentation/perf_counter/Documentation/perf-record.txt
+++ b/Documentation/perf_counter/Documentation/perf-record.txt
@@ -3,7 +3,7 @@ perf-record(1)
 
 NAME
 ----
-perf-record - Run a command and record its profile into output.perf
+perf-record - Run a command and record its profile into perf.data
 
 SYNOPSIS
 --------
@@ -13,7 +13,7 @@ SYNOPSIS
 DESCRIPTION
 -----------
 This command runs a command and gathers a performance counter profile
-from it, into output.perf - without displaying anything.
+from it, into perf.data - without displaying anything.
 
 This file can then be inspected later on, using 'perf report'.
 
diff --git a/Documentation/perf_counter/Documentation/perf-report.txt b/Documentation/perf_counter/Documentation/perf-report.txt
index 64696a2..49efe16 100644
--- a/Documentation/perf_counter/Documentation/perf-report.txt
+++ b/Documentation/perf_counter/Documentation/perf-report.txt
@@ -3,7 +3,7 @@ perf-report(1)
 
 NAME
 ----
-perf-report - Read output.perf (created by perf record) and display the profile
+perf-report - Read perf.data (created by perf record) and display the profile
 
 SYNOPSIS
 --------
@@ -19,7 +19,7 @@ OPTIONS
 -------
 -i::
 --input=::
-        Input file name. (default: output.perf)
+        Input file name. (default: perf.data)
 
 Configuration
 -------------
diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 68abfdf..431077a 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -19,7 +19,7 @@ static int			nr_cpus				=  0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= 16;
 static int			output;
-static const char		*output_name			= "output.perf";
+static const char		*output_name			= "perf.data";
 static int			group				= 0;
 static unsigned int		realtime_prio			= 0;
 static int			system_wide			= 0;
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 7f1255d..e2712cd 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -18,7 +18,7 @@
 #define SHOW_USER	2
 #define SHOW_HV		4
 
-static char		const *input_name = "output.perf";
+static char		const *input_name = "perf.data";
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
