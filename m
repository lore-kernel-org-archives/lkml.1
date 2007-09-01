Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbXIABel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbXIABel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXIABec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:34:32 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:51782 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbXIABec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:34:32 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 31 Aug 2007 21:23:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <46D89800.8080701@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <46D89800.8080701@s5r6.in-berlin.de>
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

On Sat, 1 Sep 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> ...
> > attributes would have two critical and non-negotiable properties:
> >
> > 1) they would be entirely orthogonal to one another, and
> > 2) they can be assigned at most one of a pre-defined set of values
>
> If they are fully orthogonal to another, then they are also
> nonexclusive.  You want them to be mutual exclusive, not orthogonal.

*attributes* would be orthogonal to one another -- the values *within*
an attribute would be mutually exclusive.  maybe i phrased that badly
the first time.  so a feature could have both a maturity *and* a
status (just using my hypothetical attributes here), but no feature
can have an attribute with more than one value.

ergo, you can have a maturity of, say, deprecated, *and* a status of,
say, broken.  is that what you meant?  it's what i was getting at.

> >   experimental -> normal (stable) -> deprecated -> obsolete
> >
> >   it's a natural progression and, at any point, a feature cannot
> > possibly have more than one maturity value.  it would be as absurd
> > as saying that someone was a teenager *and* was a twenty-something
> > at the same time.
>
> Keep in mind though that 'experimental', in the context of Linux
> kernel features, has nothing to do with the age of a feature.

your point is well taken.  i'm just trying to draw a clear distinction
between what i see as the natural chronological progression of a
feature, and its actual level of functionality, which i'm firmly
convinced represent two *very* different pieces of information.
something which is marked as obsolete can still be known to be
functioning perfectly well, while something which is still bleeding
edge might be well known to be broken as well.

with regard to "experimental", what attribute would you imagine it
would be a possible value for, and what other possible values might
that attribute have as opposed to experimental?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
