Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbXEUOMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbXEUOMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 10:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXEUOMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 10:12:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbXEUOMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 10:12:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070521135048.GB4050@ff.dom.local>
References: <20070521135048.GB4050@ff.dom.local> <20070521094224.GB1695@ff.dom.local> <7846.1179749390@redhat.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org, "Robert P\. J\. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Documentation/memory-barriers.txt: various fixes
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Mon, 21 May 2007 15:12:07 +0100
Message-ID: <12203.1179756727@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski <jarkao2@o2.pl> wrote:

> > > -     load will be directed), a data dependency barrier would be required to
> > > +     load will be directed), the data dependency barrier would be required to
> > 
> > I think that should be "a".
> 
> I could only guess (it's a magic to me) - so, if it doesn't matter
> "A data ..." begins this paragraph...

I see what you mean.  I see it as "a data dependency barrier ..." though.  That
may be because I wrote the doc, however.  I wonder if "data dependency" should
be hyphenated to make it clearer.  What do you think?

> > > -But! CPU 2's perception of P may be updated _before_ its perception of B, thus
> > > +But (!) CPU 2's perception of P may be updated _before_ its perception of B,
> > 
> > That's a matter of taste, I think.  However, if my solution is chosen, there
> > should be an extra space after "But!".  Hmmm... actually, I think you're wrong
> > because the "But!" isn't quite part of the following sentence.
> 
> It seems logical, but it's also quite unusual, so the reader (only me?) 
> could be more interested in orthography than in the subject...

I'm emphasising a really odd feature - and it's quite an important emphasis -
so I felt that this sort of construct would interrupt the reader's normal
scanning of the text and make it clearer that this was something to take
careful note of.

It's a really horrible gotcha you have to be careful of.  It's sort of against
how you'd think things would work.

> > >  This sequence of events is committed to the memory coherence system in an order
> > >  that the rest of the system might perceive as the unordered set of { STORE A,
> > > -STORE B, STORE C } all occurring before the unordered set of { STORE D, STORE E
> > > -}:
> > > +STORE B, STORE C } - all occurring before the unordered set of { STORE D, STORE
> > > +E }:
> > 
> > Hmmm.  I don't think that a dash is correct here.  I think it changes the
> > meaning, by changing the way the elements are grouped.
> 
> Sure. But on the other hand such long questions probably are broken
> somewhere with pauses when reading...

I know what you mean, but it's tricky because of the subject.  Maybe a colon
after the "might perceive as"?

> > I think this changes the meaning to one I don't want.  But I'm not entirely
> > sure.  In a way the two concepts "update of perception" and "update perception"
> > are different things.  I think this can be argued either way.
> 
> So, what can I say...

How about: "Aargh!  Nonono!  The English language is completely horrible!"?


David
