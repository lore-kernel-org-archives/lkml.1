Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYKEVeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYKEVeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYKEVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:34:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYKEVeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:34:08 -0500
Message-Id: <20081105212428.148612398@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 05 Nov 2008 16:24:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] ftrace: start stop infrastructure changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
 Note, I'm now trying to learn to use git. I am experimenting with
 using a combination of quilt and git. I set up a git repo at:

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

 This series is in the tip/devel branch.

 I'll put my changes in that branch and then send out the patches
 as I have always done. But the introduction will list the shortlog
 of the changes, then followed by the patches themselves.

 I do this by using git format-patch and then having quilt send
 out the queue that was produced.

 I plan on automating a lot of this, but for this run, it was
 done manually.

]

Ingo,

The following patches are in

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

  branch: tip/devel

Steven Rostedt (3):
      ftrace: add quick function trace stop
      ftrace: soft tracing stop and start
      ftrace: restructure tracing start/stop infrastructure


The first two should be fine, but the last one changed the infrastructure
a bit, and will need a bit of testing.

-- Steve

