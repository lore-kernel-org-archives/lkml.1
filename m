Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZHPJTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZHPJTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZHPJTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:19:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:56864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbZHPJTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:19:32 -0400
Date: Sun, 16 Aug 2009 09:18:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf: Build with stack-protector and with -D_FORTIFY_SOURCE=2
Message-ID: <tip-35ba15b737e2cd1d780943189f2138519f81fd42@git.kernel.org>
Git-Commit-ID: 35ba15b737e2cd1d780943189f2138519f81fd42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 09:18:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35ba15b737e2cd1d780943189f2138519f81fd42
Gitweb:     http://git.kernel.org/tip/35ba15b737e2cd1d780943189f2138519f81fd42
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 16 Aug 2009 11:09:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 16 Aug 2009 11:09:21 +0200

perf: Build with stack-protector and with -D_FORTIFY_SOURCE=2

Up our defences a bit.

Suggested-by: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8608c06..d637aea 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -171,7 +171,7 @@ endif
 #
 EXTRA_WARNINGS = -Wcast-align -Wformat=2 -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 $(EXTRA_WARNINGS)
+CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
