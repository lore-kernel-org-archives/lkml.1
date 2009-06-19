Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbZFSWT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbZFSWT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZFSWTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:19:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52127 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZFSWTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:19:14 -0400
Date: Sat, 20 Jun 2009 00:19:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <j@w1.fi>, Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Greg KH <greg@kroah.com>, "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge
	window
Message-ID: <20090619221909.GC2229@elf.ucw.cz>
References: <20090615214735.GE23972@bombadil.infradead.org> <20090615223206.GA4966@kroah.com> <20090616004122.GC5492@tesla> <20090616021011.GF23972@bombadil.infradead.org> <20090616032034.GA17932@kroah.com> <20090616042113.GA5680@tesla> <20090616093401.GA11602@jm.kir.nu> <20090616181705.GB31506@tesla> <20090619150015.GC1389@ucw.cz> <43e72e890906191010v4b2e79a5x2c7b722b8209933c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890906191010v4b2e79a5x2c7b722b8209933c@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> +2.0.2: RC-SERIES RULES
> >> +
> >> +Rules on what kind of patches are accepted after the merge window closes.
> >> +These are patches targeted for the kernel rc-series of a kernel prior
> >> +to its release.
> >> +
> >> + - it must fix a reported regression
> >> + - it must fix a reported security hole
> >> + - it must fix a reported oops/kernel hang
> >
> > - it must fix a bug.
> 
> Well that's for certain, but there is a difference between a general
> notion of a bug and the type of bug fixes that should go in during the
> rc-series. This documentation patch highlights the difference.

Yes, and I'm trying to tell you that this documentation patch is
wrong.

Non-intrusive bugfixes _are_ welcome after -rc1.

> > I do not think the 'reported' requirement is there in -rc,
> 
> Well if its not reported how else would you find out about it during
> the rc-series? And if its something easily triggerable that should
> have been fixed earlier, not late in the rc-series.

'reported' means 'someone is hitting that bug' in that context. If you
do code inspection on drivers/foo/bar.c and find that it will hang on
may 13, 2017; then that's a bug but not "reported" one -- users are
not hitting it. Such bug may be uninteresting for -stable, but would
probably be ok for -rc.

> > and yes,
> > compile-fixes etc are welcome.
> 
> Sure, but what are these doing so late in the rc-series?

Bugs happen :-).

> > Non-intrusive bugfixes too, afaict.
> 
> It really depends on what you mean but generally no, and this is why I
> think this clarification is important.

I believe you are wrong.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
