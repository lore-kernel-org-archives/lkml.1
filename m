Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZKPVMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZKPVMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZKPVMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:12:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:39068 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbZKPVMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:12:34 -0500
Date: Mon, 16 Nov 2009 21:10:00 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258396365-29217-2-git-send-email-acme@infradead.org>
References: <1258396365-29217-2-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Debug.h needs to include event.h for event_t
Message-ID: <tip-8f41146aedf803856fb6477056e3960cb9ba8f9c@git.kernel.org>
Git-Commit-ID: 8f41146aedf803856fb6477056e3960cb9ba8f9c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f41146aedf803856fb6477056e3960cb9ba8f9c
Gitweb:     http://git.kernel.org/tip/8f41146aedf803856fb6477056e3960cb9ba8f9c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Nov 2009 16:32:42 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 22:05:50 +0100

perf tools: Debug.h needs to include event.h for event_t

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258396365-29217-2-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/debug.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index e8b18a1..c6c24c5 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -2,6 +2,8 @@
 #ifndef __PERF_DEBUG_H
 #define __PERF_DEBUG_H
 
+#include "event.h"
+
 extern int verbose;
 extern int dump_trace;
 
