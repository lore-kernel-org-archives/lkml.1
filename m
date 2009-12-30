Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZL3MYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZL3MYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZL3MYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:24:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:42524 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZL3MXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:23:44 -0500
Date: Wed, 30 Dec 2009 12:23:07 GMT
From: tip-bot for Liming Wang <liming.wang@windriver.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, liming.wang@windriver.com, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, liming.wang@windriver.com, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <1262075829-16257-3-git-send-email-liming.wang@windriver.com>
References: <1262075829-16257-3-git-send-email-liming.wang@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Change CONFIG_KPROBE_TRACER to CONFIG_KPROBE_EVENT
Message-ID: <tip-63bbd5e2d539c9290b229c832f62d42aac23db94@git.kernel.org>
Git-Commit-ID: 63bbd5e2d539c9290b229c832f62d42aac23db94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63bbd5e2d539c9290b229c832f62d42aac23db94
Gitweb:     http://git.kernel.org/tip/63bbd5e2d539c9290b229c832f62d42aac23db94
Author:     Liming Wang <liming.wang@windriver.com>
AuthorDate: Tue, 29 Dec 2009 16:37:09 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 11:59:34 +0100

perf probe: Change CONFIG_KPROBE_TRACER to CONFIG_KPROBE_EVENT

make the config name consistent

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1262075829-16257-3-git-send-email-liming.wang@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
