Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbXFOFIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbXFOFIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbXFOFIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:08:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34269 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXFOFIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:08:44 -0400
Date: Fri, 15 Jun 2007 06:08:30 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Chris Friesen <cfriesen@nortel.com>, Paul Mundt <lethal@linux-sh.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615050830.GT21478@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <4671B734.1040401@nortel.com> <orhcpa88b0.fsf@oliva.athome.lsd.ic.unicamp.br> <200706142155.34298.dhazelton@enter.net> <or4pl96gvr.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706142034240.14121@woody.linux-foundation.org> <ord4zx4zwm.fsf@oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ord4zx4zwm.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 01:14:49AM -0300, Alexandre Oliva wrote:
> I'm not trying to impose anything.  I'm not pushing anything.  I'm
> defending the GPLv3 from accusations that it's departing from the GPL
> spirit, and I'm trying to find out in what way Tivoization promotes
> the goals you perceive as good for Linux, that make GPLv2
> advantageous.  So far, you haven't given any single reason about this.
> You talked about tit-for-tat, you said anti-Tivoization in GPLv3 was
> bad, but you don't connect the dots.  Forgive if I get the impression
> that you're just fooling yourself, and misguiding a *lot* of people
> out there in the process.

Give.  Me.  A.  Break.

Section 6 is inherently broken.  It tries to gerrymander the "bad"
cases and ends up with a huge mess.  Definition of user device is
arbitrary and reeks with discrimination against the field of use.
Trying to be more explicit about installation instructions walks
straight into a minefield:
	* is it enough to give some installation methods?  If so,
should they be as cheap as the rest?  As efficient as the rest in
some sense?  Representative in some sense?  The same as what
manufacturer ever uses?
	* if all installation methods should be given, where does
one stop?  Should one describe unsupported ones?  All of them?
Is that a violation of license to omit some?  How does one prove
that omission hadn't been malicious violation in face of complaint?

Trying to be explicit enough to get a rope on the TiVo neck ends
up with not just clumsy rules; it opens a can of worms worse than
what we have in matching part of v2.

It looks like trying to be tight enough to be sure to catch the cases FSF
doesn't like and trying to avoid getting the stuff that really shouldn't
be caught.  And looks like these requirements conflict.

So in the end you get an ugliness that satisfies neither those who think
that TiVo case is not a problem nor those who agree that it is a problem
and consider v2 sufficient in that area.

And BTW, you've been told just that about an hour before you've sent that
mail.  I don't mind repeating that on l-k, but please don't pretend to be
unaware of the problems in that area.  I've no idea which problems Linus
has with that turd, but there's certainly enough in there.
