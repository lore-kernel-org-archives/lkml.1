Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbZLJHwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbZLJHwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbZLJHwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:52:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:40016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760617AbZLJHwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:52:15 -0500
Date: Thu, 10 Dec 2009 07:51:56 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B20A195.8030106@cn.fujitsu.com>
References: <4B20A195.8030106@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kmem: Fix unused argument build warning
Message-ID: <tip-7931241694b25589658b1ceb02218d2750540ae0@git.kernel.org>
Git-Commit-ID: 7931241694b25589658b1ceb02218d2750540ae0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7931241694b25589658b1ceb02218d2750540ae0
Gitweb:     http://git.kernel.org/tip/7931241694b25589658b1ceb02218d2750540ae0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 10 Dec 2009 08:43:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:44:39 +0100

perf kmem: Fix unused argument build warning

Fix:

 builtin-kmem.c: In function 'parse_caller_opt':
 builtin-kmem.c:690: error: unused parameter 'arg'
 builtin-kmem.c: In function 'parse_alloc_opt':
 builtin-kmem.c:697: error: unused parameter 'arg'

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <4B20A195.8030106@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-kmem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 1b04787..5f20951 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -687,14 +687,14 @@ static int parse_sort_opt(const struct option *opt __used,
 }
 
 static int parse_caller_opt(const struct option *opt __used,
-			  const char *arg, int unset __used)
+			  const char *arg __used, int unset __used)
 {
 	caller_flag = (alloc_flag + 1);
 	return 0;
 }
 
 static int parse_alloc_opt(const struct option *opt __used,
-			  const char *arg, int unset __used)
+			  const char *arg __used, int unset __used)
 {
 	alloc_flag = (caller_flag + 1);
 	return 0;
