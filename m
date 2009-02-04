Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZBDQqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZBDQqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZBDQqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:46:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42423 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbZBDQqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:46:31 -0500
Date: Wed, 4 Feb 2009 17:46:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Justin Mattock <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Justin Madru <jdm64@gawab.com>
Subject: Re: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
Message-ID: <20090204164623.GE25996@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.nXG.evYiJB@chimera> <dd18b0c30902040723m70f87f7fp4af32702410036d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30902040723m70f87f7fp4af32702410036d7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Justin Mattock <justinmattock@gmail.com> wrote:

> On Wed, Feb 4, 2009 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12505
> > Subject         : 2.6.29-rc1 Firefox crashing on page load
> > Submitter       : Justin Madru <jdm64@gawab.com>
> > Date            : 2009-01-16 20:56 (20 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4217458dafaa57d8e26a46f5d05ab8c53cf64191
> > References      : http://marc.info/?l=linux-kernel&m=123213941914274&w=4
> > Handled-By      : Justin P. Mattock <justinmattock@gmail.com>
> >
> >
> >
> 
> Well the hardest for this, was to reproduce
> the error.(never did). I guess it can be taken
> of if there was a patch for the fix, and the patch
> made it into the main tree. but if this  is a firefox
> issue, then a report needs to be filed with them.
> so overall my answer is "I don't know."
> :^)

the error is spurious because gcc randomly stomps on user register state so 
the effects can be rather random and unpredictable.

The fix:

 552b8aa: Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"

was included in -rc2 already, so please test latest -git whether you can see 
any such troubles.

	Ingo
