Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbZGPCyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbZGPCyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbZGPCyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:54:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65478 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757169AbZGPCyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:54:31 -0400
Message-ID: <4A5E9604.2030103@cn.fujitsu.com>
Date: Thu, 16 Jul 2009 10:52:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] tracing/events: 2 fixes for dynamic arrays
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These 2 fixes are necessary to make __dynamic_array/__string
parsable for users.

And also fix to pass the correct string length when filtering
on dynamic strings.

[PATCH 1/2] tracing/events: add missing type info of dynamic arrays
[PATCH 2/2] tracing/events: record the size of dynamic arrays
---
 include/trace/ftrace.h             |   18 ++++++++++--------
 kernel/trace/trace_events_filter.c |    6 ++++--
 2 files changed, 14 insertions(+), 10 deletions(-)
