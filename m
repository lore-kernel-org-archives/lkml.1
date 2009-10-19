Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbZJSQ4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbZJSQ4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 12:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZJSQ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 12:56:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbZJSQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 12:56:14 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf tools: Shut up compiler warning
Date: Mon, 19 Oct 2009 14:56:09 -0200
Message-Id: <1255971369-11368-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc1: warnings being treated as errors
util/trace-event-parse.c: In function ‘parse_ftrace_printk’:
util/trace-event-parse.c:289: warning: ‘fmt’ may be used uninitialized in this function

Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 4b61b49..0b8a01b 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -286,7 +286,7 @@ void parse_ftrace_printk(char *file, unsigned int size __unused)
 	char *line;
 	char *next = NULL;
 	char *addr_str;
-	char *fmt;
+	char *fmt = NULL;
 	int i;
 
 	line = strtok_r(file, "\n", &next);
-- 
1.5.5.1

