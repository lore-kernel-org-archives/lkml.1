Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYJJPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYJJPk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758596AbYJJPkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:40:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60336 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758135AbYJJPkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:40:10 -0400
Date: Fri, 10 Oct 2008 11:39:38 -0400
From: Dave Jones <davej@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11224] Only three cores found on quad-core machine.
Message-ID: <20081010153938.GC12937@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <0pOgGB.A.uLG.E475IB@wind> <200810080218.18898.nickpiggin@yahoo.com.au> <20081007153203.GB3337@redhat.com> <200810081524.40614.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810081524.40614.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 03:24:40PM +1100, Nick Piggin wrote:
 > On Wednesday 08 October 2008 02:32, Dave Jones wrote:
 > > On Wed, Oct 08, 2008 at 02:18:18AM +1100, Nick Piggin wrote:
 > >  > On Sunday 05 October 2008 04:32, Rafael J. Wysocki wrote:
 > >  > > This message has been generated automatically as a part of a report
 > >  > > of recent regressions.
 > >  > >
 > >  > > The following bug entry is on the current list of known regressions
 > >  > > from 2.6.26.  Please verify if it still should be listed and let me
 > >  > > know (either way).
 > >  > >
 > >  > >
 > >  > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
 > >  > > Subject		: Only three cores found on quad-core machine.
 > >  > > Submitter	: Dave Jones <davej@redhat.com>
 > >  > > Date		: 2008-08-01 18:15 (65 days old)
 > >  > > References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4
 > >  >
 > >  > Dave, is your CPU2 getting stuck in calibrate_delay? Can you still
 > >  > reproduce the bug? What if you boot the kernel with lpj=<something sane
 > >  > like 2666785> in order to skip the calibrate_delay code?
 > >  >
 > >  > If that helps, can you try adding some printks to narrow down where it
 > >  > is getting stuck?
 > >
 > > This is going to sound strange, but I've forgotten which box that was.
 > > I'm due to reinstall all my test boxes now that the next Fedora beta
 > > has come out anyway, so I'll hopefully figure out by the end of the week :)
 > 
 > That does sound strange ;) But I can't believe that! It would be really
 > interesting if it was stuck in calibrate_delay, but maybe the backtrace
 > is just messed up...
 > 
 > If you do manage to reproduce it, I would be quite interested. Otherwise,
 > I think we can say it's not a showstopper for 2.6.27.

Ok, this can be closed out. 2.6.27 seems to work fine on all the
quad core machines I have in my cube.

	Dave

-- 
http://www.codemonkey.org.uk
