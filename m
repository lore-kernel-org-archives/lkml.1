Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZKDP0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZKDP0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZKDP0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:26:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:57364 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbZKDP0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:26:33 -0500
Date: Wed, 4 Nov 2009 15:25:29 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091104001238.3454.70508.stgit@harusame>
References: <20091104001238.3454.70508.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf/probes: Rename perf probe events group name
Message-ID: <tip-91365bbe4f8c39a821f390f785d606304d6dee3c@git.kernel.org>
Git-Commit-ID: 91365bbe4f8c39a821f390f785d606304d6dee3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91365bbe4f8c39a821f390f785d606304d6dee3c
Gitweb:     http://git.kernel.org/tip/91365bbe4f8c39a821f390f785d606304d6dee3c
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 3 Nov 2009 19:12:38 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:02:47 +0100

perf/probes: Rename perf probe events group name

Rename the group name of perf probe events to 'probe'.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091104001238.3454.70508.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index d111a93..d78a3d9 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -52,7 +52,7 @@ const char *default_search_path[NR_SEARCH_PATH] = {
 #define MAX_PATH_LEN 256
 #define MAX_PROBES 128
 #define MAX_PROBE_ARGS 128
-#define PERFPROBE_GROUP "perfprobe"
+#define PERFPROBE_GROUP "probe"
 
 /* Session management structure */
 static struct {
