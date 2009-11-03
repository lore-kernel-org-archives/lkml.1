Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZKCN3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZKCN3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZKCN3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:29:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:33180 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZKCN3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:29:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 1/1] perf probe: Annotate variable initialization
Date: Tue,  3 Nov 2009 11:29:07 -0200
Message-Id: <1257254947-16789-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

    cc1: warnings being treated as errors
    builtin-probe.c: In function ‘parse_probe_event’:
    builtin-probe.c:72: warning: ‘nc’ is used uninitialized in this function

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a99a366..8124523 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -69,7 +69,7 @@ static struct {
 static void parse_probe_point(char *arg, struct probe_point *pp)
 {
 	char *ptr, *tmp;
-	char c, nc;
+	char c, nc = 0;
 	/*
 	 * <Syntax>
 	 * perf probe SRC:LN
-- 
1.5.5.1

