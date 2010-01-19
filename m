Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213Ab0ASCei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0ASCei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 21:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771Ab0ASCeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 21:34:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab0ASCeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 21:34:36 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/2] kprobetrace,
	doc: Add the explanation to remove probe points
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Date: Mon, 18 Jan 2010 21:35:12 -0500
Message-ID: <20100119023512.31880.35535.stgit@localhost6.localdomain6>
In-Reply-To: <20100117071411.GD19512@elte.hu>
References: <20100117071411.GD19512@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Motohiro KOSAKI <kosaki.motohiro@jp.fujitsu.com>

Latest kprobetrace can remove probe points selectively. thus
documentation should be updated too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 Documentation/trace/kprobetrace.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index ab57f02..a9100b2 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -24,6 +24,7 @@ Synopsis of kprobe_events
 -------------------------
   p[:[GRP/]EVENT] SYMBOL[+offs]|MEMADDR [FETCHARGS]	: Set a probe
   r[:[GRP/]EVENT] SYMBOL[+0] [FETCHARGS]		: Set a return probe
+  -:[GRP/]EVENT						: Clear a probe
 
  GRP		: Group name. If omitted, use "kprobes" for it.
  EVENT		: Event name. If omitted, the event name is generated
@@ -122,6 +123,12 @@ REC->dfd, REC->filename, REC->flags, REC->mode
 
  This clears all probe points.
 
+ Or,
+
+  echo -:myprobe >> kprobe_events
+
+ This clears probe points selectively.
+
  Right after definition, each event is disabled by default. For tracing these
 events, you need to enable it.
 

