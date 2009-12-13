Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZLMNIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZLMNIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZLMNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:08:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51043 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751243AbZLMNIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=K0jpMDCN5G+XES6+fCNn5XM9bV4Vn1waAcaTp3sMs+JBJGiqQ8YkllWDFyIeIY7iDk
         n8oleJShNCLavf/IQ3Y7AA9oZux6FswlY4M1h0RAwNcQJyEVo215Ps96o9oApNf22fKk
         aAqJn/jrwdEibtKLlaH5vhWHQW4hk4i4qUNb4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] tracing updates
Date: Sun, 13 Dec 2009 14:08:01 +0100
Message-Id: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks,
	Frederic
---

Li Zefan (13):
      tracing: Extract duplicate ftrace_raw_init_event_foo()
      tracing: Pull up calls to trace_define_common_fields()
      tracing: Move a printk out of ftrace_raw_reg_event_foo()
      ftrace: Return EINVAL when writing invalid val to set_ftrace_filter
      ftrace: Call trace_parser_clear() properly
      function-graph: Allow writing the same val to set_graph_function
      tracing: Use seq file for trace_options
      tracing: Use seq file for trace_clock
      tracing: Remove useless trace option
      tracing: Simplify trace_option_write()
      tracing: Change event->profile_count to be int type
      tracing/power: Remove two exports
      ksym_tracer: Fix compile warnings


 include/linux/ftrace_event.h       |    4 +-
 include/linux/syscalls.h           |    6 +-
 include/trace/ftrace.h             |   56 ++-----------
 kernel/trace/ftrace.c              |   30 ++++---
 kernel/trace/power-traces.c        |    2 -
 kernel/trace/trace.c               |  166 +++++++++++++-----------------------
 kernel/trace/trace.h               |   23 +++---
 kernel/trace/trace_event_profile.c |    6 +-
 kernel/trace/trace_events.c        |   41 +++++++--
 kernel/trace/trace_export.c        |    4 -
 kernel/trace/trace_kprobe.c        |    9 --
 kernel/trace/trace_ksym.c          |   13 ++--
 kernel/trace/trace_syscalls.c      |   18 +----
 13 files changed, 146 insertions(+), 232 deletions(-)
