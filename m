Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZK3IX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZK3IX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZK3IXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:23:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:37851 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZK3IXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:23:53 -0500
Date: Mon, 30 Nov 2009 08:23:30 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/scripting] perf scripting: Fix build
Message-ID: <tip-cf72344d1ad7b33805ef8d65e758b267e6f4cb8d@git.kernel.org>
Git-Commit-ID: cf72344d1ad7b33805ef8d65e758b267e6f4cb8d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf72344d1ad7b33805ef8d65e758b267e6f4cb8d
Gitweb:     http://git.kernel.org/tip/cf72344d1ad7b33805ef8d65e758b267e6f4cb8d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 28 Nov 2009 10:11:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Nov 2009 10:11:00 +0100

perf scripting: Fix build

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ca8ebf1..abb914a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -5,6 +5,8 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/header.h"
+#include "util/exec_cmd.h"
+#include "util/trace-event.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
