Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbZJFGBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbZJFGBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZJFGBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:01:34 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:53648 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbZJFGBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yFnr+MsIcx82JF8d/Tj5rDNmztrFHwMW0AcAO/WwfbGuaI7DVCtAV6lzf+C4GvGrT7
         5newiuC8Ezm15tn4ZkEYzfbEI4ExtIRWSai/n1MHpLEYeitAATGMO+JSrNoRxefnCkVq
         VBWqpfALsM5YMMB2WgJ42o6QslWDZt/bz8lbs=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
Subject: [PATCH 1/3] perf trace: Remove unused code in builtin-trace.c
Date: Tue,  6 Oct 2009 01:00:47 -0500
Message-Id: <1254808849-7829-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And some minor whitespace cleanup.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2f93888..5d4c84d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -191,10 +191,6 @@ remap:
 more:
 	event = (event_t *)(buf + head);
 
-	size = event->header.size;
-	if (!size)
-		size = 8;
-
 	if (head + event->header.size >= page_size * mmap_window) {
 		unsigned long shift = page_size * (head / page_size);
 		int res;
@@ -209,7 +205,6 @@ more:
 
 	size = event->header.size;
 
-
 	if (!size || process_event(event, offset, head) < 0) {
 
 		/*
@@ -262,7 +257,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(annotate_usage, options);
 	}
 
-
 	setup_pager();
 
 	return __cmd_trace();
-- 
1.6.4.GIT

