Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZGXCPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZGXCPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 22:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZGXCPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 22:15:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZGXCPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 22:15:11 -0400
Message-Id: <20090724021403.694891838@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 22:14:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/3] [GIT PULL] tracing/ksys_tracer: misc fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/hw-breakpoints tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/hw-breakpoints


Xiao Guangrong (3):
      tracing/ksym_tracer: fix the output of ksym tracer
      tracing/ksym_tracer: fix write operation of ksym_trace_filter
      tracing/ksym_tracer: support quick clear for ksym_trace_filter -- v2

----
 kernel/trace/trace_ksym.c |   70 +++++++++++++++++++++++++++++----------------
 1 files changed, 45 insertions(+), 25 deletions(-)
-- 
