Return-Path: <linux-kernel-owner+w=401wt.eu-S1763459AbXHLH0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459AbXHLH0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 03:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXHLHZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 03:25:57 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:40627 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbXHLHZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 03:25:56 -0400
Date: Sun, 12 Aug 2007 16:24:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
Message-ID: <20070812072455.GB22250@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Rene Herman <rene.herman@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com> <46BE621E.9090509@gmail.com> <9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 03:52:48AM +0200, Jesper Juhl wrote:
> On 12/08/07, Rene Herman <rene.herman@gmail.com> wrote:
> > On 08/12/2007 03:08 AM, Jesper Juhl wrote:
> >
> > > This may be a little off topic, but I think it's interresting enough
> > > to warrent a single mail.
> > >
> > > I just saw a news article (http://www.theinquirer.net/?article=41610)
> > > about a 3 Socket Opteron motherboard and couldn't help but wonder if
> > > we are prepared to deal with such a beast, so I thought I'd inform
> > > everyone :-)
> > >
> > > I'm guessing equipping such a board with 3 single core CPU's could
> > > show up some interresting corner cases in schedular code and
> > > elsewhere, I'll bet we have some assumptions somewhere about
> > > nr_of_cpus being an even number...
> >
> > I would hope the N=1 case will have flushed out enough of those... :-|
> >
> Hehe, true, but I was thinking more of nr_of_cpus is an odd number > 1. :-)
> Just thinking of having to divide things by 3 makes me worry ;-)  ...
> 
These sorts of cases happen frequently enough today as it is in an
operational capacity, CPU hotplug will have the sytem in such states
already on systems with an even number. This is generally why things like
the online map and corresponding cpumasks are what counts, while the
total number of possible CPUs can be a drastically different number.
