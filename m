Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYBIQv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYBIQv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYBIQuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:50:55 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:40986 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYBIQux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:50:53 -0500
Date: Sat, 9 Feb 2008 17:50:51 +0100
From: Christer Weinigel <christer@weinigel.se>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "=?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch" <hjk@linutronix.de>,
       "David Newall" <davidn@davidnewall.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Diego Zuccato" <diego@otello.alma.unibo.it>,
       "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080209175051.59715a17@weinigel.se>
In-Reply-To: <84144f020802090741k6fe3324cu99d70f13d9fd54ec@mail.gmail.com>
References: <20080125180232.GA4613@kroah.com>
	<20080206213449.6614efea@weinigel.se>
	<20080206215442.63c94cf3@dilbert.local>
	<47AB056E.70802@davidnewall.com>
	<20080207150612.21ba60df@dilbert.local>
	<47AB163C.5070107@davidnewall.com>
	<20080207171322.40eb7c95@dilbert.local>
	<47AB36D2.5050602@davidnewall.com>
	<20080207184939.17030887@dilbert.local>
	<20080209161322.6ccd9d4d@weinigel.se>
	<84144f020802090741k6fe3324cu99d70f13d9fd54ec@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 17:41:00 +0200
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Feb 9, 2008 5:13 PM, Christer Weinigel <christer@weinigel.se>
> wrote:
> > But lets say that the b-tree code uses Linux-only primitives such as
> > kmalloc or spinlocks, and that I wrote the code specifically for the
> > Linux kernel, does that make it into a derivative work?
> >
> > What if I do a trivial replace of the kmalloc calls with malloc and
> > the spinlock calls with pthread locks instead, has my code been
> > forever tainted by being written for Linux so that I can't do that
> > anymore? What if I go the other way and write my code using the
> > posix functions to begin with and do the equally trivial replace of
> > malloc with kmalloc?
> 
> As the copyright owner, you're free to distribute the original parts
> as you wish as long as it doesn't contain anything that is derived
> work. 

Ok good.

> So, when you remove those kmalloc/spin_lock calls, you're
> _obviously not_ tainted. But that doesn't mean you're free to
> distribute it when it _does_ contain derived work. 

So it magically becomes a derived work if I do a:

#define malloc(n) kmalloc(n, 0)
#define pthread_mutex_lock(l) spin_lock(l)

at the beginning of the file?  My guess is that it is much to trivial
to be considered a creative expression and thus would not be covered by
copyright.  Meaning it would not be a derivative work.

> Besides, a device
> driver can't even be compared to something as trivial as b-tree
> implementation that uses kmalloc/spin_lock in terms of "is it derived
> work or not."

A device driver isn't that hard either.  I can write a device driver
with a hand tied behind my back, to write a good balancing tree, I'd
have to spend a lot more time reading up on algorithms.  So "trivial" is
a matter of background.

And once again, I don't believe API copyrights are valid, because in
that case Wine would have been sued out of the water a long time ago.

> Thanks for the straw man, though!

*sigh* Now you're just being insulting.  

  /Christer
