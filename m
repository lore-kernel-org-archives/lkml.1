Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZLGHkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZLGHkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758623AbZLGHkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:40:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61086 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbZLGHkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:40:16 -0500
Message-ID: <4B1CB14A.4080402@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:39:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/13] tracing: various cleanups and small fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some patches that I've collected. All are cleanups and
small fixes, no change in functionality.

---
 include/linux/ftrace_event.h       |    3 +-
 include/linux/syscalls.h           |    2 -
 include/trace/ftrace.h             |   55 ++++--------
 kernel/trace/ftrace.c              |   30 ++++---
 kernel/trace/power-traces.c        |    2 -
 kernel/trace/trace.c               |  166 +++++++++++++-----------------------
 kernel/trace/trace.h               |   23 +++---
 kernel/trace/trace_event_profile.c |    6 +-
 kernel/trace/trace_events.c        |   24 ++++--
 kernel/trace/trace_export.c        |    4 -
 kernel/trace/trace_kprobe.c        |    9 --
 kernel/trace/trace_ksym.c          |   13 ++--
 kernel/trace/trace_syscalls.c      |   18 +----
 13 files changed, 138 insertions(+), 217 deletions(-)
