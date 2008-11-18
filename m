Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbYKRBef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbYKRBef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYKRBeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:34:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYKRBeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:34:08 -0500
Message-Id: <20081118013212.470074567@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 17 Nov 2008 20:32:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       miltonm@bga.com
Subject: [PATCH 0/1] ftrace,ppc64: fix race condition pointed out by Milton Miller
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/ppc


Steven Rostedt (1):
      ftrace,ppc64: do not use nops for modules

----
 arch/powerpc/kernel/ftrace.c |   44 +++++++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 7 deletions(-)

-- 
