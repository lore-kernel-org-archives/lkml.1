Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160Ab0ATHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0ATHOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132Ab0ATHOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:14:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:40219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab0ATHO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:14:27 -0500
Date: Wed, 20 Jan 2010 07:12:54 GMT
From: tip-bot for Motohiro KOSAKI <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
In-Reply-To: <20100119023512.31880.35535.stgit@localhost6.localdomain6>
References: <20100119023512.31880.35535.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobetrace, doc: Add the explanation to remove probe points
Message-ID: <tip-df3ab708b787a2b35de5101452bd51d4a8ae0ded@git.kernel.org>
Git-Commit-ID: df3ab708b787a2b35de5101452bd51d4a8ae0ded
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 07:12:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df3ab708b787a2b35de5101452bd51d4a8ae0ded
Gitweb:     http://git.kernel.org/tip/df3ab708b787a2b35de5101452bd51d4a8ae0ded
Author:     Motohiro KOSAKI <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Mon, 18 Jan 2010 21:35:12 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Jan 2010 07:18:15 +0100

kprobetrace, doc: Add the explanation to remove probe points

Latest kprobetrace can remove probe points selectively, thus
the documentation should be updated too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100119023512.31880.35535.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
