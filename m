Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbXEVOMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbXEVOMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXEVOMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:12:18 -0400
Received: from mx10.go2.pl ([193.17.41.74]:58642 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755383AbXEVOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:12:17 -0400
Date: Tue, 22 May 2007 16:19:05 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Scott Preece <sepreece@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       "Robert P\. J\. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Documentation/memory-barriers.txt: various fixes
Message-ID: <20070522141905.GA4772@ff.dom.local>
References: <20070521135048.GB4050@ff.dom.local> <20070521094224.GB1695@ff.dom.local> <7846.1179749390@redhat.com> <12203.1179756727@redhat.com> <20070521151953.GC4050@ff.dom.local> <7b69d1470705220639w767eda81g5d4988ef09d77316@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b69d1470705220639w767eda81g5d4988ef09d77316@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 08:39:25AM -0500, Scott Preece wrote:
> On 5/21/07, Jarek Poplawski <jarkao2@o2.pl> wrote:
> >On Mon, May 21, 2007 at 03:12:07PM +0100, David Howells wrote:
> >> Jarek Poplawski <jarkao2@o2.pl> wrote:
> >>
> >> > > > -     load will be directed), a data dependency barrier would be 
> >required to
> >> > > > +     load will be directed), the data dependency barrier would be 
> >required to
> >> > >
> >> > > I think that should be "a".
> >> >
> >> > I could only guess (it's a magic to me) - so, if it doesn't matter
> >> > "A data ..." begins this paragraph...
> >>
> >> I see what you mean.  I see it as "a data dependency barrier ..." 
> >though.  That
> >> may be because I wrote the doc, however.  I wonder if "data dependency" 
> >should
> >> be hyphenated to make it clearer.  What do you think?
> >
> >Better don't ask. Now I'm far less decided, than yesterday.
> ---
> 
> "data-dependency barrier" would be better, assuming you mean a barrier
> enforcing a data dependency. If you say "data dependency barrier" you
> could also mean a "dependency barrier" implemented as a piece of data,
> for instance, like a flag value in a data stream that forces
> synchronization with another data stream.
> 

Thanks! I guess, it has to wait till tomorrow (or another patch?).

Regards,
Jarek P.
