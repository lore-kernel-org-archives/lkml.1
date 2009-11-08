Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZKHJ0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZKHJ0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZKHJ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:26:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:60119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbZKHJ0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:26:40 -0500
Date: Sun, 8 Nov 2009 09:25:55 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, jkosina@suse.cz,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257381097-4743-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Modify builtin.h for new prototype
Message-ID: <tip-11bd341c043348ecb7462d3bd8e1ad6d00f6892a@git.kernel.org>
Git-Commit-ID: 11bd341c043348ecb7462d3bd8e1ad6d00f6892a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11bd341c043348ecb7462d3bd8e1ad6d00f6892a
Gitweb:     http://git.kernel.org/tip/11bd341c043348ecb7462d3bd8e1ad6d00f6892a
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 5 Nov 2009 09:31:35 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:19:19 +0100

perf bench: Modify builtin.h for new prototype

This patch modifies builtin.h to add prototype of cmd_bench().

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <1257381097-4743-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index e11d8d2..f0cd5b1 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -15,6 +15,7 @@ extern int read_line_with_nul(char *buf, int size, FILE *file);
 extern int check_pager_config(const char *cmd);
 
 extern int cmd_annotate(int argc, const char **argv, const char *prefix);
+extern int cmd_bench(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
 extern int cmd_sched(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
