Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZBFGys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZBFGys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZBFGyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:54:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZBFGyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:54:38 -0500
Message-Id: <20090206065352.940088243@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 01:53:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (4):
      ftrace, x86: rename in_nmi variable
      nmi: add generic nmi tracking state
      ftrace: change function graph tracer to use new in_nmi
      ring-buffer: use generic version of in_nmi

----
 arch/x86/Kconfig           |    2 +-
 arch/x86/kernel/ftrace.c   |   39 ++++++++++-----------------------------
 include/linux/ftrace_irq.h |    8 --------
 include/linux/hardirq.h    |   15 +++++++++++++++
 kernel/trace/ring_buffer.c |   43 +++++++++++++------------------------------
 5 files changed, 39 insertions(+), 68 deletions(-)
-- 
