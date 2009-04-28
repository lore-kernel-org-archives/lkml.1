Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZD1Kch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZD1Kch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZD1KcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:32:25 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:52527 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172AbZD1KcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:32:21 -0400
Date: Tue, 28 Apr 2009 06:31:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jiri Kosina <jkosina@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how to properly post/disseminate kernel cleanup/janitorial
 possibilities?
In-Reply-To: <alpine.LNX.2.00.0904281024150.5012@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0904280619590.16989@localhost.localdomain>
References: <alpine.LFD.2.00.0904271637470.4906@localhost.localdomain> <20090427222035.GA2700@cmpxchg.org> <alpine.LNX.2.00.0904281024150.5012@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Jiri Kosina wrote:

> On Tue, 28 Apr 2009, Johannes Weiner wrote:
>
> > > long story short, i have a *pile* of scripts and sub-scripts i'm
> > > happy to run and post the results of since it takes practically
> > > zero time on my part, i'm just open to what folks think is the
> > > most productive way to do that, and also for any other scanning
> > > i can add since, by now, any other patterns to scan for would
> > > just represent adding a line or two to a script.
> > >  thoughts?

> > Yes.  I wonder why you take the time to generate the output and
> > email it but then stop there instead of just sending patches?
> >
> > grep -A5 TRIVIAL MAINTAINERS
> >
> > Perhaps Jiri can pick up some of the patches that remove stale
> > config symbols, correct typos etc.
>
> Absolutely. I'll happily apply anything trivial enough (typo fixes,
> removal of obviously unused symbols/config options, etc).

  the *problem* is that, sometimes, it's not obvious.  as in, when a
Kconfig file has a pile of unused config options but it turns out that
those were added for future consideration to match up with code that
hasn't been added yet and the subsystem maintainer knows about it but
wants it to stay (IMHO, a really bad idea -- adding kernel features in
incomplete pieces, but whatever).

  in any event, my only point is that, sometimes, only the subsystem
maintainer really knows how to resolve something that *looks*
trivially resolvable or removable.  IIRC, a simple observation on the
unused symbols HAVE_READQ and HAVE_WRITEQ sparked a lengthy discussion
that would never have happened if the "obvious" deletion on those
symbols had been done.

  the right thing to do is not always obvious.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
