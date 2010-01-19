Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735Ab0ASCet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab0ASCet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 21:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456Ab0ASCer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 21:34:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0ASCep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 21:34:45 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/2] kprobetrace,
	doc: shell need single quote to use $ character
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Date: Mon, 18 Jan 2010 21:35:05 -0500
Message-ID: <20100119023505.31880.17367.stgit@localhost6.localdomain6>
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

shell interpret $val is as shell variable. thus we need quote if
we use echo command.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 Documentation/trace/kprobetrace.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index f30978e..ab57f02 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -79,7 +79,7 @@ Usage examples
 To add a probe as a new event, write a new definition to kprobe_events
 as below.
 
-  echo p:myprobe do_sys_open dfd=%ax filename=%dx flags=%cx mode=+4($stack) > /sys/kernel/debug/tracing/kprobe_events
+  echo 'p:myprobe do_sys_open dfd=%ax filename=%dx flags=%cx mode=+4($stack)' > /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kprobe on the top of do_sys_open() function with recording
 1st to 4th arguments as "myprobe" event. Note, which register/stack entry is
@@ -88,7 +88,7 @@ the ABI, please try to use probe subcommand of perf-tools (you can find it
 under tools/perf/).
 As this example shows, users can choose more familiar names for each arguments.
 
-  echo r:myretprobe do_sys_open $retval >> /sys/kernel/debug/tracing/kprobe_events
+  echo 'r:myretprobe do_sys_open $retval' >> /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kretprobe on the return point of do_sys_open() function with
 recording return value as "myretprobe" event.

