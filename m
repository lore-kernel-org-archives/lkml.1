Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZGWOFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZGWOFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZGWOFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:05:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZGWOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:05:16 -0400
Message-Id: <20090723140259.100790900@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 10:02:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL][2.6.31] tracing: fix of memory leaks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Li Zefan (3):
      trace_stack: Fix seqfile memory leak
      function-graph: Fix seqfile memory leak
      tracing/stat: Fix seqfile memory leak

----
 kernel/trace/ftrace.c      |   15 ++++++++++++---
 kernel/trace/trace_stack.c |    7 ++-----
 kernel/trace/trace_stat.c  |   34 ++++++++++++++++++++++------------
 3 files changed, 36 insertions(+), 20 deletions(-)
-- 
