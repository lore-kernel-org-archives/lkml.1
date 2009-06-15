Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbZFOCyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbZFOCyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZFOCym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:54:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZFOCym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:54:42 -0400
Message-ID: <4A35B84B.40904@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 10:56:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] tracing: some fixes for 2.6.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some small but not trival fixes for 2.6.31:

[PATCH 1/4] tracing: fix a typo in tracing_cpumask_write()
[PATCH 2/4] tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
[PATCH 3/4] tracing/filters: operand can be negative
[PATCH 4/4] tracing/filters: strloc should be unsigned short
---
 kernel/trace/trace.c               |    8 ++++----
 kernel/trace/trace_events_filter.c |    9 +++++++--
 2 files changed, 11 insertions(+), 6 deletions(-)


