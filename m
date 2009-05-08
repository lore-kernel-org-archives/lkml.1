Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZEHUjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZEHUjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759084AbZEHUid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:38:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbZEHUi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:38:29 -0400
Message-Id: <20090508203605.361898511@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 16:36:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The first patch fixes a uninitialized variable. What bothers me about this,
is that gcc did not warn about it. My gcc warns about a ton of variables
that might not being initialized, but missed one that actually is not!

I wonder if it is only my version of gcc:  4.2.2
:-/

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (2):
      tracing: initialize return value for __ftrace_set_clr_event
      tracing: add trace_set_clr_event to export event enabling function

----
 include/linux/ftrace_event.h |    2 ++
 kernel/trace/trace_events.c  |   19 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)
-- 
