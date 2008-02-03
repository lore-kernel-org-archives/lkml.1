Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbYBCFyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbYBCFyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYBCFyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:54:10 -0500
Received: from keil-draco.com ([216.193.185.50]:50191 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYBCFyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:54:08 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt v2
Date: Sun, 3 Feb 2008 00:53:56 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Heikki Orsila <shdl@zakalwe.fi>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, ak@suse.de, m-ikeda@ds.jp.nec.com, zhongyu@18mail.cn,
       minchan.kim@gmail.com
References: <20080202144457.653482BC98@zakalwe.fi> <200802021952.37848.dhazelton@enter.net> <20080203050310.GA23824@kroah.com>
In-Reply-To: <20080203050310.GA23824@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802030053.57634.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 February 2008 00:03:10 Greg KH wrote:
> On Sat, Feb 02, 2008 at 07:52:37PM -0500, Daniel Hazelton wrote:
> > On Saturday 02 February 2008 19:22:49 Greg KH wrote:
> > > On Sat, Feb 02, 2008 at 04:44:57PM +0200, Heikki Orsila wrote:
> >
> > <snip>
> >
> > > > @@ -145,6 +145,10 @@ as small as possible, and that all potential
> > > > interfaces are tested as well as they can be (unused interfaces are
> > > > pretty much impossible to test for validity.)
> > > >
> > > > +However, changing an interface can be delicate work and it can take
> > > > +significant amount of developer effort. Therefore, an interface is
> > > > +not changed unless the change is regarded as very important by the
> > > > +developers.
> > > >
> > > >  What to do
> > > >  ----------
> > >
> > > I still don't understand why you want to add these sentances.  Why are
> > > they needed?  Are people thinking that the kernel developers just
> > > randomly change things just because they are bored and have nothing
> > > else to do at the moment?  Do people think that our changes are
> > > gratuitous?
> > >
> > > Even so, I don't think this needs to be added, we have already stated
> > > many good reasons why changing apis are necessary and good.  Do need to
> > > add another one?
> >
> > Actually, Greg, a hell of a lot of people that don't track linux kernel
> > development do think that way. And there are always going to be people
> > that think that way.
>
> So why would to more sentances trying to say "see, we really do know
> what we are doing, we aren't idiots" make things any better to these
> people?  (hint, it wouldn't...)

I know this, because I've never needed to even read the document to understand 
why the API may have to change. But there are people that are very brain 
dead - I mean *EXTREMELY* brain dead who will start drooling and not 
understand the whole point of the document without a simple statement like 
the above.

It is those people - and I've had a hell of a lot of contact with them 
(including people manning the phones in tech support departments!) - that 
wouldn't understand that the reason for the lack of a "fixed, stable API" is 
because of the various API changes that add capacity.

(Instead they'd say "But MS does it with Windows" - ignoring the fact that the 
Windows API changed when NT3.51 was released, changed again when Win95 was 
released and has changed with *EVERY* release of Windows since - to the point 
that there are programs written for Win95 that can't/won't run on an XP 
machine.)

> > As it stands the recommended paragraph does clarify that, while the
> > interfaces aren't stable, can and will change as needed, there are some
> > core interfaces that *WON'T* change without a very good reason.
>
> Again, do you think we kernel developers just randomly change core apis
> because we are bored and want something to do late at night when we
> can't sleep and are tired of playing Rock Band?

No, I don't. Never have. But the fact is that there *ARE* people who do think 
that way. I've had a hell of a lot of contact with them. When I talk to 
people about using Linux (locally - I get "pinged" by someone every time I 
walk into a store to buy something, anymore) there is at least one person who 
complains that they can't run Linux because required hardware X isn't 
supported, and the manufacturer says its because there isn't a stable API to 
write the driver against. (though it's usually a lot coarser and less 
technical - I'm sure you understand)

> > Having such a public statement that anyone can see and people can
> > point to is another weapon to help people fight the FUD that exists
> > around Linux.
>
> The whole article explains why apis are change for very good reasons
> (evolution of hardware, security, we now know better, etc.)  That's the
> whole point of the document...

Yes, it does, but you are making the mistake I used to make all the time and 
assuming that most people are going to actually have the ability to take the 
information in the document and comprehend that any *ONE* of the reasons that 
a stable API is bad is enough to not have one.

Having such a paragraph to point to - or just having it there when those 
dead-brained people actually find and read the document - will definitely be 
a good thing.

...

And now that I've re-iterated and explained the rather poor opinion I have of 
most people in the world and how it applies to this situation, I'm going to 
shut up and not say another word about this.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
