Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082Ab0AMQpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0AMQpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062Ab0AMQpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:45:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:34935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab0AMQpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:45:03 -0500
Date: Wed, 13 Jan 2010 16:43:03 GMT
From: tip-bot for Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, kirr@landau.phys.spbu.ru, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1263396139-4798-3-git-send-email-acme@infradead.org>
References: <1263396139-4798-3-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Fix code typo in prompt_symbol()
Message-ID: <tip-66aeb6d5cb701aedd508187e08612bfd1e108e2e@git.kernel.org>
Git-Commit-ID: 66aeb6d5cb701aedd508187e08612bfd1e108e2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 16:43:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66aeb6d5cb701aedd508187e08612bfd1e108e2e
Gitweb:     http://git.kernel.org/tip/66aeb6d5cb701aedd508187e08612bfd1e108e2e
Author:     Kirill Smelkov <kirr@landau.phys.spbu.ru>
AuthorDate: Wed, 13 Jan 2010 13:22:19 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 17:39:44 +0100

perf top: Fix code typo in prompt_symbol()

sym_filter is what was (if ever) passed with -s option. What was
typed by user, and what we were looking for, is in buf.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1263396139-4798-3-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
