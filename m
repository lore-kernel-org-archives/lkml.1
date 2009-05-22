Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZEVKFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZEVKFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZEVKFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:05:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56651 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZEVKFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:05:35 -0400
Message-ID: <4A16788F.2060802@cn.fujitsu.com>
Date: Fri, 22 May 2009 18:03:59 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] ftrace: Add task_comm support for trace_event
References: <4A14FDFE.2080402@cn.fujitsu.com>
In-Reply-To: <4A14FDFE.2080402@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo pointed out that v1 patch can cause kernel compile fail:
kernel/built-in.o: In function `ftrace_event_enable_disable':
trace_events.c:(.text+0x6cf7a): undefined reference to `tracing_stop_cmdline_record'
trace_events.c:(.text+0x6cf91): undefined reference to `tracing_start_cmdline_record'

It is because trace_sched_switch.c is necessary for trace_event.c after patch,
and there are no dependence between these two files in Kconfig.

Changelog:
v1->v2: Update Kconfig for new file dependence.

Thanks
Zhaolei



