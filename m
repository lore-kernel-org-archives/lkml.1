Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbZCMFI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbZCMFI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbZCMFFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:05:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbZCMFFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:05:23 -0400
Message-Id: <20090313050446.277065036@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 01:04:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 0/4] [GIT PULL] updates for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (4):
      tracing: left align location header in stack_trace
      tracing: add comment for use of double __builtin_consant_p
      tracing: move binary buffers into per cpu directory
      softirq: no need to have SOFTIRQ in softirq name

----
 kernel/softirq.c           |    5 ++---
 kernel/trace/trace.c       |   26 +++++---------------------
 kernel/trace/trace.h       |    5 +++++
 kernel/trace/trace_stack.c |    4 ++--
 4 files changed, 14 insertions(+), 26 deletions(-)
-- 
