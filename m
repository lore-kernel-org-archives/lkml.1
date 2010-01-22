Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067Ab0AVNpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0AVNpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953Ab0AVNpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:45:36 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62912 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0AVNpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:45:35 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf trace: Add -i option for choosing input file
Date: Fri, 22 Jan 2010 22:45:29 +0900
Message-Id: <1264167929-6741-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf trace lacks -i option for choosing input file.
This patch adds it to perf trace.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.5.2

