Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYLCQF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYLCQF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYLCQFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:05:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYLCQFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:05:49 -0500
Message-Id: <20081203160448.972919719@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Dec 2008 11:04:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] ftrace: fixes for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

These two patches are fixes. The first cleans up the stack_trace
output to print 0's for the return_to_handler function.

The second is the nasty race we have been hitting. My patches must
have made the race window bigger for you since the bug was there
before. It is a nasty race in the fork code. More info in the change log
of that patch.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (2):
      trace: fix output of stack trace
      ftrace: fix race in function graph during fork

----
 kernel/fork.c              |    9 ++++++---
 kernel/trace/trace_stack.c |    5 ++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
