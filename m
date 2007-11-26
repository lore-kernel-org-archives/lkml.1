Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbXKZPOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbXKZPOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbXKZPOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:14:40 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:58092 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXKZPOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:14:39 -0500
Date: Mon, 26 Nov 2007 10:12:37 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Ray Lee <ray-lk@madrabbit.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can support for "rpm"-based package building just be dropped?
In-Reply-To: <alpine.LFD.0.9999.0711261007370.22202@localhost.localdomain>
Message-ID: <alpine.LFD.0.9999.0711261010480.22378@localhost.localdomain>
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain> <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com> <alpine.LFD.0.9999.0711261007370.22202@localhost.localdomain>
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
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Robert P. J. Day wrote:

> On Mon, 26 Nov 2007, Ray Lee wrote:
>
> > On Nov 26, 2007 12:54 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > >   on current systems, "rpm" no longer has build capability and will
> > > fail thusly:
> > >
> > > rpm --target i386 -ta ../kernel-2.6.24rc3g2ffbb837dirty.tar.gz
> > > --target: unknown option
> > >
> > >   so it would make more sense to just require "rpmbuild" on the
> > > machine, would it not?
> >
> > Only on current machines. You'd break building kernel RPMs on older
> > systems that don't have rpmbuild installed. So the change wouldn't
> > fix anything, and would break some non-zero number of setups that
> > are currently working, making the change a guaranteed net loss.
> >
> > A patch that added version checks against rpm and whinged
> > appropriately about needing rpmbuild would likely be accepted,
> > though.
>
> yes, i suspect that's the right answer.
>
> rday

BTW, is there someone who knows what the relevant version is of "rpm"
that stopped incorporating the packaging functionality?  i'm a bit
swamped today but if someone wants to whip up a patch and get it in
before the next major release, that would be useful, i would think.

in short, can someone else handle this?  :-)

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
