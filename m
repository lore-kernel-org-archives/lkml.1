Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZGHUO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZGHUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZGHUOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:14:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54163 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZGHUOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:14:48 -0400
Message-Id: <20090708201312.222046866@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 08 Jul 2009 16:13:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 0/3] [GIT PULL] rebase of lockless ring buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is the same as v2 that I posted a while ago. You asked me to resend
after the merge window. It is now after the merge window and I rebased
the work against latest tip/tracing/core. I made no changes that git
could not figure out itself.

Please pull the latest tip/tracing/ring-buffer-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ring-buffer-3


Steven Rostedt (3):
      ring-buffer: make the buffer a true circular link list
      ring-buffer: make lockless
      ring-buffer: add design document

----
 Documentation/trace/ring-buffer-design.txt |  955 ++++++++++++++++++++++++++++
 include/linux/ring_buffer.h                |    1 -
 kernel/trace/ring_buffer.c                 |  935 ++++++++++++++++++++++-----
 kernel/trace/trace.c                       |    3 -
 4 files changed, 1725 insertions(+), 169 deletions(-)

-- 
