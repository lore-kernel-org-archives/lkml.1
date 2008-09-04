Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYIDABY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYIDABY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYIDABL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:01:11 -0400
Received: from mail.atheros.com ([12.36.123.2]:39885 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYIDABK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:01:10 -0400
Date: Wed, 3 Sep 2008 17:01:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: David Miller <davem@davemloft.net>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "tomasw@gmail.com" <tomasw@gmail.com>,
       "yi.zhu@intel.com" <yi.zhu@intel.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [GIT]: Networking
Message-ID: <20080904000103.GF5967@tesla>
References: <20080903.161341.239039051.davem@davemloft.net> <alpine.LFD.1.10.0809031615450.3515@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809031621160.3515@nehalem.linux-foundation.org> <20080903.162603.27086959.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080903.162603.27086959.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 04:26:03PM -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 3 Sep 2008 16:24:16 -0700 (PDT)
> 
> > On Wed, 3 Sep 2008, Linus Torvalds wrote:
> > >
> > > What's so hard to understand about this?
> >
> > Here's a simple rule of thumb:
> >  - if it's not on the regression list
> >  - if it's not a reported security hole
> >  - if it's not on the reported oopses list
> > then why are people sending it to me?
> >
> > IOW, if it's just another random improvement, and you send it to me
> > outside of the merge window, then what is the point of the merge window?
> 
> This is exactly what I've been trying to tell the Intel wireless folks
> but they refuse to listen.

What I think really happens here IMHO is communication needs to be
enhanced. I only recently noticed that "regression only" policy for
2.6.27 for example. I think some of us were rather surprised by it too.

Before snapping at people for not following "orders" we need a clear
guideline for what should or not be sent. We're all at fault if we are
not getting this through people. Most likely not many of us subscribe to
linux-kernel so I would think the next best thing we can do is to get our
maintainers to communicate to us of new rules and give a few examples of
what can go in or not.

I trust that should this had been done *well* none of these issue would have
come up and we can avoid angry exchanges.

> I just won't take their stuff until they get their act in gear.
> 
> No problem.

On the other side of the spectrum, and to try to understand this better,
since ath9k is new we obviously cannot get regressions, this means
unless we find a security hole in our driver or if we can generate an
oops with 2.6.27 we cannot send patches for ath9k for 2.6.27?

It seems to make sense to me for purposes of stabalizing the kernel for
sure, however, on the other hand it does also make 2.6.27 miss out on a
few possible small fixes which may appear here and there.

What will happen then is distributions will end up using their own
patches on top of the kernel, or users using something like
compat-wireless to get more bleeding edge stuff. This is exactly what we
want to avoid.

To avoid it I do think another exception needs to be made for patches:

* Small fixes which make something that was not working, which was
  supposed to work work

If these type of patches cannot be submitted we will have a stable
kernel for sure but yet buggy leaving people to opt for alternatives
for small fixes or driver updates.

  Luis
