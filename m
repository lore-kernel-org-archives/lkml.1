Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYKLWzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYKLWzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYKLWzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:55:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43533 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbYKLWzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:55:05 -0500
Message-Id: <20081112225235.056515739@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 17:52:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 0/3] ftrace updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  I added a bit more people to the Cc so that they are aware
  of the pending renames that are coming.

   Namely, trace_entries will be renamed to buffer_size
           iter_ctrl will be renamed to trace_options
]

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (3):
      ftrace: rename trace_entries to buffer_size
      ftrace: rename iter_ctrl to trace_options
      ftrace: CPU buffer start annotation clean ups

----
 Documentation/ftrace.txt |   32 ++++++++++++++++----------------
 kernel/trace/trace.c     |   38 ++++++++++++++++++++++++++------------
 kernel/trace/trace.h     |    1 +
 3 files changed, 43 insertions(+), 28 deletions(-)
