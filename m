Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839Ab0AMPWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0AMPWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655Ab0AMPWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:22:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab0AMPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:22:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf top: fix code typo in prompt_symbol()
Date: Wed, 13 Jan 2010 13:22:19 -0200
Message-Id: <1263396139-4798-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263396139-4798-1-git-send-email-acme@infradead.org>
References: <1263396139-4798-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Smelkov <kirr@landau.phys.spbu.ru>

sym_filter is what was (if ever) passed with -s option. What was typed by
user, and what we were looking for, is in buf.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6822b44..7a8a77e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -667,7 +667,7 @@ static void prompt_symbol(struct sym_entry **target, const char *msg)
 	}
 
 	if (!found) {
-		fprintf(stderr, "Sorry, %s is not active.\n", sym_filter);
+		fprintf(stderr, "Sorry, %s is not active.\n", buf);
 		sleep(1);
 		return;
 	} else
-- 
1.6.2.5

