Return-Path: <linux-kernel-owner+w=401wt.eu-S935566AbZLGRiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566AbZLGRiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935541AbZLGRiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:38:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:41698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935538AbZLGRis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:38:48 -0500
Date: Mon, 7 Dec 2009 17:37:31 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20091207170059.19230.51459.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170059.19230.51459.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Use pr_debug for debug message
Message-ID: <tip-d3a2dbf844d81b4b9c9ad6044563c294e7a48cac@git.kernel.org>
Git-Commit-ID: d3a2dbf844d81b4b9c9ad6044563c294e7a48cac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3a2dbf844d81b4b9c9ad6044563c294e7a48cac
Gitweb:     http://git.kernel.org/tip/d3a2dbf844d81b4b9c9ad6044563c294e7a48cac
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 7 Dec 2009 12:00:59 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 18:33:22 +0100

perf probe: Use pr_debug for debug message

Use pr_debug() for "missing vmlinux" debugging message.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091207170059.19230.51459.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a58e11b..8993a1f 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -194,8 +194,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		if (session.need_dwarf)
 			die("Could not open vmlinux/module file.");
 
-		pr_warning("Could not open vmlinux/module file."
-			   " Try to use symbols.\n");
+		pr_debug("Could not open vmlinux/module file."
+			 " Try to use symbols.\n");
 		goto end_dwarf;
 	}
 
