Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYFNO5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYFNO5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 10:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYFNO5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 10:57:07 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36938 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYFNO5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 10:57:05 -0400
Date: Sat, 14 Jun 2008 18:58:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080614145839.GA10523@tv-sign.ru>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.BVD.E3vSIB@albercik> <20080613135255.GB21341@cs181133002.pp.htv.fi> <20080614144200.GA26421@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614144200.GA26421@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Paul E. McKenney wrote:
>
> On Fri, Jun 13, 2008 at 04:52:55PM +0300, Adrian Bunk wrote:
> > On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> > > Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> > > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > > Date		: 2008-05-27 09:23 (12 days old)
> > > References	: http://lkml.org/lkml/2008/5/27/9
> > > Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> > > 		  Linus Torvalds <torvalds@linux-foundation.org>
> > > 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Patch		: http://lkml.org/lkml/2008/5/28/16
> > 
> > What happened with this issue?
> 
> The patch listed above works for me, passes rcutorture, &c.  However,
> I never have been able to reproduce the original problem, so cannot say
> whether it qualifies as a fix.

I doubt very much RCU was the reason of this problem.

Alexey, how did you trigger this problem?

Oleg.

