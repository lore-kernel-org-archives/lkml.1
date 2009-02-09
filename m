Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZBIRap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZBIRap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbZBIRaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:30:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbZBIRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:30:03 -0500
Message-Id: <20090209172830.087244662@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 09 Feb 2009 12:28:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 0/3] git pull request for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I pulled in the splice code from Eduard into a branch that is
based off of tip's tracing/ftrace branch.

I kept Eduard's patches as is, and implemented the suggested clean
ups at the end.

My branch names were getting too long so I hacked off the "/devel"
part at the end that I usually have.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/ftrace


Eduard - Gabriel Munteanu (2):
      tracing: splice support for tracing_pipe
      tracing: Move pipe waiting code out of tracing_read_pipe().

Steven Rostedt (1):
      tracing: clean up splice code

----
 kernel/trace/trace.c |  219 +++++++++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.h |    6 ++
 2 files changed, 196 insertions(+), 29 deletions(-)

-- 
