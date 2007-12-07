Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXLGHlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXLGHlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 02:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXLGHlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 02:41:05 -0500
Received: from mx1.riseup.net ([204.13.164.18]:43021 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXLGHlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 02:41:01 -0500
Date: Fri, 7 Dec 2007 08:40:52 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, jonathan@jonmasters.org
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
Message-ID: <20071207074052.GF480@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Remy Bohmer <linux@bohmer.net>, Daniel Walker <dwalker@mvista.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	jonathan@jonmasters.org
References: <20071206021857.826386004@mvista.com> <20071206021909.131993721@mvista.com> <20071206102334.GE17299@elte.hu> <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com> <20071206200542.GE480@traven> <3efb10970712061212i7198f53eo5a8d8774465b3dde@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970712061212i7198f53eo5a8d8774465b3dde@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, Dec 06, 2007 at 09:12:05PM +0100 Remy Bohmer ha dit:

> Which do you have exactly on your list? (good to know, it prevents
> double work...)

it isn't really an elaborated list, until now i greped for certain
semaphore usages, had a look at the code and converted it if
necessary. at the moment i'm having a look at usb drivers.

> 2007/12/6, Matthias Kaehlcke <matthias.kaehlcke@gmail.com>:
> > El Thu, Dec 06, 2007 at 08:34:06AM -0800 Daniel Walker ha dit:
> >
> > > On Thu, 2007-12-06 at 11:23 +0100, Ingo Molnar wrote:
> > > > * Daniel Walker <dwalker@mvista.com> wrote:
> > > >
> > > > > The port_mutex is actually a semaphore, so easily converted to a
> > > > > struct mutex.
> > > > >
> > > > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > > >
> > > > Acked-by: Ingo Molnar <mingo@elte.hu>
> > > >
> > > > cool. How far away are we from being able to remove all the semaphore
> > > > code? :-)
> > >
> > > I wish my 7 patches made a dent, but it's hasn't done much. ;(
> > >
> > > I would guess at least a week just to mop up the relatively easy ones..
> > > I've got 12 in my queue, and there still ~50 hopefully trivial ones
> > > still to be looked at.. Then another ~30 more difficult ones (that use
> > > init_MUTEX_LOCKED, or sema_init with 0 instead of 1) ..
> >
> > I've also more patches of this type on my list, though i work in a
> > slower pace
> >
> >
> >              You must have a plan. If you don't have a plan,
> >                you'll become part of somebody else's plan
> >                                                                  .''`.
> >     using free software / Debian GNU/Linux | http://debian.org  : :'  :
> >                                                                 `. `'`
> > gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
> >

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
