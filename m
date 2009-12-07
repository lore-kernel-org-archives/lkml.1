Return-Path: <linux-kernel-owner+w=401wt.eu-S964855AbZLGRXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbZLGRXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935430AbZLGRXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:23:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935423AbZLGRXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:23:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH -tip 5/5] perf probe: Use pr_debug for debug message
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 07 Dec 2009 12:00:59 -0500
Message-ID: <20091207170059.19230.51459.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_debug() for "missing vmlinux" debugging message.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
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
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
