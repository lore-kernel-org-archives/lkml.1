Return-Path: <linux-kernel-owner+w=401wt.eu-S966462AbXEHKbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966462AbXEHKbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966365AbXEHKa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:30:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52692 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966353AbXEHKa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:30:58 -0400
Date: Tue, 8 May 2007 12:29:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>, phillips@google.com
Subject: Re: [patch] CFS scheduler, -v9
Message-ID: <20070508102943.GA10105@elte.hu>
References: <20070503140911.GA21916@elte.hu> <4d47a5d10705070302k3f081074k89f0122cee7ae2e@mail.gmail.com> <463F31C2.1070809@tmr.com> <20070507185742.GE19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507185742.GE19966@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* William Lee Irwin III <wli@holomorphy.com> wrote:

> > You also seem to be unaware of the work done by Nick Piggin in 
> > nicksched. There are a lot of mutually incompatible approaches being 
> > evaluated, and that's good for the future.
> 
> I'd like to add in Mike Kravetz, Hubertus Franke, and Peter Williams 
> for mention here. There are doubtlesss many others also deserving some 
> recognition for significant past work.

Peter is certainly one of the most active current contributors to the 
scheduler! And the list goes on: here is the list of the 71 people who 
contributed to the scheduler recently (based on the git log which covers 
the past 2 years):

 Nick Piggin, Con Kolivas, Suresh B Siddha, Christoph Lameter,
 Oleg Nesterov, Linus Torvalds, Peter Williams, Kenneth W Chen,
 Steven Rostedt, Srivatsa Vaddagiri, Mike Galbraith, Chandra Seetharaman,
 Thomas Gleixner, Heiko Carstens, Robert P. J. Day, Paul Jackson,
 Matt Mackall, Kirill Korotaev, John Hawkes, Jack Steiner, Andrew Morton,
 Andreas Mohr, Andi Kleen, Al Viro, Zachary Amsden, Tim Chen, Shailabh Nagar,
 Satoru Takeuchi, Renaud Lienhart, Randy Dunlap, Peter Zijlstra,
 Paul Mackerras, Olivier Croquette, Nigel Cunningham, Nathan Lynch,
 Miguel Ojeda Sandonis, M.Baris Demiray, Martin Waitz, Martin Andersson,
 Mark Fasheh, Keith Owens, Kamezawa Hiroyuki, Jim Houston, Jesper Juhl,
 Jens Axboe, Jeff Garzik, Jay Lan, Jason Baron, Jan Kara, Hugh Dickins,
 Helge Deller, Greg Banks, Eric Dumazet, Dinakar Guniguntala, David Quigley,
 Dave Jones, Chuck Ebbert, Christoph Hellwig, Chris Caputo, Chen Shang, 
 Borislav Petkov, Bibo Mao, Benjamin LaHaise, Arjan van de Ven,
 Anton Blanchard, Andreas Steinmetz, Alexey Dobriyan, Akinobu Mita,
 Adrian Bunk.

and there are countless others from the 10 years not covered by the git 
log, so the list is far from complete.

Furthermore, here's the 'toplist' of number-of-authors-per-source-file 
list of linux/*/*.c files (which covers most of the core kernel source 
files, based on 2 years of git metadata):

                kernel/sched.c: 72
               mm/page_alloc.c: 60
                     mm/slab.c: 55
                 kernel/fork.c: 54
               kernel/sysctl.c: 47
                  mm/filemap.c: 42
                kernel/timer.c: 42
                  kernel/sys.c: 41
                   mm/memory.c: 40
                   fs/buffer.c: 39
               kernel/module.c: 38
                 kernel/exit.c: 38
                     fs/exec.c: 38
                  net/socket.c: 36
               kernel/signal.c: 36
                   init/main.c: 36
             block/ll_rw_blk.c: 35
               fs/binfmt_elf.c: 34
                    mm/shmem.c: 33
                    fs/namei.c: 33
                         [...]

the scheduler is one of the most diversely and most actively hacked 
subsystems in the kernel.

	Ingo
