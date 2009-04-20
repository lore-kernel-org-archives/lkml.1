Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbZDTW3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbZDTW3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbZDTWX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:23:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64055 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477AbZDTWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:23:27 -0400
Message-Id: <20090420222257.267399830@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 18:22:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (2):
      tracing: use recursive counter over irq level
      tracing: use nowakeup version of commit for function event trace tests

----
 kernel/trace/ring_buffer.c  |   45 +++++++++++++++---------------------------
 kernel/trace/trace_events.c |    2 +-
 2 files changed, 17 insertions(+), 30 deletions(-)
-- 
