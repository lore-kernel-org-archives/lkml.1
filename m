Return-Path: <linux-kernel-owner+w=401wt.eu-S1763039AbYJJTes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763039AbYJJTes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760356AbYJJTek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:34:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561AbYJJTej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:34:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: [Bug #11224] Only three cores found on quad-core machine.
Date: Fri, 10 Oct 2008 21:39:08 +0200
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <0pOgGB.A.uLG.E475IB@wind> <200810081524.40614.nickpiggin@yahoo.com.au> <20081010153938.GC12937@redhat.com>
In-Reply-To: <20081010153938.GC12937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810102139.09411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 of October 2008, Dave Jones wrote:
> On Wed, Oct 08, 2008 at 03:24:40PM +1100, Nick Piggin wrote:
>  > On Wednesday 08 October 2008 02:32, Dave Jones wrote:
>  > > On Wed, Oct 08, 2008 at 02:18:18AM +1100, Nick Piggin wrote:
>  > >  > On Sunday 05 October 2008 04:32, Rafael J. Wysocki wrote:
>  > >  > > This message has been generated automatically as a part of a report
>  > >  > > of recent regressions.
>  > >  > >
>  > >  > > The following bug entry is on the current list of known regressions
>  > >  > > from 2.6.26.  Please verify if it still should be listed and let me
>  > >  > > know (either way).
>  > >  > >
>  > >  > >
>  > >  > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
>  > >  > > Subject		: Only three cores found on quad-core machine.
>  > >  > > Submitter	: Dave Jones <davej@redhat.com>
>  > >  > > Date		: 2008-08-01 18:15 (65 days old)
>  > >  > > References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4
>  > >  >
>  > >  > Dave, is your CPU2 getting stuck in calibrate_delay? Can you still
>  > >  > reproduce the bug? What if you boot the kernel with lpj=<something sane
>  > >  > like 2666785> in order to skip the calibrate_delay code?
>  > >  >
>  > >  > If that helps, can you try adding some printks to narrow down where it
>  > >  > is getting stuck?
>  > >
>  > > This is going to sound strange, but I've forgotten which box that was.
>  > > I'm due to reinstall all my test boxes now that the next Fedora beta
>  > > has come out anyway, so I'll hopefully figure out by the end of the week :)
>  > 
>  > That does sound strange ;) But I can't believe that! It would be really
>  > interesting if it was stuck in calibrate_delay, but maybe the backtrace
>  > is just messed up...
>  > 
>  > If you do manage to reproduce it, I would be quite interested. Otherwise,
>  > I think we can say it's not a showstopper for 2.6.27.
> 
> Ok, this can be closed out. 2.6.27 seems to work fine on all the
> quad core machines I have in my cube.

Thanks, closed.

Rafael
