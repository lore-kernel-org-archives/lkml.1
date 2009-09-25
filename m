Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZIYSSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZIYSSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 14:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZIYSSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 14:18:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZIYSSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 14:18:35 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 0/3] tracing/kprobes: kprobe-tracer updates
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 25 Sep 2009 11:19:52 -0700
Message-ID: <20090925181952.10157.9975.stgit@omoto>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Here is a few updates for kprobe-tracer which fix reported bugs and
is for catching up the latest ftrace.

 - Use dynamic percpu profiling buffer patch is for catching up
   the latest ftrace change.
 - Checking the result of create_event_dir() patch improves ftrace
   code pointed by Li Zefan (thanks!).
 - Add VIA instructions to x86 insn decoder patch fixes decoding
   bug reported by Ingo Molnar (thanks!).

Soon after this series, I'll send perf-kprobe patch series.

Thank you,

---

Masami Hiramatsu (3):
      tracing/ftrace: Fix to check create_event_dir() when adding new events
      x86: Add VIA processor instructions
      tracing/kprobes: Use global event profile buffer in kprobe tracer


 arch/x86/lib/x86-opcode-map.txt |    8 ++-
 kernel/trace/trace_events.c     |   29 +++++++---
 kernel/trace/trace_kprobe.c     |  115 +++++++++++++++++++++++++--------------
 3 files changed, 101 insertions(+), 51 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
