Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbZLKSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbZLKSmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZLKSmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:42:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717AbZLKSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:42:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=18Sr5wuH8ZcA:10 a=VwQbUJbxAAAA:8 a=LPR37ZagT-IT8Xb1F48A:9 a=tguR37NDbfwXAK5nBBBcqJrkX_YA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091211184018.738768739@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 11 Dec 2009 13:40:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: stack tracing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I based this on top of my last tip/tracing/urgent request. These are
enhancements and not fixes. But since the merge window is still open
and these are very small patches, I figured we try to get them in for
2.6.33.

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (2):
      tracing: Add trace_dump_stack()
      tracing: Add stack trace to irqsoff tracer

----
 include/linux/kernel.h       |    2 ++
 kernel/trace/trace.c         |   16 ++++++++++++++++
 kernel/trace/trace_irqsoff.c |    2 ++
 3 files changed, 20 insertions(+), 0 deletions(-)
