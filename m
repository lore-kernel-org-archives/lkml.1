Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0CDQcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:32:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:48448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab0CDQcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:32:07 -0500
Date: Thu, 4 Mar 2010 16:31:14 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100304033843.3819.10087.stgit@localhost6.localdomain6>
References: <20100304033843.3819.10087.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf probe: Correct probe syntax on command line help
Message-ID: <tip-32cb0dd50672056e510ccab442dc9c3a03be649e@git.kernel.org>
Git-Commit-ID: 32cb0dd50672056e510ccab442dc9c3a03be649e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:31:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32cb0dd50672056e510ccab442dc9c3a03be649e
Gitweb:     http://git.kernel.org/tip/32cb0dd50672056e510ccab442dc9c3a03be649e
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 3 Mar 2010 22:38:43 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 11:39:21 +0100

perf probe: Correct probe syntax on command line help

Move @SRC right after FUNC in syntax according to syntax change
on command line help.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <20100304033843.3819.10087.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
