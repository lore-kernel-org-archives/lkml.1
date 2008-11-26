Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYKZBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYKZBFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYKZBFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:05:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34846 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYKZBFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:05:11 -0500
Message-Id: <20081126010400.273569313@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 25 Nov 2008 20:04:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] ftrace v2: function return and function playing nice together
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I changed the last two patches of my previous post. The first patch
I did not change, so I am not adding it to this posting.

The changes made to this is compiler warnings.

The first patch I added "return 0;" to the stubs.

The second patch, I removed a hanging "out:" label.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (2):
      ftrace: use code patching for ftrace return tracer
      ftrace: let function tracing and function return run together

----
 arch/x86/kernel/entry_32.S |    5 ++++
 arch/x86/kernel/ftrace.c   |   46 ++++++++++++++++++++++++++++++++++++-
 include/linux/ftrace.h     |    5 ++++
 kernel/trace/ftrace.c      |   54 ++++++++++++-------------------------------
 4 files changed, 70 insertions(+), 40 deletions(-)

-- 
