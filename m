Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0BVWvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:51:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab0BVWuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:50:19 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v2 1/9] perf probe: Do not show --line option without
	dwarf support
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Date: Mon, 22 Feb 2010 17:53:27 -0500
Message-ID: <20100222225327.20686.78717.stgit@localhost6.localdomain6>
In-Reply-To: <20100222225320.20686.17645.stgit@localhost6.localdomain6>
References: <20100222225320.20686.17645.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not show --line option in help message when perf
doesn't support dwarf.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
---

 tools/perf/builtin-probe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index ad47bd4..c7e14d0 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -156,7 +156,9 @@ static const char * const probe_usage[] = {
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 	"perf probe --list",
+#ifndef NO_LIBDWARF
 	"perf probe --line 'LINEDESC'",
+#endif
 	NULL
 };
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
