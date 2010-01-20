Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238Ab0ATHOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0ATHOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143Ab0ATHOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:14:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:40220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab0ATHO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:14:28 -0500
Date: Wed, 20 Jan 2010 07:12:38 GMT
From: tip-bot for Motohiro KOSAKI <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
In-Reply-To: <20100119023505.31880.17367.stgit@localhost6.localdomain6>
References: <20100119023505.31880.17367.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobetrace, doc: Shell needs single quote to use $ character
Message-ID: <tip-580d9e00fdfb85e65c5097dcd739c6efcdbadc96@git.kernel.org>
Git-Commit-ID: 580d9e00fdfb85e65c5097dcd739c6efcdbadc96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 07:12:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  580d9e00fdfb85e65c5097dcd739c6efcdbadc96
Gitweb:     http://git.kernel.org/tip/580d9e00fdfb85e65c5097dcd739c6efcdbadc96
Author:     Motohiro KOSAKI <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Mon, 18 Jan 2010 21:35:05 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Jan 2010 07:18:14 +0100

kprobetrace, doc: Shell needs single quote to use $ character

Shell interprets $val as shell variable, thus we need quote if
we use the echo command.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100119023505.31880.17367.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
