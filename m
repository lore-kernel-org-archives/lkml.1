Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbZKEAbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbZKEAbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932479AbZKEAbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:31:45 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50498 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbZKEAbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:31:43 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v5 6/7] Modyfing perf.c for subcommand 'bench'
Date: Thu,  5 Nov 2009 09:31:36 +0900
Message-Id: <1257381097-4743-7-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257381097-4743-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies perf.c for invoking 'bench' subcommand.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/perf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 9cafe54..5877b01 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -296,6 +296,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "trace", cmd_trace, 0 },
 		{ "sched", cmd_sched, 0 },
 		{ "probe", cmd_probe, 0 },
+		{ "bench", cmd_bench, 0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
-- 
1.6.5.2

