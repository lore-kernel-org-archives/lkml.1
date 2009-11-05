Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZKEAch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZKEAch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZKEAce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:32:34 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50482 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZKEAbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:31:40 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v5 5/7] Modifying builtin.h for new prototype
Date: Thu,  5 Nov 2009 09:31:35 +0900
Message-Id: <1257381097-4743-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257381097-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies builtin.h to add prototype of cmd_bench().

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index ad5f0f4..e84f63e 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -26,5 +26,6 @@ extern int cmd_top(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
 extern int cmd_probe(int argc, const char **argv, const char *prefix);
+extern int cmd_bench(int argc, const char **argv, const char *prefix);
 
 #endif
-- 
1.6.5.2

