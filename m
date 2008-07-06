Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbYGFVdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbYGFVdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbYGFVdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:33:03 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34247 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451AbYGFVdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:33:01 -0400
Date: Mon, 7 Jul 2008 00:32:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080706213214.GH21669@cs181140183.pp.htv.fi>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <200807062002.46863.rjw@sisk.pl> <20080706182648.GE21669@cs181140183.pp.htv.fi> <200807062304.07443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807062304.07443.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 11:04:06PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 6 of July 2008, Adrian Bunk wrote:
> > On Sun, Jul 06, 2008 at 08:02:45PM +0200, Rafael J. Wysocki wrote:
> > > On Sunday, 6 of July 2008, Adrian Bunk wrote:
> > > > On Sun, Jul 06, 2008 at 07:05:49PM +0200, Rafael J. Wysocki wrote:
> > > > > 
> > > > > Also, in the next couple of days I'll be closing the bugs the reporters of
> > > > > which have been totally unresponsive.
> > > > >...
> > > > 
> > > > If no action by us gets combined with automated weekly emails then
> > > > no responses to the latter is not an unexpected event.
> > > > 
> > > > Such a submitter might be perfectly responsive to actual work on a bug 
> > > > while really pissed off by getting the bug closed.
> > > > 
> > > > Look e.g. at #10865 that had a 1 month gap in submitter responses,
> > > > but the actual problem is that noone of us ever bothered to look at
> > > > this Oops...
> > > > 
> > > > I just did a run through all open 2.6.26-rc regressions, and I did not 
> > > > find a single one where we seem to be waiting for some time for an 
> > > > answer of the submitter. [1]
> > > 
> > > The following are my candidates:
> > > 
> > > 10629
> > 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10629
> > Subject         : 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
> > Submitter       : Alexey Dobriyan <adobriyan@gmail.com>
> > Date            : 2008-05-05 09:59 (63 days old)
> > References      : http://lkml.org/lkml/2008/5/5/28
> > Handled-By      : Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > 
> > See below at #10815.
> > 
> > 
> > > 10786
> > 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10786
> > Subject         : parisc: 64bit SMP does not boot on J5600
> > Submitter       : Domenico Andreoli <cavokz@gmail.com>
> > Date            : 2008-05-22 16:14 (46 days old)
> > References      : http://marc.info/?l=linux-kernel&m=121147328028081&w=4
> > 
> > 
> > Submitter sent bug report, it seems no kernel developer ever bothered
> > to answer.
> > 
> > The unresponsive side is not the submitter.
> 
> The report is 46 days old and the reporter has been sent a request to confirm
> the presence of the problem every week.  Since he hasn't responded to any
> of those requests, I assume we're not going to hear from him.  Thus, it's not
> useful to track this any more.

Andrew Morton also never bothered to answer the automated emails you 
sent him regarding the regression he reported...

Humans react differently to programs than to humans interacting with 
them, and tons of automated mails without any actual efforts by humans 
can easily be considered a non-friendly act.

But for this bug I now found the commit that fixed it back in May.

Is there any specific reason why your automated emails only go to the 
submitters but not to the maintainers of the code in question? If you 
had Cc'ed Kyle once during the last 46 days he might have remembered 
that he already fixed this bug...

> Thanks,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

