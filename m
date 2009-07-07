Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZGGFwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZGGFwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZGGFwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:52:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62514 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZGGFwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:52:16 -0400
Message-ID: <4A52E291.1020408@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:52:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] ksym_tracer: various fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some fixes for ksym_tracer.

[PATCH 1/8] ksym_tracer: Extract trace entry from struct trace_ksym
[PATCH 2/8] ksym_tracer: Rewrite ksym_trace_filter_read()
[PATCH 3/8] ksym_tracer: Fix validation of access type
[PATCH 4/8] ksym_tracer: Fix validation of length of access type
[PATCH 5/8] ksym_tracer: NIL-terminate user input filter
[PATCH 6/8] ksym_tracer: Report error when failed to re-register hbp
[PATCH 7/8] ksym_tracer: Fix memory leak
[PATCH 8/8] ksym_tracer: Fix the output of stat tracing
---
 kernel/trace/trace_ksym.c |  161 ++++++++++++++++++++++-----------------------
 1 files changed, 78 insertions(+), 83 deletions(-)

