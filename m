Return-Path: <linux-kernel-owner+w=401wt.eu-S1764775AbXEUPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764775AbXEUPNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760519AbXEUPNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:13:11 -0400
Received: from mx2.go2.pl ([193.17.41.42]:56283 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759548AbXEUPNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:13:09 -0400
Date: Mon, 21 May 2007 17:19:53 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Robert P\. J\. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Documentation/memory-barriers.txt: various fixes
Message-ID: <20070521151953.GC4050@ff.dom.local>
References: <20070521135048.GB4050@ff.dom.local> <20070521094224.GB1695@ff.dom.local> <7846.1179749390@redhat.com> <12203.1179756727@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12203.1179756727@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 03:12:07PM +0100, David Howells wrote:
> Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > > > -     load will be directed), a data dependency barrier would be required to
> > > > +     load will be directed), the data dependency barrier would be required to
> > > 
> > > I think that should be "a".
> > 
> > I could only guess (it's a magic to me) - so, if it doesn't matter
> > "A data ..." begins this paragraph...
> 
> I see what you mean.  I see it as "a data dependency barrier ..." though.  That
> may be because I wrote the doc, however.  I wonder if "data dependency" should
> be hyphenated to make it clearer.  What do you think?

Better don't ask. Now I'm far less decided, than yesterday.

> 
> > > > -But! CPU 2's perception of P may be updated _before_ its perception of B, thus
> > > > +But (!) CPU 2's perception of P may be updated _before_ its perception of B,
> > > 
> > > That's a matter of taste, I think.  However, if my solution is chosen, there
> > > should be an extra space after "But!".  Hmmm... actually, I think you're wrong
> > > because the "But!" isn't quite part of the following sentence.
> > 
> > It seems logical, but it's also quite unusual, so the reader (only me?) 
> > could be more interested in orthography than in the subject...
> 
> I'm emphasising a really odd feature - and it's quite an important emphasis -
> so I felt that this sort of construct would interrupt the reader's normal
> scanning of the text and make it clearer that this was something to take
> careful note of.
> 
> It's a really horrible gotcha you have to be careful of.  It's sort of against
> how you'd think things would work.
> 
> > > >  This sequence of events is committed to the memory coherence system in an order
> > > >  that the rest of the system might perceive as the unordered set of { STORE A,
> > > > -STORE B, STORE C } all occurring before the unordered set of { STORE D, STORE E
> > > > -}:
> > > > +STORE B, STORE C } - all occurring before the unordered set of { STORE D, STORE
> > > > +E }:
> > > 
> > > Hmmm.  I don't think that a dash is correct here.  I think it changes the
> > > meaning, by changing the way the elements are grouped.
> > 
> > Sure. But on the other hand such long questions probably are broken
> > somewhere with pauses when reading...
> 
> I know what you mean, but it's tricky because of the subject.  Maybe a colon
> after the "might perceive as"?
> 
> > > I think this changes the meaning to one I don't want.  But I'm not entirely
> > > sure.  In a way the two concepts "update of perception" and "update perception"
> > > are different things.  I think this can be argued either way.
> > 
> > So, what can I say...
> 
> How about: "Aargh!  Nonono!  The English language is completely horrible!"?

You should talk to some English-speaking person who learns Polish.
It's hard to believe, but there are such people. (They could be 
sometimes seen in our TV - it's a real stunt!)

I prefer to fix C too, and I'm far from beeing the right person
to do this (I don't care much about "unlogical" languages), but
I like the style of your manual, and I think it's too good to
leave small spots here.


I think, there is some time till tomorrow (or even leave something
for another patch).

BTW, did I write about resending "yesterday"?
This time saving really works...

Cheers,
Jarek P.
