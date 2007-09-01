Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbXIAHNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbXIAHNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 03:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXIAHNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 03:13:23 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59263 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXIAHNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 03:13:22 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 03:02:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Mitchell Erblich <erblichs@earthlink.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <Pine.LNX.4.64.0709010835380.11617@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0709010248140.21492@localhost.localdomain>
References: <000501c7ec26$c2b06140$6501a8c0@earthlink.net>
 <Pine.LNX.4.64.0708312128060.7060@localhost.localdomain>
 <Pine.LNX.4.64.0709010835380.11617@fbirervta.pbzchgretzou.qr>
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

On Sat, 1 Sep 2007, Jan Engelhardt wrote:

>
> On Aug 31 2007 21:33, Robert P. J. Day wrote:
> >
> >perhaps.  all i'm begging for is that these attributes be defined
> >cleanly and clearly, and following those two conditions i suggested
> >earlier:
> >
> >1) all attributes are orthogonal to one another, and
>
> This "orthogonal" argument is reserved for the cdrecord maintainer;
>
> I cannot figure out what you mean by orthogonal. If A is orthogonal
> to B and B is orthogonal to C, then A is parallel to C. If there are
> more objects than dimensions, at least one pair of them is not
> orthogonal. That is what orthogonal means to me ;-)

  you're being too literal in a purely mathematical sense.
"orthogonality" has a much more general definition in the context of
computer science -- see here:

http://dict.die.net/orthogonal/

"The term is used loosely to mean mutually independent or well
separated.  It is used to describe sets of primitives or capabilities
that, like linearly independent vectors in geometry, span the entire
"capability space" and are in some sense non-overlapping or mutually
independent."

and here:

"Computer science

"Orthogonality is a system design property facilitating feasibility
and compactness of complex designs. Orthogonality guarantees that
modifying the technical effect produced by a component of a system
neither creates nor propagates side effects to other components of the
system."

  in the case of Kconfig "attributes", a set of orthogonal attributes
might be a variable's maturity, its colour and its flavour (i'm just
making those last two up, of course).  and each of those clearly
orthogonal attributes is allowed to have at most one value, and that
value is entirely independent of what the value is of any of the
*other* attributes for that kernel feature.

  i'm harping on this because it seems to me that lumping together
values such as experimental, deprecated, obsolete and broken in a
single attribute is creating a dangerously ill-defined attribute
that's trying to do two things at once -- identify both a variable's
"age", if you will, and its current code quality.  and i'm simply
arguing that those are two different things and, if you do that, it
would prevent you from saying that some kernel feature is both
experimental *and* broken.

  note:  the above is assuming that an attribute is *defined* as being
allowed to have at most one possible value at a time, as in deprecated
*or* obsolete, and never deprecated *and* obsolete.  if you go down
that second road, very bad things await you.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
