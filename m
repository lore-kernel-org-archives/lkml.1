Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXH1SJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXH1SJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXH1SJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:09:03 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35821 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbXH1SJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:09:01 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 28 Aug 2007 13:58:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ok to kill "ether=" kernel parm?
In-Reply-To: <46D45A02.6010306@zytor.com>
Message-ID: <Pine.LNX.4.64.0708281347390.20783@localhost.localdomain>
References: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain>
 <46D45111.2040600@zytor.com> <Pine.LNX.4.64.0708281300030.18151@localhost.localdomain>
 <46D45A02.6010306@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007, H. Peter Anvin wrote:

> Robert P. J. Day wrote:
> > On Tue, 28 Aug 2007, H. Peter Anvin wrote:
> >
> >> Robert P. J. Day wrote:
> >>>   given that "ether=" has been officially obsolete since 2.6.18
> >>> (replaced by "netdev="), is there any reason to keep it around?
> >>> or can it be blasted?
> >> That sounds like way too short of a timeline for breaking people's
> >> working boot setup.  For a lot of people, 2.6.18->current is going
> >> to be a single step.
> >
> > actually, now that i look more closely at the code browser at
> > lxr.linux.no, "ether=" has been listed as "obsolete" since *at least*
> > 2.6.10.  not to sound unsympathetic but anyone who tries to jump from
> > 2.6.10 to 2.6.24 in one step deserves what they get.  :-)
> >
> > ok, that was cruel, but you see my point, right?
>
> Yes, and I think it's quite pointless.
>
> The thing is, people's boot setups have probably been that way since
> *long* before 2.6.9.  They continue to work, as they should, so they
> aren't changed.  This is why we very rarely break boot interfaces
> (and this is a user-visible interface you're talking about); we're
> still supporting interfaces that have been obsolete *SINCE BEFORE
> 1.0 WAS RELEASED.*
>
> What's the upside of changing?  What's the downside?  The upside is
> so infinitesimal that that leaving "ether=" in indefinitely seems
> like a good move to me.

i've never found these "well, it's not hurting anything" arguments
terribly compelling.  if that's the case, why remove *anything* from
the kernel?  why obsolete *anything*?  but that's not my actual point.

why continue to support two different ways to do the same thing?  in
situations like that, i can imagine the following (admittedly
hypothetical) conversation between old-timer and young geek:

OT:  "so, what the problem?"
YG:  "i can't get my network module to work properly.  i use modprobe
with netdev= and ..."
OT:  "huh?  netdev?  why don't you use ether=?"
YG:  "what's ether=?"
OT:  "what's netdev=?"

followed by a confused conversation as to whether they really
represent the same thing, or maybe not, or maybe mostly.

if you want to keep the old way of doing it, that's cool.  but it
would be nice if, in cases like that, a clear choice was made.  if you
want to keep the old way, then *keep* it.  make it clear that it's
official, and supported.

or if you're going to delete it, then *delete* it.  but let's not keep
doing this half-way, half-assed measure of tagging something as
obsolete, then just letting it hang out in the kernel forever.  either
keep it, or delete it, and stop being so wishy-washy and doing things
halfway.

and, finally, while "there's more than one way to do it" may be a
terrific perl philosophy, i don't think much of it as a kernel coding
standard.

anyway, my $0.02, for what little it's worth.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
