Return-Path: <linux-kernel-owner+w=401wt.eu-S1751756AbZG3NTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbZG3NTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZG3NTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:19:18 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64102 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZG3NTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=lCSk15Y8QNKnMTjckjrWx++N66dzr57Lg6mmAdTo6VOkknW0yAt6Yv7YlXm5fzJwW7
         R/wzAgEkaTIeEvsBW67NN4C+Px4Y1rNLEgjXcGRYOcBB1G1plfN7FrdKPD6SBmHl+hYD
         YGVrlv4KRKzOehQNW+HtBIwKc059LMIgFb/U8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [wireless] rt2870sta BUGs on shutdown, 2.6.30.2->git.today+git.wireless.today
Date: Thu, 30 Jul 2009 15:17:54 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: Mike Galbraith <efault@gmx.de>, linux-wireless@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
References: <1248945770.7910.24.camel@marge.simson.net> <1248947740.8925.12.camel@johannes.local> <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
In-Reply-To: <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907301517.57811.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 30 July 2009 12:06:00 Luis Correia wrote:
> Hi Mike,
> 
> On Thu, Jul 30, 2009 at 10:55, Johannes Berg<johannes@sipsolutions.net> wrote:
> > On Thu, 2009-07-30 at 11:44 +0200, Mike Galbraith wrote:
> >> On Thu, 2009-07-30 at 11:29 +0200, Johannes Berg wrote:
> >> > On Thu, 2009-07-30 at 11:22 +0200, Mike Galbraith wrote:
> >> >
> >> > > drivers/staging/rt2870/../rt2860/sta_ioctl.c
> >> >
> >> > Sorry, but that '/staging/' thing in there means we cannot support this.
> >> > If you must, take your query to the staging list,
> >> > devel@driverdev.osuosl.org (according to MAINTAINERS).
> >>
> >> Forwarded, thanks.
> >>
> >> ....hm.  Does "If you must" mean reports aren't welcome?
> >
> > To be honest, I don't know. I'd rather see people use the rt2x00 code
> > instead of spending time cleaning up that mess (the code you've pasted
> > was pretty bad!). But you may or may not find somebody who cares about
> > that, just rather unlikely on this list.

rt2800pci which I would need for my Asus Eee 901 is not even ready for
the upstream inclusion (after a year or so since Ralink's driver has been
released).

The sad reality is that some vendors have discovered "the loophole" in
the current kernel development model and are using it.  Pretending that
the GPL-ed-but-fugly _working_ drivers do not exist is not an answer!

[ Especially not in the long-term (I think thank the support for the newest
  generation of Ralink chipsets will probably also be based on more-or-less
  the same code base). ]

Users are pragmatic beasts and don't care about "proper" code.  They are
just using what works "good enough" for them (i.e. if distribution ships
a slightly inferior solution to the official one nobody will bother with
the official one, now lets think about the incomplete official one..).

No, I don't have a good answer for the problem.  However I think that we
should be looking for the real, long-term solution instead of pretending
that the issue doesn't exist.

> What is appreciated is people with time to compare both code paths,
> and report some inconsistancies, specially about card initialization
> and general handling.

You are talking about people who:
* are familiar with wireless networking and wireless drivers
* have ability to work with the ugly/complicated code
* have good code reading/review skills
* have a quite some free time in their hands

Well, good luck..

> To be hones, we, the rt2x00 team, find Ralink's code to be very
> difficult to follow, and combersome most of the times.

I completely agree but it _works_, rt2x00 does _not_.

> But any help is welcome!

I think that cleaning of vendor drivers is an indirect form of help to
rt2x00 team (by making the mess easier to read and comprehend) and not a
competition to rt2x00 project.  rt2x00 code is of very high quality and
I'm impressed by the work done by you, Ivo and the rest of the team.
However I think that you will never able to out do the _vendor_ when it
comes to the support for their new devices and I find the idea of finding
highly skilled volunteers helping with the most difficult, tedious and
thankless parts of the work a bit over-optimistic.
