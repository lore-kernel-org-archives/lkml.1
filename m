Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZHFCxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZHFCxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZHFCxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:53:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54205 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZHFCxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:53:01 -0400
Message-Id: <20090806025206.306150861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 05 Aug 2009 22:52:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Matt Fleming <mjf@gentoo.org>,
       Dave Airlie <airlied@gmail.com>
Subject: [PATCH 0/3] [GIT PULL][2.6.31] ring-buffer/tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (3):
      ring-buffer: fix check of try_to_discard result
      ring-buffer: do not disable ring buffer on oops_in_progress
      tracing: do not use functions starting with .L in recordmcount.pl

----
 kernel/trace/ring_buffer.c |    4 ++--
 scripts/recordmcount.pl    |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)
-- 
