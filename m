Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbZJWXgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbZJWXgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZJWXgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:36:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64735 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZJWXgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:36:42 -0400
Message-Id: <20091023233615.661789185@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Oct 2009 19:36:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL] tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Jiri Olsa (4):
      tracing: updating *ppos instead of filp->f_pos
      tracing: fix trace_seq_printf return value
      tracing: comment typo and documentation example fix
      tracing: removing cpu arg from rb_time_stamp function

----
 Documentation/trace/ftrace.txt |    2 ++
 include/linux/trace_seq.h      |    2 +-
 kernel/trace/ftrace.c          |    2 +-
 kernel/trace/ring_buffer.c     |   12 ++++++------
 kernel/trace/trace.c           |    8 ++++----
 kernel/trace/trace_output.c    |    5 ++++-
 6 files changed, 18 insertions(+), 13 deletions(-)
