Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968383Ab0B0N5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:57:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33127 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968369Ab0B0N5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:57:51 -0500
Date: Sat, 27 Feb 2010 14:57:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes for v2.6.34
Message-ID: <20100227135745.GA10619@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

This is the leftover tracing/urgent queue from after -rc8.

 Thanks,

	Ingo

------------------>
Masami Hiramatsu (1):
      kprobes: Add mcount to the kprobes blacklist


 kernel/kprobes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b7df302..c4b4343 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -93,6 +93,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"native_get_debugreg",},
 	{"irq_entries_start",},
 	{"common_interrupt",},
+	{"mcount",},	/* mcount can be called from everywhere */
 	{NULL}    /* Terminator */
 };
 
