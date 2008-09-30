Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYI3DHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYI3DHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYI3DGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:06:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbYI3DGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:06:54 -0400
Message-Id: <20080930030236.230994826@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 23:02:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 0/6] ftrace: port to the new ring_buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are against linux-tip.

The first is just a fix in the wakeup selftest.

The next is a port of the Unified tracer buffer to linux-tip and some updates.

After that is the ftrace port to use the ring buffer, followed by some
more enhancements to ftrace because of the new variable length
buffer.

I tried a few configurations and tried to test all the different ftrace
tracers, but I'm sure there may be some bugs still to work out. I worked
out all those that I found.

But, with the ring_buffer I can envision several ways to clean up
ftrace and to make adding new tracers cleaner.

I'm also thinking about making a way that each tracer can allocate
its own buffer, and allow for more than one tracer to be running
at the same time! (only with different buffers).

-- Steve

