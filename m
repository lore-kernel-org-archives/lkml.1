Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbZEFMUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbZEFMUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759160AbZEFMUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:20:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:35998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbZEFMUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:20:04 -0400
Date: Wed, 6 May 2009 12:19:21 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A00F6C0.8090803@cn.fujitsu.com>
References: <4A00F6C0.8090803@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: make SAMPLE_TRACE_EVENTS default to n
Message-ID: <tip-96d17980fabeb757706d2d6db5a28580a6156bfc@git.kernel.org>
Git-Commit-ID: 96d17980fabeb757706d2d6db5a28580a6156bfc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:19:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96d17980fabeb757706d2d6db5a28580a6156bfc
Gitweb:     http://git.kernel.org/tip/96d17980fabeb757706d2d6db5a28580a6156bfc
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 6 May 2009 10:32:32 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 10:38:18 +0200

tracing/events: make SAMPLE_TRACE_EVENTS default to n

Normally a config should be default to n. This patch also makes the
sample module-only, like SAMPLE_MARKERS and SAMPLE_TRACEPOINTS.

[ Impact: don't build trace event sample by default ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A00F6C0.8090803@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 samples/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 93f41c0..b75d28c 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -20,9 +20,8 @@ config SAMPLE_TRACEPOINTS
 	  This build tracepoints example modules.
 
 config SAMPLE_TRACE_EVENTS
-	tristate "Build trace_events examples"
-	depends on EVENT_TRACING
-	default m
+	tristate "Build trace_events examples -- loadable modules only"
+	depends on EVENT_TRACING && m
 	help
 	  This build trace event example modules.
 
