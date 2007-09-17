Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbXIQUXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbXIQUXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXIQUXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:23:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbXIQUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:23:09 -0400
Date: Mon, 17 Sep 2007 22:22:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>
Cc: Rob Hussey <robjhussey@gmail.com>, efault@gmx.de, a.p.zijlstra@chello.nl,
       zippel@linux-m68k.org, linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070917202259.GA18027@elte.hu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <200709170712.03679.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709170712.03679.edt@aei.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ed Tomlinson <edt@aei.ca> wrote:

> Rob,
> 
> I gather this was with the complete -ck patchset?  It would be 
> interesting to see if just SD performed as well.  If it does, CFS 
> needs more work. if not there are other things in -ck that really do 
> improve performance and should be looked into.

yeah. The biggest item in -ck besides SD is swap-prefetch, but that 
shouldnt have an effect in this case. I _think_ that most of the 
measured difference is due to scheduler details though. Right now my 
estimation is that with the patch i sent to Rob, and with latest 
sched-devel.git, CFS should perform as good or better than SD, even in 
these micro-benchmarks. (but i cannot tell what will happen on Rob's 
machine - so i'm keeping an open mind towards any other fixables :-) I'm 
curious about the next round of numbers (if Rob has time to do them).

	Ingo
