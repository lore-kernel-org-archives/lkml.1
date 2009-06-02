Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZFBWD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZFBWD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZFBWDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:03:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54569 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFBWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:03:09 -0400
Message-Id: <20090602220212.894951549@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 18:02:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org
Subject: [PATCH 0/2] [GIT PULL][urgent] function-graph: allocation and freeing of ret_stack
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Here's a couple of more fixes.

Please pull the latest tip/tracing/urgent-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent-1


Steven Rostedt (2):
      function-graph: move initialization of new tasks up in fork
      function-graph: always initialize task ret_stack

----
 kernel/fork.c         |   10 ++++------
 kernel/trace/ftrace.c |    6 ++++--
 2 files changed, 8 insertions(+), 8 deletions(-)
-- 
