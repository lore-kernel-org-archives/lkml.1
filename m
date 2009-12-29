Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbZL2JEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbZL2JEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZL2JEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:04:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:57428 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZL2JEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:04:48 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 3/3] perf probe: change CONFIG_KPROBE_TRACER to CONFIG_KPROBE_EVENT
Date: Tue, 29 Dec 2009 16:37:09 +0800
Message-Id: <1262075829-16257-3-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1262075829-16257-2-git-send-email-liming.wang@windriver.com>
References: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
 <1262075829-16257-2-git-send-email-liming.wang@windriver.com>
X-OriginalArrivalTime: 29 Dec 2009 09:03:45.0746 (UTC) FILETIME=[D3A68320:01CA8865]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make the config name consistent

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29465d4..8e532d9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -368,7 +368,7 @@ static int open_kprobe_events(int flags, int mode)
 	if (ret < 0) {
 		if (errno == ENOENT)
 			die("kprobe_events file does not exist -"
-			    " please rebuild with CONFIG_KPROBE_TRACER.");
+			    " please rebuild with CONFIG_KPROBE_EVENT.");
 		else
 			die("Could not open kprobe_events file: %s",
 			    strerror(errno));
-- 
1.6.0.3

