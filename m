Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbZKZHC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbZKZHC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZKZHC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:02:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59350 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbZKZHC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:02:56 -0500
Message-ID: <4B0E2807.4060102@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:02:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] tracing: Convert some trace events to DEFINE_TRACE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert some trace events defined in include/trace/events/*.h
to DEFINE_TRACE and DEFINE_TRACE_PRINT.

This reduces hundreds of code lines, and shrinks the size
of object files.

Tested by comparing the formats of each trace_event before
and after patching.

This patchset is based on -tip tree, but I've conformed the
ext4 bits won't conflict with ext4 tree.

---
 include/trace/events/block.h     |  202 ++++++++------------------------------
 include/trace/events/ext4.h      |  129 +++++++------------------
 include/trace/events/irq.h       |   46 ++++-----
 include/trace/events/jbd2.h      |   63 ++----------
 include/trace/events/kmem.h      |  130 ++++++++-----------------
 include/trace/events/module.h    |   22 ++---
 include/trace/events/power.h     |   36 +++----
 include/trace/events/sched.h     |   18 +---
 include/trace/events/workqueue.h |   22 ++---
 mm/page_alloc.c                  |    4 +-
 mm/util.c                        |    3 -
 11 files changed, 187 insertions(+), 488 deletions(-)

