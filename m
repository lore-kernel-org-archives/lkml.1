Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZKQRNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZKQRNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZKQRNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:13:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50456 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZKQRNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:13:50 -0500
Message-Id: <20091117171242.761539651@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 17 Nov 2009 12:12:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is based on top of tip/tracing/core.

Please pull the latest tip/tracing/core-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-1


Lai Jiangshan (1):
      tracing: Prevent build warning: 'ftrace_graph_buf' defined but not used

Steven Rostedt (2):
      ring-buffer: Move access to commit_page up into function used
      tracing: Only print objcopy version warning once from recordmcount

----
 Makefile                   |    1 +
 kernel/trace/ftrace.c      |    2 +-
 kernel/trace/ring_buffer.c |    9 +++------
 scripts/recordmcount.pl    |   12 ++++++++++--
 4 files changed, 15 insertions(+), 9 deletions(-)
