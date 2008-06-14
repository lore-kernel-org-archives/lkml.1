Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYFNOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYFNOmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 10:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYFNOmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 10:42:14 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:54151 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbYFNOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 10:42:13 -0400
Date: Sat, 14 Jun 2008 07:42:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080614144200.GA26421@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.BVD.E3vSIB@albercik> <20080613135255.GB21341@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613135255.GB21341@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 04:52:55PM +0300, Adrian Bunk wrote:
> On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> > Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > Date		: 2008-05-27 09:23 (12 days old)
> > References	: http://lkml.org/lkml/2008/5/27/9
> > Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> > 		  Linus Torvalds <torvalds@linux-foundation.org>
> > 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Patch		: http://lkml.org/lkml/2008/5/28/16
> 
> What happened with this issue?

The patch listed above works for me, passes rcutorture, &c.  However,
I never have been able to reproduce the original problem, so cannot say
whether it qualifies as a fix.

							Thanx, Paul

> It is currently listed as 2.6.26-rc regression.
> Is this correct?
> 
> And if this patch is required it might not be a good idea to allow the 
> use to disable the new code.


