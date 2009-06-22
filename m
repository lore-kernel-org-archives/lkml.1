Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZFVR6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZFVR6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZFVR6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:58:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50704 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbZFVR6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:58:16 -0400
In-Reply-To: <4A3F9062.6000303@renci.org>
Subject: Re: [perfmon2] IV.3 - AMD IBS
To: Rob Fowler <rjf@renci.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Philip Mucci <mucci@eecs.utk.edu>, Paul Mackerras <paulus@samba.org>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>, Suravee.Suthikulpanit@amd.com
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF59D5C0C6.E0786680-ON862575DD.006259BC-862575DD.0062B9C2@us.ibm.com>
From: Maynard Johnson <mpjohn@us.ibm.com>
Date: Mon, 22 Jun 2009 12:58:14 -0500
X-MIMETrack: Serialize by Router on d27ml103/27/M/IBM(Release 8.0.2FP1|January 12, 2009) at
 06/22/2009 12:58:16 PM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Fowler <rjf@renci.org> wrote on 06/22/2009 09:08:34 AM:

>
>
> Ingo Molnar wrote:
> >> 3/ AMD IBS
> >>
> >> How is AMD IBS going to be implemented?
> >>
> >> IBS has two separate sets of registers. One to capture fetch
> >> related data and another one to capture instruction execution
> >> data. For each, there is one config register but multiple data
> >> registers. In each mode, there is a specific sampling period and
> >> IBS can interrupt.
> >>
> >> It looks like you could define two pseudo events or event types
> >> and then define a new record_format and read_format. That formats
> >> would only be valid for an IBS event.
> >>
> >> Is that how you intend to support IBS?
> >
> > That is indeed one of the ways we thought of, not really nice, but
> > then, IBS is really weird, what were those AMD engineers thinking
> > :-)
>
> Actually, IBS has roots in DEC's "ProfileMe" for Alpha EV67 and later
> processors.   Those of us who used it there found it to be an extremely
> powerful, low-overhead mechanism for directly collecting information
about
> how well the micro-architecture is performing.  In particular, it can
tell
> you, not only which instructions take a long time to traverse the pipe,
but
> it also tells you which instructions delay other instructions and byhow
much.
> This is extremely valuable if you are either working on instruction
scheduling
> in a compiler, or are modifying a program to give the compiler the
opportunity
> to do a good job.
>
> A core group of engineers who worked on Alpha went on to AMD.
>
> An unfortunate problem with IBS on AMD is that good support isn't
> common in the "mainstream"
> open source community.
>
> Code Analyst from  AMD, also involving ex-DEC engineers, is
> the only place where it is supported at all decently throughout the
> tool chain.
> Last  time I looked, there was a tweaked version of oprofile underlying
CA.
> I haven't checked to see whether the tweaks have migrated back into
> the oprofile trunk.
Yes, IBS on AMD is now supported upstream in mainline, contributed by
Suravee Suthikulpanit.

-Maynard
>
>
> >
> > The point is - weird hardware gets expressed as a ... weird feature
> > under perfcounters too. Not all hardware weirdnesses can be
> > engineered away.
> >
> >
>
------------------------------------------------------------------------------

> > Are you an open source citizen? Join us for the Open Source Bridge
> conference!
> > Portland, OR, June 17-19. Two days of sessions, one day of
> unconference: $250.
> > Need another reason to go? 24-hour hacker lounge. Register today!
> > http://ad.doubleclick.net/clk;215844324;13503038;v?http:
> //opensourcebridge.org
> > _______________________________________________
> > perfmon2-devel mailing list
> > perfmon2-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/perfmon2-devel
>
> --
> Robert J. Fowler
> Chief Domain Scientist, HPC
> Renaissance Computing Institute
> The University of North Carolina at Chapel Hill
> 100 Europa Dr, Suite 540
> Chapel Hill, NC 27517
> V: 919.445.9670
> F: 919 445.9669
> rjf@renci.org

