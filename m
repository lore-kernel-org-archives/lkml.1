Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbXDOXcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbXDOXcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 19:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXDOXcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 19:32:52 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42999 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754052AbXDOXcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 19:32:51 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Mon, 16 Apr 2007 02:33:39 +0300
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <200704160149.42914.ismail@pardus.org.tr> <1176679389.3945.66.camel@laptopd505.fenrus.org>
In-Reply-To: <1176679389.3945.66.camel@laptopd505.fenrus.org>
X-Face: 9Va_@~iRiB"*X1O@K#(=?utf-8?q?thBxy=236XXkD87I=3DG=7E=23=26tFA=26=24mM+4oHIQZGdgCx9=23IZ=7ByL-?=
 =?utf-8?q?rk8CY=0A=09u=3B=7DX=7D?=,+R%vB]|/kKH:-<%Mym?njPCL%'gcIX.J$I}9+{Q|vvl0&c+>WFNbuN,>)
 =?utf-8?q?Of=3AUJq0=0A=09=7DL9+?="}tE:hB<t]y=^%m/R6z.OA8}$@VZ6N?m?h4^,GBNW&xS]9'I?;1OEohho"yF>
 =?utf-8?q?s36=7EN=0A=09=5CE0=60?=@O~`!C>JQkL|pqY{]A7Ow0PD$;BJ9^%!$[hV?(lrTA\rJk\rxnz>oW&W,
 =?utf-8?q?=3DE3obyZfC=0A=09=5EC=7BbqWCY?=
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704160233.41933.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 02:23:08 Arjan van de Ven wrote:
> On Mon, 2007-04-16 at 01:49 +0300, Ismail Dönmez wrote:
> > Hi,
> >
> > On Friday 13 April 2007 23:21:00 Ingo Molnar wrote:
> > > [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler
> > > [CFS]
> > >
> > > i'm pleased to announce the first release of the "Modular Scheduler
> > > Core and Completely Fair Scheduler [CFS]" patchset:
> > >
> > >    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> >
> > Tested this on top of Linus' GIT tree but the system gets very
> > unresponsive during high disk i/o using ext3 as filesystem but even
> > writing a 300mb file to a usb disk (iPod actually) has the same affect.
>
> just to make sure; this exact same workload but with the stock scheduler
> does not have this effect?
>
> if so, then it could well be that the scheduler is too fair for it's own
> good (being really fair inevitably ends up not batching as much as one
> should, and batching is needed to get any kind of decent performance out
> of disks nowadays)

Tried with make install in kdepim (which made system sluggish with CFS) and 
the system is just fine (using CFQ).

Regards,
ismail
