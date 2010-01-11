Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240Ab0AKUvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0AKUvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058Ab0AKUvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:51:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:32652 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0AKUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:51:52 -0500
Date: Mon, 11 Jan 2010 23:51:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, aris@redhat.com, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20100111205149.GJ4923@lenovo>
References: <20100111191633.GT24885@redhat.com> <20100111202729.GI4923@lenovo> <20100111203356.GU24885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111203356.GU24885@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 03:33:56PM -0500, Don Zickus wrote:
> On Mon, Jan 11, 2010 at 11:27:29PM +0300, Cyrill Gorcunov wrote:
> > On Mon, Jan 11, 2010 at 02:16:33PM -0500, Don Zickus wrote:
> > > Hi Ingo,
> > > 
> > ...
> > > I was going to jump in and try to do this work.  I wanted to make sure
> > > what you were looking for here.  When you say convert nmi watchdog to perf
> > > events, I assume you mean merging over the bits of perfctr-watchdog.c to
> > > perf_events.c, modify nmi.c to just register as a normal perf event and
> > > probably cleanup the oprofile stuff to match, correct?
> > > 
> > > Cheers,
> > > Don
> > >
> > 
> > As far as I know -- converting perfctr-watchdog.c to into perfevents
> > style would be quite a desirable feature. But I still didn't manage to
> > find time for this task :( If you're interested to start this work
> > -- that would be just great!
> 
> After looking through the code I just had some questions, perhaps you have
> thought about this longer than me, what to do with the reservation code
> (just remove it I assume and let perf_events _be_ the only code that
>  handles perf events) and what to do with some of the cpu quirks as noted
> in perfctr-watchdog.c (notable some of the Intel errata for the Core
> chipsets).
> 
> Cheers,
> Don
> 

Hi Don,

well I must admit I didn't look too close to this code (if I had I would
have sent some patch for review at least :). But I was suggested to take
a look on hw_breakpoint.c (Frederic worked on it iirc, CC'ed) as an example
of perfevent'ed code. So converting to perf-event is not trivial task
and I fear I can't give any useful advice at moment since as I said I
didn't manage to find time for this task and as result didn't read code
byte-to-byte, sorry. But if I get some idea -- will share!

	-- Cyrill
