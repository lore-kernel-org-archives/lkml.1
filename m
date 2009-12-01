Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZLAHdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZLAHdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZLAHdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:33:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:37361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbZLAHdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:33:40 -0500
Date: Tue, 1 Dec 2009 07:31:35 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091201001927.10235.63645.stgit@harusame>
References: <20091201001927.10235.63645.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Change a debugging message from pr_info to pr_debug
Message-ID: <tip-f41b1e43c41e99c39a2222578a7806032c045c79@git.kernel.org>
Git-Commit-ID: f41b1e43c41e99c39a2222578a7806032c045c79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f41b1e43c41e99c39a2222578a7806032c045c79
Gitweb:     http://git.kernel.org/tip/f41b1e43c41e99c39a2222578a7806032c045c79
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 30 Nov 2009 19:19:27 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 08:20:00 +0100

perf probe: Change a debugging message from pr_info to pr_debug

Change annoying debug-info using notice from pr_info() to
pr_debug(), since the message always printed when user adds a
probe point which requires debug-info.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091201001927.10235.63645.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a2f6daf..4e418af 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -351,7 +351,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 #ifdef NO_LIBDWARF
 		semantic_error("Debuginfo-analysis is not supported");
 #else	/* !NO_LIBDWARF */
-		pr_info("Some probes require debuginfo.\n");
+		pr_debug("Some probes require debuginfo.\n");
 
 	if (session.vmlinux)
 		fd = open(session.vmlinux, O_RDONLY);
