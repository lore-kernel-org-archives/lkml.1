Return-Path: <linux-kernel-owner+w=401wt.eu-S1030953AbXD1CwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030953AbXD1CwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030954AbXD1CwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:52:11 -0400
Received: from keil-draco.com ([216.193.185.50]:50440 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030953AbXD1CwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:52:09 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 22:51:57 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704271801020.9964@woody.linux-foundation.org> <200704280344.49674.rjw@sisk.pl>
In-Reply-To: <200704280344.49674.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704272251.57407.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007 21:44:48 Rafael J. Wysocki wrote:
> On Saturday, 28 April 2007 03:12, Linus Torvalds wrote:
> > On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> > > > It's doubly bad, because that idiocy has also infected s2ram. Again,
> > > > another thing that really makes no sense at all - and we do it not
> > > > just for snapshotting, but for s2ram too. Can you tell me *why*?
> > >
> > > Why we freeze tasks at all or why we freeze kernel threads?
> >
> > In many ways, "at all".
> >
> > I _do_ realize the IO request queue issues, and that we cannot actually
> > do s2ram with some devices in the middle of a DMA. So we want to be able
> > to avoid *that*, there's no question about that. And I suspect that
> > stopping user threads and then waiting for a sync is practically one of
> > the easier ways to do so.
> >
<snip>

Apparently I *CANNOT* wrap my head around this - if just because my laptop, 
running a vendor 2.6.17 kernel does s2ram perfectly, at least, it does when 
using the "Upstart" init system rather than the classical SysV init system. I 
have tried it with the classical init and the suspend isn't triggered by the 
buttons that used to do it. I didn't try 'echo ram > /sys/power/state', but I 
have a feeling that would have worked as well. I have problems with s2disk, 
but thats because I keep my swap partition small - I try to keep it at or 
around 256M when I have more than half a gig of Ram in a system. Perhaps one 
of these days I'll grab a multi-gig flash disk, set it up as a swap partition 
and try it again. (every time I've tried s2disk I wind up running out of disk 
space - and this is with nothing but X running. Any kind of progress meter 
for when the system is doing s2disk would be nice - every time I've tried it 
all I see for the nearly 2 minutes before the s2disk attempt ends is a black 
screen. I say 2 minutes because thats how long it takes for it to learn that 
there isn't enough space on the swap-partition to save the image)

DRH
