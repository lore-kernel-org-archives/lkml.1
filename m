Return-Path: <linux-kernel-owner+w=401wt.eu-S1751561AbYBCFFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbYBCFFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYBCFFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:05:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYBCFFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:05:31 -0500
Date: Sat, 2 Feb 2008 21:03:10 -0800
From: Greg KH <greg@kroah.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Heikki Orsila <shdl@zakalwe.fi>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, ak@suse.de, m-ikeda@ds.jp.nec.com, zhongyu@18mail.cn,
       minchan.kim@gmail.com
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt v2
Message-ID: <20080203050310.GA23824@kroah.com>
References: <20080202144457.653482BC98@zakalwe.fi> <20080203002249.GB3453@kroah.com> <200802021952.37848.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802021952.37848.dhazelton@enter.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 07:52:37PM -0500, Daniel Hazelton wrote:
> On Saturday 02 February 2008 19:22:49 Greg KH wrote:
> > On Sat, Feb 02, 2008 at 04:44:57PM +0200, Heikki Orsila wrote:
> <snip>
> > > @@ -145,6 +145,10 @@ as small as possible, and that all potential
> > > interfaces are tested as well as they can be (unused interfaces are
> > > pretty much impossible to test for validity.)
> > >
> > > +However, changing an interface can be delicate work and it can take
> > > +significant amount of developer effort. Therefore, an interface is
> > > +not changed unless the change is regarded as very important by the
> > > +developers.
> > >
> > >  What to do
> > >  ----------
> >
> > I still don't understand why you want to add these sentances.  Why are
> > they needed?  Are people thinking that the kernel developers just
> > randomly change things just because they are bored and have nothing else
> > to do at the moment?  Do people think that our changes are gratuitous?
> >
> > Even so, I don't think this needs to be added, we have already stated
> > many good reasons why changing apis are necessary and good.  Do need to
> > add another one?
> >
> 
> Actually, Greg, a hell of a lot of people that don't track linux kernel 
> development do think that way. And there are always going to be people that 
> think that way.

So why would to more sentances trying to say "see, we really do know
what we are doing, we aren't idiots" make things any better to these
people?  (hint, it wouldn't...)

> As it stands the recommended paragraph does clarify that, while the interfaces 
> aren't stable, can and will change as needed, there are some core interfaces 
> that *WON'T* change without a very good reason.

Again, do you think we kernel developers just randomly change core apis
because we are bored and want something to do late at night when we
can't sleep and are tired of playing Rock Band?

> Having such a public statement that anyone can see and people can
> point to is another weapon to help people fight the FUD that exists
> around Linux.

The whole article explains why apis are change for very good reasons
(evolution of hardware, security, we now know better, etc.)  That's the
whole point of the document...

thanks,

greg k-h
