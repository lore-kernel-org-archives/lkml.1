Return-Path: <linux-kernel-owner+w=401wt.eu-S1761735AbZAFWj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735AbZAFWj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbZAFWeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:34:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321AbZAFWeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:34:07 -0500
Message-Id: <20090106223337.677427397@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Jan 2009 17:33:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 0/3] ftrace: important updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The first patch is a critical fix that needs to get into 2.6.29.

The next patch is a rename of tracing_on to writing_enabled since
tracing_on is confusing, and the file enables or disables writes.

The last patch is a fix to tip that prevents a memory leak.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Frederic Weisbecker (1):
      tracing/ftrace: fix a memory leak in stat tracing

Steven Rostedt (2):
      ftrace: convert unsigned index to signed
      ring-buffer: rename debugfs file tracing_on to writing_enabled

----
 kernel/trace/ftrace.c      |    4 ++--
 kernel/trace/ring_buffer.c |    5 +++--
 kernel/trace/trace_stat.c  |   39 +++++++++++++++------------------------
 3 files changed, 20 insertions(+), 28 deletions(-)
-- 
