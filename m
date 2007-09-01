Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXIABxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXIABxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXIABoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:44:46 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:51987 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbXIABon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:44:43 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 31 Aug 2007 21:33:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Mitchell Erblich <erblichs@earthlink.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <000501c7ec26$c2b06140$6501a8c0@earthlink.net>
Message-ID: <Pine.LNX.4.64.0708312128060.7060@localhost.localdomain>
References: <000501c7ec26$c2b06140$6501a8c0@earthlink.net>
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

On Fri, 31 Aug 2007, Mitchell Erblich wrote:

> "Robert P. J. Day" wrote:
> >
> >   at the risk of driving everyone here totally bonkers, i'm going to
> > take one last shot at explaining what i was thinking of when i first
> > proposed this whole "maturity level" thing.  and, just so you know,
> > the major reason i'm so cranked up about this is that i'm feeling just
> > a little territorial -- i was the one who first started nagging people
> > to consider this idea, so i'm a little edgy when i see folks finally
> > giving it some serious thought but appearing to get ready to implement
> > it entirely incorrectly in a way that's going to ruin it irreparably
> > and make it utterly useless.
> >
> >   this isn't just about defining a single feature called "maturity".
> > it's about defining a general mechanism so that you can add entirely
> > new (what i call) "attributes" to kernel features.  one attribute
> > could be "maturity", which could take one of a number of possible
> > values.  another could be "status", with the same restrictions.
> > heck, you could define the attribute "colour", and decide that various
> > kernel features could be labelled as (at most) one of "red", "green"
> > and "chartreuse."  that's what i mean by an "attribute", and
> > attributes would have two critical and non-negotiable properties:
> <<< snip>>>>
> >
> >   but i hope i've flogged this thoroughly to the point where people
> > can see what i'm driving at.  once you see (as in simon's patch) how
> > to add the first attribute, it's trivial to simply duplicate that code
> > to add as many more as you want.
> >
> > rday
> >
> > --
> > ========================================================================
> > Robert P. J. Day
> > Linux Consulting, Training and Annoying Kernel Pedantry
> > Waterloo, Ontario, CANADA
> >
> > http://crashcourse.ca
> > ========================================================================
> Robert Day,
>
>         If I can interpret what you are asking about and changing it abit.
>
>         Don't you think that Maturity can be defined ALSO, as the
>        number of known bugs and their priority / serverity against a
>        architecture dependent or independent item?
>
>        Would this suffice and wouldn't it be easier to maintain?
>
>        Mitchell Erblich

perhaps.  all i'm begging for is that these attributes be defined
cleanly and clearly, and following those two conditions i suggested
earlier:

1) all attributes are orthogonal to one another, and
2) values within an attribute are mutually exclusive

if you violate either of those conditions, i think you're going to
find it very difficult to design sane Kconfig entries around them.
if you don't believe me, give it a try.

rday

p.s.  rather than saying that maturity can be defined "also" in
another way, you should say that it can be defined "instead" in
another way.  i don't want to think what it might mean to define
something like maturity in two different ways simultaneously, if
that's what you were suggesting.  that just makes my brain hurt.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
