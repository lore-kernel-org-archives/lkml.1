Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYK0CGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYK0CGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 21:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYK0CF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 21:05:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYK0CF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 21:05:56 -0500
Message-Id: <20081127020423.460116740@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 21:04:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/1] sched: divide by 0 error
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exists a race where we can hit a divide by zero in the scheduler
and crash the system.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: urgent


Steven Rostedt (1):
      sched: prevent divide by zero error in cpu_avg_load_per_task

----
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)
-- 
