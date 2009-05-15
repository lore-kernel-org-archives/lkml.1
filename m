Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZEOEIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZEOEIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZEOEHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:07:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36830 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZEOEHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:07:47 -0400
Message-Id: <20090515040554.074680910@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 00:05:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL] tracing: small updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Li Zefan (2):
      tracing/filters: add missing unlock in a failure path
      tracing/filters: fix off-by-one bug

Steven Rostedt (2):
      x86/stacktrace: return 0 instead of -1 for stack ops
      tracing: stop stack trace on first empty entry

----
 arch/x86/kernel/stacktrace.c       |    2 +-
 kernel/trace/trace_events_filter.c |   12 +++++++-----
 kernel/trace/trace_output.c        |    2 ++
 3 files changed, 10 insertions(+), 6 deletions(-)
-- 
