Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZFGUh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZFGUh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZFGUhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:37:50 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:62747 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbZFGUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=N4yJxPo1o27QDL2IJND5WaLBwiFtn8TAg2QafK8zOAtwegfvrgrnouW4dpq6ZKDwLu
         vHyQVg2WN6BW1EnOda9UYsklVtS+ESnJ+impfpOOZwMAgsteqEFF5okkiGADw9jM2Ir3
         YCsCGFEKtNs0wsnIdnpXLLqYhlwd6BIrZgKSs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 22:42:37 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <1244401729.8262.102.camel@mulgrave.site> <20090607210701.78103188@lxorguk.ukuu.org.uk>
In-Reply-To: <20090607210701.78103188@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906072242.38021.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 22:07:01 Alan Cox wrote:
> > > [ I also tried to encourage libata developers to look into making the needed
> > >   libata changes (see my initial posting of HPA patches) and I will still be
> > >   glad to help with libata patches if somebody would like to work on them
> > >   (Robert? Tejun?). ]
> > 
> > OK, so back off on the 2.6.30-rc7 release of this and I'll undertake to
> > get libata engaged for integrating this into both subsystems for
> > 2.6.31 ... does that sound fair?
> 
> libata already is, and I've been following and reviewing the patches. The
> problem remaining is basically that this is not the time to merge
> it.

In ide's case the situation is a bit different:

This is a bug fix.  Not an obvious one but it will help anyone installing
a new distribution/kernel using ide on machine with HPA, as it will allow
this user for streamline transition to a distribution/kernel using libata
later if needed (even though I don't recommend it :).

I just want a fair treatment.  I'm not posting crap -rc pull request so
I see no reason why I have to pay for other maintainers mistakes.

This was better tested and reviewed that some other changes that got in
after 2.6.30-rc8 (and is smaller than at least one other pull request
that got in).

I even admitted in the pull request that this may be too late but based on
my technical judgment (strongly backed by on reviews from you and Sergei)
I considered those changes to be on the edge...

It is not a *must*have* for 2.6.30 but still 2.6.30 *shall*have* it.

> It will probably also be worth looking at the way the CD driver plays
> fast and loose with capacity when handling CD-R devices as a follow on
> from this stuff.

Sure and it would be easier to look into this (and libata changes) with
partitions/ide changes in.
