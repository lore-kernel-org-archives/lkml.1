Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZIXTti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZIXTti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZIXTth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:49:37 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54837 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZIXTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dW5x4jNUGH/7t7sUB/bC+NiowtMZWmCQ10DKZfPIqWYEg6jdQ/cmQmUXPNe6Vrqmfa
         eo1o6Ui9fRsuIgJoXJQp4ADDZqWwmw582mLMup+ICC3ulavL2n0onEHmIs7YTTK+23Gy
         WwGPdIKqKvlAwVIsv5LBXxLjjqLhBbiVtuK88=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL v2] bkl tracepoints + filter regex support
Date: Thu, 24 Sep 2009 21:49:30 +0200
Message-Id: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This is new iteration of the bkl tracepoints + filter
regex support. It addresses the reviews that were posted
in the previous RFC version.

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks;
Frederic.

Frederic Weisbecker (5):
      tracing/bkl: Add bkl ftrace events
      tracing/filters: Cleanup useless headers
      tracing/event: Cleanup the useless dentry variable
      tracing/filters: Provide basic regex support
      tracing/filters: Unify the regex parsing helpers

 include/linux/smp_lock.h           |   19 ++++-
 include/trace/events/bkl.h         |   61 ++++++++++++++
 kernel/trace/ftrace.c              |   64 +--------------
 kernel/trace/trace.h               |   36 ++++++--
 kernel/trace/trace_events.c        |   23 +++---
 kernel/trace/trace_events_filter.c |  155 +++++++++++++++++++++++++++++++----
 lib/kernel_lock.c                  |   11 ++-
 7 files changed, 262 insertions(+), 107 deletions(-)
 create mode 100644 include/trace/events/bkl.h
