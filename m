Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbYKOArC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbYKOArC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 19:47:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYKOAqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 19:46:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYKOAqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 19:46:08 -0500
Message-Id: <20081115004537.616030629@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 19:45:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/3] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (3):
      ftrace: remove condition from ftrace_record_ip
      ftrace: disable ftrace on anomalies in trace start and stop
      ftrace: do not process freed records

----
 kernel/trace/ftrace.c |   91 +++++++++++++++++++++++++++---------------------
 1 files changed, 51 insertions(+), 40 deletions(-)
