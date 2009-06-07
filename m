Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZFGTVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZFGTVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZFGTUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:20:51 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58411 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZFGTUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=BM7yfIQ27azHoM6h0x8lXCY7VIXDCQPBI954kftLJ9Xy77YyU4z0mXNKIihsUHbu6B
         Ne5RnlxhPPDHVUheL9cwVd/YflPMSFO3iS5ApPXfwzYSrz38X/Q1AmviWGPcbmMyK0Om
         /eBejk458tYSFzM4/nwx7fxKtvUrarYCLvJ/U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 21:25:40 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <200906072100.10649.bzolnier@gmail.com> <84144f020906071209m51e5fd15jaa67f9143ab1d126@mail.gmail.com>
In-Reply-To: <84144f020906071209m51e5fd15jaa67f9143ab1d126@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906072125.40784.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 21:09:47 Pekka Enberg wrote:
> Hi Bartlomiej,
> 
> On Sun, Jun 7, 2009 at 10:00 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >> > My honest opinion is that it is as appropriate now as it will be 2.6.31.
> >> >
> >> > [ I'm still amazed by the amount of *completely* bogus reasons given for
> >> >  not merging it. ]
> >>
> >> I don't consider this a bogus reason at all:
> >>
> >>  10 files changed, 134 insertions(+), 43 deletions(-)
> >
> > Since when do we validate code quality based solely on LOC changed? :)
> 
> Since when we entered -rc8 (or even earlier).

To be perfectly clear on this:

* all patches were posted a week ago to the list (they replaced patches
  from two weeks ago -- which were intended for -rc8 but thanks to feedback
  I found a better way to do it).

> On Sun, Jun 7, 2009 at 10:00 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > I'm yet to see anybody posting a single code chunk in this whole discussion.
> 
> That's because I am not objecting to the code. I am objecting to the
> fact that you're submitting something as big as this so late in the
> release cycle and the fact that it's not a clear-cut bug fix.

That is a valid objection in contrast to some other ones.

Still, changes are really *safe*:

* fs/partitions/check.c change is straight-forward
  (doesn't affect anything besides ide-gd)

* ide-gd changes are making it similar in HPA behavior to libata
  (which is what most distributions are shipping)
