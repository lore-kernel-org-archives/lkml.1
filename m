Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZB0Fe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZB0Fe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZB0Feq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:34:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZB0Fep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:34:45 -0500
Message-Id: <20090227053410.928389664@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 27 Feb 2009 00:34:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [git pull] for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (5):
      tracing: add options directory and core option files
      tracing: add tracer dependent options to options directory
      tracing: add protection around open use of current_tracer
      tracing: use pointer error returns for __tracing_open
      tracing: use newline separator for trace options list

----
 kernel/trace/trace.c |  368 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 333 insertions(+), 35 deletions(-)

-- 
