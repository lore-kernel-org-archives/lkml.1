Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYGFS1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYGFS1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 14:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbYGFS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 14:27:34 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38454 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbYGFS1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 14:27:33 -0400
Date: Sun, 6 Jul 2008 21:26:48 +0300
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
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080706182648.GE21669@cs181140183.pp.htv.fi>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <200807061905.50261.rjw@sisk.pl> <20080706174006.GD21669@cs181140183.pp.htv.fi> <200807062002.46863.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807062002.46863.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 08:02:45PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 6 of July 2008, Adrian Bunk wrote:
> > On Sun, Jul 06, 2008 at 07:05:49PM +0200, Rafael J. Wysocki wrote:
> > > 
> > > Also, in the next couple of days I'll be closing the bugs the reporters of
> > > which have been totally unresponsive.
> > >...
> > 
> > If no action by us gets combined with automated weekly emails then
> > no responses to the latter is not an unexpected event.
> > 
> > Such a submitter might be perfectly responsive to actual work on a bug 
> > while really pissed off by getting the bug closed.
> > 
> > Look e.g. at #10865 that had a 1 month gap in submitter responses,
> > but the actual problem is that noone of us ever bothered to look at
> > this Oops...
> > 
> > I just did a run through all open 2.6.26-rc regressions, and I did not 
> > find a single one where we seem to be waiting for some time for an 
> > answer of the submitter. [1]
> 
> The following are my candidates:
> 
> 10629

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject         : 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter       : Alexey Dobriyan <adobriyan@gmail.com>
Date            : 2008-05-05 09:59 (63 days old)
References      : http://lkml.org/lkml/2008/5/5/28
Handled-By      : Paul E. McKenney <paulmck@linux.vnet.ibm.com>


See below at #10815.


> 10786

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10786
Subject         : parisc: 64bit SMP does not boot on J5600
Submitter       : Domenico Andreoli <cavokz@gmail.com>
Date            : 2008-05-22 16:14 (46 days old)
References      : http://marc.info/?l=linux-kernel&m=121147328028081&w=4


Submitter sent bug report, it seems no kernel developer ever bothered
to answer.

The unresponsive side is not the submitter.


> 10815

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10815
Subject         : 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Submitter       : Alexey Dobriyan <adobriyan@gmail.com>
Date            : 2008-05-27 09:23 (41 days old)
References      : http://lkml.org/lkml/2008/5/27/9
                  http://lkml.org/lkml/2008/6/14/87
Handled-By      : Oleg Nesterov <oleg@tv-sign.ru>
                  Linus Torvalds <torvalds@linux-foundation.org>
                  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch           : http://lkml.org/lkml/2008/5/28/16


Linus just restarted discussing this one and #10629.

My impression of both bugs is that not that Alexey was unresponsive but 
that noone else was able to reproduce it.


> 10906 (the thread has apparently died)

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10906
Subject         : repeatable slab corruption with LTP msgctl08
Submitter       : Andrew Morton <akpm@linux-foundation.org>
Date            : 2008-06-12 5:13 (25 days old)
References      : http://marc.info/?l=linux-kernel&m=121324775927704&w=4
Handled-By      : Pekka J Enberg <penberg@cs.helsinki.fi>
                  Christoph Lameter <clameter@sgi.com>
                  Manfred Spraul <manfred@colorfullife.com>
                  Andi Kleen <andi@firstfloor.org>

Andrew Morton said [1]:
  erk.  It'll make me a week to bisect this.  I suppose I can plod away
  at it in the background, but I won't be able to do that until the end
  of this month.


And "repeatable slab corruption" is not exactly a good regression
to ignore...


> 11009

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11009
Subject         : No console on Riva TNT since 2.6.26-0.rc4
Submitter       : Quel Qun <kelk1@comcast.net>
Date            : 2008-06-26 20:04 (11 days old)
References      : http://marc.info/?l=linux-kernel&m=121451344229718&w=4


Submitter sent bug report, it seems no kernel developer ever bothered
to answer.

The unresponsive side is not the submitter.


> Thanks,
> Rafael

cu
Adrian

[1] http://lkml.org/lkml/2008/6/13/45

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

