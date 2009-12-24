Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZLXCJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZLXCJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 21:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZLXCJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 21:09:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56944 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbZLXCJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 21:09:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] doc: kprobetrace: Add the explanation to remove probe points
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20091224103912.68AC.A69D9226@jp.fujitsu.com>
References: <20091224103912.68AC.A69D9226@jp.fujitsu.com>
Message-Id: <20091224110840.68B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 24 Dec 2009 11:09:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest kprobetrace can remove probe points selectively. thus
documentation should be updated too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 Documentation/trace/kprobetrace.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 2be6e19..8c88930 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -24,6 +24,7 @@ Synopsis of kprobe_events
 -------------------------
   p[:[GRP/]EVENT] SYMBOL[+offs]|MEMADDR [FETCHARGS]	: Set a probe
   r[:[GRP/]EVENT] SYMBOL[+0] [FETCHARGS]		: Set a return probe
+  -:[GRP/]EVENT						: Clear a probe
 
  GRP		: Group name. If omitted, use "kprobes" for it.
  EVENT		: Event name. If omitted, the event name is generated
@@ -121,6 +122,12 @@ print fmt: "(%lx) dfd=%lx filename=%lx flags=%lx mode=%lx", REC->ip, REC->dfd, R
 
  This clears all probe points.
 
+ Or, 
+
+  echo -:myprobe >> kprobe_events
+
+ This clears probe points selectively.
+
  Right after definition, each event is disabled by default. For tracing these
 events, you need to enable it.
 
-- 
1.6.5.2



