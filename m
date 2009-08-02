Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZHBJKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZHBJKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 05:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZHBJKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 05:10:10 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:57017 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZHBJKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 05:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N14OvM//uzGlLqWcmUyWoFP6F6Vp7p0puEUI0rwXvUM7nx/qfniLhe+TbgiPKpfs1X
         TVUnS9uFhax7z6IKRjWioY4V4KrfImqTEqOUt4hX+HLzEs2t9Fzi9ah4jQI0RrCa/mBS
         BjJW91/+Wnkz97Y4w2+fvAeJtnYjVL0hL0Myc=
MIME-Version: 1.0
In-Reply-To: <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
	 <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
Date: Sun, 2 Aug 2009 17:10:07 +0800
Message-ID: <804dabb00908020210r72a9a9c3p5c6d906a7f6b53db@mail.gmail.com>
Subject: Re: [wireless] rt2870sta BUGs on shutdown, 2.6.30.2->git.today+git.wireless.today
From: Peter Teoh <htmldeveloper@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-wireless@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/09, Luis Correia <luis.f.correia@gmail.com> wrote:
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
>
> What is appreciated is people with time to compare both code paths,
> and report some inconsistancies, specially about card initialization
> and general handling.
>
> To be hones, we, the rt2x00 team, find Ralink's code to be very
> difficult to follow, and combersome most of the times.
>

This is very true, I had too many questions about the different
symbols, and task vs pid variations  etc etc....and so many macro
usage :-)....
But thank you for all the efforts of debugging!!!!





-- 
Regards,
Peter Teoh
