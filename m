Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbZLMNJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbZLMNJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZLMNI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:08:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53483 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753152AbZLMNIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DaGu2BKme4rQii7wk0OWQnH52h84UI7B6+EVrC85slAmBrAEAuAHA6qcFVFSOMPRns
         aMvSi4UO7bFmPuJrv1OwZZ7jRPNw45prGKVkmw3D5Id67Dm5Uwe1nRkGWb+vLdwJvszF
         MILvnJeSYS6liJBTz6jCp8ul04dFT0nxD3ZHs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 12/13] tracing/power: Remove two exports
Date: Sun, 13 Dec 2009 14:08:13 +0100
Message-Id: <1260709694-5166-13-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

trace_power_start and trace_power_end are used in
arch/x86/kernel/power.c, and this file can't be compiled
as a module, so these two tracepoints don't need to be
exported.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC55F.7060305@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/power-traces.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index e06c6e3..9f4f565 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -14,7 +14,5 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_end);
 EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
 
-- 
1.6.2.3

