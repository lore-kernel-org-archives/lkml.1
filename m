Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbZLPO1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbZLPO1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbZLPO10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:27:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:59265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbZLPO1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:27:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf report: Fix cut'n'paste error recently introduced
Date: Wed, 16 Dec 2009 12:27:11 -0200
Message-Id: <1260973631-28035-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260973631-28035-1-git-send-email-acme@infradead.org>
References: <1260973631-28035-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Introduced in:

d599db3fc5dd4f1e8432fdbc6d899584b25f4dff
"perf report: Generalize perf_session__fprintf_hists()"

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c4f3a08..cf1d370 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -186,7 +186,7 @@ static int sample_type_check(struct perf_session *session)
 static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_mmap_event	= event__process_mmap,
-	.process_comm_event	= event__process_mmap,
+	.process_comm_event	= event__process_comm,
 	.process_exit_event	= event__process_task,
 	.process_fork_event	= event__process_task,
 	.process_lost_event	= event__process_lost,
-- 
1.6.2.5

