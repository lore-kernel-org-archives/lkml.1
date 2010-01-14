Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341Ab0ANCwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0ANCwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656Ab0ANCwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:52:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51460 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab0ANCwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:52:42 -0500
Message-ID: <4B4E86FB.40208@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 10:52:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7][RESEND] tracing: Fix bugs in string filters.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes some bugs in string filters. Those bugs
affect both ftrace and perf-trace.

A new string helper strnstr() is introduced, to be used in
middle matching callback.

Also I add some comments to mainly explain why we should use
length-limited version of strstr() and strcmp().

---
 include/linux/string.h             |    5 ++++-
 kernel/trace/ftrace.c              |    6 +++---
 kernel/trace/trace_events_filter.c |   29 ++++++++++++++++++++---------
 lib/string.c                       |   27 ++++++++++++++++++++++++++-
 4 files changed, 53 insertions(+), 14 deletions(-)


