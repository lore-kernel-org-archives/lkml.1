Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZIVTLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZIVTLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZIVTLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:11:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZIVTLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:11:39 -0400
Date: Tue, 22 Sep 2009 21:11:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Daniel Walker <dwalker@fifo99.com>,
       claudio@evidence.eu.com, michael@evidence.eu.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
Message-ID: <20090922191117.GB24542@elte.hu>
References: <1253615424.20345.76.camel@Palantir> <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir> <1253637721.18939.3.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253637721.18939.3.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-09-22 at 16:01 +0200, Raistlin wrote:
> > On Tue, 2009-09-22 at 06:24 -0700, Daniel Walker wrote:
> > > You've got some type of encoding corruption in your patch,
> > > 
> > Oops! Sorry about that... :(
> 
> Don't worry, they are fine.

Yes - i was able to save and apply the patch just fine too:

earth4:~/tip> q push
Applying patch patches/sched_edf-scheduling-class.patch
patching file arch/arm/include/asm/unistd.h
patching file arch/arm/kernel/calls.S
patching file arch/x86/ia32/ia32entry.S
patching file arch/x86/include/asm/unistd_32.h
patching file arch/x86/include/asm/unistd_64.h
patching file arch/x86/kernel/syscall_table_32.S
patching file include/linux/sched.h
Hunk #3 succeeded at 165 (offset 4 lines).
Hunk #5 succeeded at 1205 (offset 23 lines).
Hunk #7 succeeded at 1609 (offset 22 lines).
patching file include/linux/syscalls.h
patching file init/Kconfig
patching file kernel/fork.c
Hunk #1 succeeded at 1223 (offset 20 lines).
patching file kernel/sched.c
Hunk #14 succeeded at 6099 (offset 12 lines).
Hunk #16 succeeded at 6287 (offset 12 lines).
Hunk #18 succeeded at 6339 (offset 12 lines).
Hunk #20 succeeded at 6376 (offset 12 lines).
Hunk #22 succeeded at 6486 (offset 12 lines).
Hunk #24 succeeded at 6540 (offset 12 lines).
Hunk #26 succeeded at 6609 (offset 12 lines).
Hunk #28 succeeded at 6704 (offset 12 lines).
Hunk #30 succeeded at 9547 (offset 12 lines).
Hunk #32 succeeded at 9636 (offset 12 lines).
Hunk #34 succeeded at 9747 (offset 12 lines).
Hunk #36 succeeded at 10218 (offset 12 lines).
Hunk #38 succeeded at 10277 (offset 12 lines).
Hunk #40 succeeded at 10750 (offset 12 lines).
Hunk #42 succeeded at 10838 (offset 12 lines).
patching file kernel/sched_debug.c
patching file kernel/sched_edf.c
patching file kernel/sched_fair.c
patching file kernel/sched_rt.c
patching file kernel/trace/trace_sched_wakeup.c

Now at patch patches/sched_edf-scheduling-class.patch

Daniel is a kind of self-elected joker-bot on lkml, running checkpatch 
out of .procmailrc and annoying people with trivial comments, 
distracting from the real discussion. Raistlin, feel free to ignore him 
in the future.

	Ingo
