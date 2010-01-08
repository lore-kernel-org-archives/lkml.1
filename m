Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533Ab0AHMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0AHMuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453Ab0AHMtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:49:50 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:37367 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab0AHMtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:49:47 -0500
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] perf top: fix code typo in prompt_symbol()
Date: Fri,  8 Jan 2010 15:23:06 +0300
Message-Id: <b589503ffe4678bbaab941771c03e123a33c180a.1262952612.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.6.6.79.gd514e.dirty
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sym_filter is what was (if ever) passed with -s option. What was typed by
user, and what we were looking for, is in buf.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
---
 tools/perf/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9dc8070..4067e4d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -668,7 +668,7 @@ static void prompt_symbol(struct sym_entry **target, const char *msg)
 	}
 
 	if (!found) {
-		fprintf(stderr, "Sorry, %s is not active.\n", sym_filter);
+		fprintf(stderr, "Sorry, %s is not active.\n", buf);
 		sleep(1);
 		return;
 	} else
-- 
1.6.6.79.gd514e.dirty
