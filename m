Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbXGDQxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbXGDQxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXGDQxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:53:30 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56936 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbXGDQxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:53:30 -0400
Date: Wed, 4 Jul 2007 09:53:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Uli Luckas <u.luckas@road.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
Message-ID: <20070704165313.GC4306@sequoia.sous-sol.org>
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com> <200707041056.53992.u.luckas@road.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707041056.53992.u.luckas@road.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Uli Luckas (u.luckas@road.de) wrote:
> On Tuesday, 3. July 2007, Chuck Ebbert wrote:
> > On 07/03/2007 03:28 PM, Chris Friesen wrote:
> > > Arne Georg Gleditsch wrote:
> > >> An interesting exercise might be to
> > >> code up a small program to call adjtimex with timex.status |= STA_INS,
> > >> to see if this can trigger the problem.
> > >
> > > Setting the date to just before midnight June 30 UTC and then running
> > > the following as root triggered the crash on a modified 2.6.10.  Anyone
> > > see anything wrong with the code below, or is this a valid indication of
> > > a bug in the leap second code?
> >
> > Fixed:
> > http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=comm
> >itdiff;h=746976a301ac9c9aa10d7d42454f8d6cdad8ff2b
> >
> Hi Chris,
> does that qualify for inclusion into 2.6.21.6?

Yes, it has already been sent to -stable.

thanks,
-chris
