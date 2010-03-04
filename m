Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0CDDct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:32:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0CDDce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:32:34 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v2 1/2] perf probe: Correct probe syntax on command line
	help
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Date: Wed, 03 Mar 2010 22:38:43 -0500
Message-ID: <20100304033843.3819.10087.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move @SRC right after FUNC in syntax according to syntax change
on command line help.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
---

 tools/perf/builtin-probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index e3dfd0d..c30a335 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -177,7 +177,7 @@ static const struct option options[] = {
 #ifdef NO_DWARF_SUPPORT
 		"[EVENT=]FUNC[+OFF|%return] [ARG ...]",
 #else
-		"[EVENT=]FUNC[+OFF|%return|:RL|;PT][@SRC]|SRC:AL|SRC;PT"
+		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
 		" [ARG ...]",
 #endif
 		"probe point definition, where\n"


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
