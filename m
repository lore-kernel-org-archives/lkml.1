Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZISFkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZISFkB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 01:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZISFkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 01:40:00 -0400
Received: from james.oetiker.ch ([213.144.138.195]:36487 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZISFj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 01:39:59 -0400
Date: Sat, 19 Sep 2009 07:40:01 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: david@lang.hm
cc: linux-kernel@vger.kernel.org
Subject: Re: announce: fsopbench - filesystem operations benchmark
In-Reply-To: <alpine.DEB.2.00.0909181055130.24556@asgard.lang.hm>
Message-ID: <alpine.DEB.2.00.0909190736220.4635@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909180901550.6162@sebohet.brgvxre.pu> <alpine.DEB.2.00.0909181015090.24556@asgard.lang.hm> <alpine.DEB.2.00.0909181932540.6162@sebohet.brgvxre.pu> <alpine.DEB.2.00.0909181055130.24556@asgard.lang.hm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday david@lang.hm wrote:

> On Fri, 18 Sep 2009, Tobi Oetiker wrote:
>
> > Hi David,
> >
> > Today david@lang.hm wrote:
> >
> > > On Fri, 18 Sep 2009, Tobias Oetiker wrote:
> > >
> > > >
> > > >   http://oss.oetiker.ch/optools/wiki/fsopbench
> > > >
> > > > It shows similar results on all configurations I have tested.
> > > > In the example below you see:
> > > >
> > > > * lstat: 10 times slower
> > > > * reading the first byte of a file: 80 times slower
> > > > * reading a directory entry: 16 times slower
> > > > * read rate: 40 times lower
> > >
> > > lower and slower than what?
> >
> > reading on an idle system vs reading on a system where writer
> > processees are active ...
>
> as a user I would expect that a disk that is busy being written to will be
> slower to read from.
>
> what would you expect to happen in this situation?

sure, the question is how much slower ... 40 times slower speed and
80 times slower response time is a bit much I would say ...

half the speed and half the response time would be what I would
expect ... but then thats just me ...

cheers
tobi
-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
