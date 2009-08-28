Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZH1UiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZH1UiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZH1UiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:38:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44563 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZH1UiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:38:14 -0400
Message-Id: <20090828203815.487378389@goodmis.org>
References: <20090828203736.440768383@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 28 Aug 2009 16:37:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] tracing: remove legacy select of MARKERS by context switch tracing
Content-Disposition: inline; filename=0001-tracing-remove-legacy-select-of-MARKERS-by-context-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The context switch tracer was made before tracepoints were mature, and
the original version used markers. This is no longer true and this
patch removes the select.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 06be85a..163fbfc 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -60,7 +60,6 @@ config EVENT_TRACING
 	bool
 
 config CONTEXT_SWITCH_TRACER
-	select MARKERS
 	bool
 
 # All tracer options should select GENERIC_TRACER. For those options that are
-- 
1.6.3.3

-- 
