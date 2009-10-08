Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZJHBUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZJHBUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZJHBUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:20:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZJHBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:20:03 -0400
Message-Id: <20091008011711.701283454@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 21:17:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL][for 2.6.32] tracing: some important fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The last two patches also need to go into the stable release.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (2):
      tracing: fix transposed numbers of lock_depth and preempt_count
      ftrace: check for failure for all conversions

jolsa@redhat.com (1):
      tracing: correct module boundaries for ftrace_release

----
 include/linux/ftrace.h      |    2 +-
 kernel/trace/ftrace.c       |   23 +++++++----------------
 kernel/trace/trace_output.c |   14 ++++++++------
 3 files changed, 16 insertions(+), 23 deletions(-)
