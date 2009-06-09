Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbZFIQiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbZFIQiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZFIQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:37:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbZFIQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:37:53 -0400
Message-Id: <20090609163657.557589106@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 12:36:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing/events/ring-buffer: block trace points and fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Li Zefan (1):
      tracing/events: convert block trace points to TRACE_EVENT()

Steven Rostedt (1):
      ring-buffer: fix ret in rb_add_time_stamp

----
 block/blk-core.c             |   16 +-
 block/elevator.c             |    8 +-
 drivers/md/dm.c              |    5 +-
 fs/bio.c                     |    3 +-
 include/linux/blktrace_api.h |   13 ++
 include/trace/block.h        |   76 -------
 include/trace/events/block.h |  483 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/Makefile        |    5 +-
 kernel/trace/blktrace.c      |   78 +++++++-
 kernel/trace/ring_buffer.c   |    2 +-
 mm/bounce.c                  |    5 +-
 11 files changed, 589 insertions(+), 105 deletions(-)
-- 
