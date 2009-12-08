Return-Path: <linux-kernel-owner+w=401wt.eu-S934706AbZLHDOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706AbZLHDOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934419AbZLHDOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:14:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58241 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934184AbZLHDOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:14:18 -0500
Message-ID: <4B1DC476.3030700@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 11:13:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/13] tracing: various cleanups and small fixes (updated)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates:

- took a further step to save more spaces (01/13)
- fixed a mistake in (03/13)
- collected some ACKs


Here are some patches that I've collected. All are cleanups and
small fixes, no change in functionality.

As a result, 24K bytes are saved, and 87 lines of code are
reduced:

   text    data     bss     dec     hex filename
5355293 1961928 7103260 14420481         dc0a01 vmlinux.o.old
5331208 1961864 7103260 14396332         dbabac vmlinux.o

---
 include/linux/ftrace_event.h       |    4 +-
 include/linux/syscalls.h           |    6 +-
 include/trace/ftrace.h             |   56 ++-----------
 kernel/trace/ftrace.c              |   30 ++++---
 kernel/trace/power-traces.c        |    2 -
 kernel/trace/trace.c               |  166 +++++++++++++-----------------------
 kernel/trace/trace.h               |   23 +++---
 kernel/trace/trace_event_profile.c |    6 +-
 kernel/trace/trace_events.c        |   38 +++++++--
 kernel/trace/trace_export.c        |    4 -
 kernel/trace/trace_kprobe.c        |    9 --
 kernel/trace/trace_ksym.c          |   13 ++--
 kernel/trace/trace_syscalls.c      |   18 +----
 13 files changed, 144 insertions(+), 231 deletions(-)
