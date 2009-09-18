Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZIRBdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZIRBdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 21:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZIRBdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 21:33:35 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35477 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZIRBde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 21:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=siaLqXfvmVF3U+Fu3H7IoEGmrvyBYtrn6Rhau7rjzZfIMjQVw1ppyYZbRwIJC37x6C
         oEo7/EWrocOxUXoODhX5I4WieZaiIXvpH639tZfy0k4OkpXkqQuoCCZV59x0CoHp/2ch
         uLS7M9AUKm9ydJDOKAhVOHOoV0++jg1AYqsp4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 0/2] tracing: Tracing event profiling updates
Date: Fri, 18 Sep 2009 03:33:31 +0200
Message-Id: <1253237613-5589-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tracing/core branch which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks,

	Frederic.


Frederic Weisbecker (2):
      tracing: Factorize the events profile accounting
      tracing: Allocate the ftrace event profile buffer dynamically

 include/linux/ftrace_event.h       |    9 ++-
 include/linux/syscalls.h           |   24 +++-----
 include/trace/ftrace.h             |  111 ++++++++++++++++++++---------------
 kernel/trace/trace_event_profile.c |   68 +++++++++++++++++++++-
 kernel/trace/trace_syscalls.c      |  103 +++++++++++++++++++++++++++------
 5 files changed, 228 insertions(+), 87 deletions(-)
