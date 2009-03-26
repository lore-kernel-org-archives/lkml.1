Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZCZBIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZCZBIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZCZBIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:08:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63687 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZCZBIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:08:14 -0400
Message-Id: <20090326010737.611522983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 21:07:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 0/2] [GIT PULL] function profiler updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest rfc/tip/tracing/function-profiler tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
rfc/tip/tracing/function-profiler


Steven Rostedt (2):
      tracing: remove on the fly allocator from function profiler
      tracing: add average time in function to function profiler

----
 kernel/trace/ftrace.c |   97 +++++++++++++++++++++++++++++--------------------
 1 files changed, 57 insertions(+), 40 deletions(-)
-- 
