Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZKHJ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZKHJ0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZKHJ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:26:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:60128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbZKHJ0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:26:49 -0500
Date: Sun, 8 Nov 2009 09:26:13 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, jkosina@suse.cz,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257381097-4743-7-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-7-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add new subcommand 'bench' to perf.c
Message-ID: <tip-dcba8848d3bc83ec9ee0858b9ae6e4f1c1fa7fa3@git.kernel.org>
Git-Commit-ID: dcba8848d3bc83ec9ee0858b9ae6e4f1c1fa7fa3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dcba8848d3bc83ec9ee0858b9ae6e4f1c1fa7fa3
Gitweb:     http://git.kernel.org/tip/dcba8848d3bc83ec9ee0858b9ae6e4f1c1fa7fa3
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 5 Nov 2009 09:31:36 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:19:19 +0100

perf bench: Add new subcommand 'bench' to perf.c

This patch modifies perf.c for invoking 'bench' subcommand.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <1257381097-4743-7-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 624e62d..f90ca5e 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -288,6 +288,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "list", cmd_list, 0 },
 		{ "record", cmd_record, 0 },
 		{ "report", cmd_report, 0 },
+		{ "bench", cmd_bench, 0 },
 		{ "stat", cmd_stat, 0 },
 		{ "timechart", cmd_timechart, 0 },
 		{ "top", cmd_top, 0 },
