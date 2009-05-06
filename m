Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbZEFCbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbZEFCbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZEFCbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:31:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65155 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756144AbZEFCbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:31:34 -0400
Message-ID: <4A00F6C0.8090803@cn.fujitsu.com>
Date: Wed, 06 May 2009 10:32:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing/events: make SAMPLE_TRACE_EVENTS default to n
References: <4A00F6AD.2070008@cn.fujitsu.com>
In-Reply-To: <4A00F6AD.2070008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally a config should be default to n. This patch also makes the
sample module-only, like SAMPLE_MARKERS and SAMPLE_TRACEPOINTS.

[ Impact: don't build trace event sample by default ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
 
-- 
1.5.4.rc3


