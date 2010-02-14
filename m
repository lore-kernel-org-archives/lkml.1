Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0BNJPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:15:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:33687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab0BNJPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:15:37 -0500
Date: Sun, 14 Feb 2010 09:13:53 GMT
From: tip-bot for Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       kirr@landau.phys.spbu.ru, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       kirr@landau.phys.spbu.ru, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100212162059.GA30041@landau.phys.spbu.ru>
References: <20100212162059.GA30041@landau.phys.spbu.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Fix help text alignment
Message-ID: <tip-1a72cfa6856e7d58e049c42c6e6a789669478479@git.kernel.org>
Git-Commit-ID: 1a72cfa6856e7d58e049c42c6e6a789669478479
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Feb 2010 09:13:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a72cfa6856e7d58e049c42c6e6a789669478479
Gitweb:     http://git.kernel.org/tip/1a72cfa6856e7d58e049c42c6e6a789669478479
Author:     Kirill Smelkov <kirr@landau.phys.spbu.ru>
AuthorDate: Fri, 12 Feb 2010 19:20:59 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Feb 2010 09:46:02 +0100

perf top: Fix help text alignment

Print this:

Mapped keys:
        [d]     display refresh delay.                  (2)
        [e]     display entries (lines).                (46)
        [f]     profile display filter (count).         (5)
        [F]     annotate display filter (percent).      (5%)
        [s]     annotate symbol.                        (NULL)
        [S]     stop annotation.
        [K]     hide kernel_symbols symbols.            (no)
        [U]     hide user symbols.                      (no)
        [z]     toggle sample zeroing.                  (0)
        [qQ]    quit.

instead of:

Mapped keys:
        [d]     display refresh delay.                  (2)
        [e]     display entries (lines).                (46)
        [f]     profile display filter (count).         (5)
        [F]     annotate display filter (percent).      (5%)
        [s]     annotate symbol.                        (NULL)
        [S]     stop annotation.
        [K]     hide kernel_symbols symbols.                    (no)
        [U]     hide user symbols.                      (no)
        [z]     toggle sample zeroing.                  (0)
        [qQ]    quit.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100212162059.GA30041@landau.phys.spbu.ru>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ddc584b..4b91d8c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -705,7 +705,7 @@ static void print_mapped_keys(void)
 		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
 
 	fprintf(stdout,
-		"\t[K]     hide kernel_symbols symbols.             \t(%s)\n",
+		"\t[K]     hide kernel_symbols symbols.     \t(%s)\n",
 		hide_kernel_symbols ? "yes" : "no");
 	fprintf(stdout,
 		"\t[U]     hide user symbols.               \t(%s)\n",
