Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYLDF1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYLDF1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYLDF1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:27:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYLDF1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:27:37 -0500
Message-Id: <20081204052638.425740534@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Dec 2008 00:26:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 0/3] ftrace: clean ups for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are to have ftrace use the pid struct
for filtering on pids.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (3):
      fix the do_each_pid_task macro
      ftrace: use struct pid
      ftrace: add ability to only trace swapper tasks

----
 include/linux/pid.h   |    4 +-
 kernel/trace/ftrace.c |  128 ++++++++++++++++++++++++++++++++++++------------
 kernel/trace/trace.h  |    4 +-
 3 files changed, 100 insertions(+), 36 deletions(-)
-- 
