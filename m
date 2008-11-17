Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYKQTMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYKQTMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYKQTLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:11:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55044 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbYKQTLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:11:34 -0500
Message-Id: <20081117190948.619751203@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 17 Nov 2008 14:09:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 0/4] ftrace: PPC port of dynamic ftrace fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series of patches addresses the problems with PPC dynamic ftrace
updates that Paul Mackerras pointed out.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/ppc


Steven Rostedt (4):
      ftrace,ppc: consolidate dyn ftrace ppc code between 32 and 64 bit
      ftrace,ppc: fix test of 24bit jump
      ftrace,ppc: fix module check in dynamic ftrace code
      ftrace,ppc: fix test of branch link

----
 arch/powerpc/kernel/ftrace.c |  168 +++++++++++++++++++++---------------------
 1 files changed, 83 insertions(+), 85 deletions(-)
