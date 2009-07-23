Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZGWD3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZGWD3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZGWD3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:29:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbZGWD3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:29:45 -0400
Message-ID: <4A67D8CB.4040909@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 11:28:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] tracing: Fix seqfile memory leak for .31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some memory leak in tracing code, due to missing
seq_release().

I think those fixes should be queued for .31.

[PATCH 1/3] trace_stack: Fix seqfile memory leak
[PATCH 2/3] function-graph: Fix seqfile memory leak
[PATCH 3/3] tracing/stat: Fix seqfile memory leak
---
 kernel/trace/ftrace.c      |   15 ++++++++++++---
 kernel/trace/trace_stack.c |    7 ++-----
 kernel/trace/trace_stat.c  |   34 ++++++++++++++++++++++------------
 3 files changed, 36 insertions(+), 20 deletions(-)

