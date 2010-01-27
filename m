Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629Ab0A0NT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0A0NT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481Ab0A0NTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:19:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:60660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab0A0NTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:19:23 -0500
Date: Wed, 27 Jan 2010 13:18:49 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264167929-6741-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264167929-6741-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add -i option for choosing input file
Message-ID: <tip-408f0d18ba6b9bb447f807f621b2c9663c5cf638@git.kernel.org>
Git-Commit-ID: 408f0d18ba6b9bb447f807f621b2c9663c5cf638
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:18:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  408f0d18ba6b9bb447f807f621b2c9663c5cf638
Gitweb:     http://git.kernel.org/tip/408f0d18ba6b9bb447f807f621b2c9663c5cf638
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Fri, 22 Jan 2010 22:45:29 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Jan 2010 13:01:34 +0100

perf trace: Add -i option for choosing input file

perf trace lacks -i option for choosing input file.
This patch adds it to perf trace.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1264167929-6741-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8e9cbfe..0b65779 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -515,6 +515,8 @@ static const struct option options[] = {
 		     parse_scriptname),
 	OPT_STRING('g', "gen-script", &generate_script_lang, "lang",
 		   "generate perf-trace.xx script in specified language"),
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
 
 	OPT_END()
 };
