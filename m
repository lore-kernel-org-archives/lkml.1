Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZKPScy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZKPScy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZKPScs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:32:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbZKPScr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:32:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/5] perf tools: debug.h needs to include event.h for event_t
Date: Mon, 16 Nov 2009 16:32:42 -0200
Message-Id: <1258396365-29217-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258396365-29217-1-git-send-email-acme@infradead.org>
References: <1258396365-29217-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
 
-- 
1.6.2.5

