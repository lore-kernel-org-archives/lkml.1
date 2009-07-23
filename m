Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZGWDhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZGWDhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZGWDhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:37:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59672 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZGWDhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:37:03 -0400
Message-Id: <20090723033514.153354674@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Jul 2009 23:35:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

These two patches are built against my last push, but perhaps these
should go to 2.6.31. The first one fixes a bug that makes the 
printk_format file useless (making trace_bprintk useless for binary
readers). The other is a bug with the way the files may be truncated
incorrectly.

Please pull the latest tip/tracing/core-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-1


Steven Rostedt (2):
      tracing: show proper address for trace-printk format
      tracing: only truncate ftrace files when O_TRUNC is set

----
 kernel/trace/ftrace.c       |    4 ++--
 kernel/trace/trace.c        |    2 +-
 kernel/trace/trace_events.c |    2 +-
 kernel/trace/trace_printk.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
-- 
