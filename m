Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515Ab0AHMty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0AHMty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450Ab0AHMtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:49:49 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:37365 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0AHMtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:49:45 -0500
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] perf top: align help text on keys
Date: Fri,  8 Jan 2010 15:23:05 +0300
Message-Id: <e22b2e160c4053c993331ba075ae7f69482a8c07.1262952612.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.6.6.79.gd514e.dirty
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mapped keys:
        [d]     display refresh delay.                  (2)
        [e]     display entries (lines).                (46)
        [f]     profile display filter (count).         (5)
        [F]     annotate display filter (percent).      (5%)
        [s]     annotate symbol.                        (NULL)
        [S]     stop annotation.
        [K]     hide kernel_symbols symbols.            (no)
        [U]     hide user symbols.                      (no)
        [z]     toggle sample zeroing.                  (0)
        [qQ]    quit.

instead of

Mapped keys:
        [d]     display refresh delay.                  (2)
        [e]     display entries (lines).                (46)
        [f]     profile display filter (count).         (5)
        [F]     annotate display filter (percent).      (5%)
        [s]     annotate symbol.                        (NULL)
        [S]     stop annotation.
        [K]     hide kernel_symbols symbols.                    (no)
        [U]     hide user symbols.                      (no)
        [z]     toggle sample zeroing.                  (0)
        [qQ]    quit.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
---
 tools/perf/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9c7de93..9dc8070 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -704,7 +704,7 @@ static void print_mapped_keys(void)
 		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
 
 	fprintf(stdout,
-		"\t[K]     hide kernel_symbols symbols.             \t(%s)\n",
+		"\t[K]     hide kernel_symbols symbols.     \t(%s)\n",
 		hide_kernel_symbols ? "yes" : "no");
 	fprintf(stdout,
 		"\t[U]     hide user symbols.               \t(%s)\n",
-- 
1.6.6.79.gd514e.dirty
