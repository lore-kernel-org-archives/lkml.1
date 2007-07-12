Return-Path: <linux-kernel-owner+w=401wt.eu-S933814AbXGLSqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbXGLSqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbXGLSqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:46:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:10889 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbXGLSqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HQ3mE31C5bJ1b/MVN3NxcvByc8uGHT5IHWaY6/z8diWGFbPz6WJUeO6ru8fDSIbe0j9S/P22N9/uPiSgIyismavkiZmy4rRX7+T2MKgDvGp3/HaNVvDW8oazjOVlo3qTIAiX2QgdRo8SpWZSGDz8JC4d5HTncAA5HqGKfw02fZA=
Message-ID: <29495f1d0707121146k7b3a7175l1fcb40877e59cfaf@mail.gmail.com>
Date: Thu, 12 Jul 2007 11:46:15 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] Linux 2.6.22.1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20070712184106.GA22849@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710200637.GA5881@kroah.com>
	 <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
	 <20070712184106.GA22849@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/07, Greg KH <greg@kroah.com> wrote:
> On Thu, Jul 12, 2007 at 11:35:41AM -0700, Nish Aravamudan wrote:
> > On 7/10/07, Greg KH <greg@kroah.com> wrote:
> > > We (the -stable team) are announcing the release of the 2.6.22.1 kernel.
> > > It contains a security fix for SCTP that somehow forgot to be added to
> > > the 2.6.22 kernel (was already released in the 2.6.21.y releases).
> > > Thanks to Patrick McHardy for noticing the mistake.
> > >
> > > I'll also be replying to this message with a copy of the patch between
> > > 2.6.22 and 2.6.22.1
> > >
> > > The updated 2.6.22.y git tree can be found at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
> >
> > Can you please also update
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
> >
> > ? Maybe make that update part of whatever process you use to push out
> > the 2.6.Y trees, as I've had to ask for this more than once now?
>
> That is a tree that Chris did, and I didn't realize we were maintaining
> it as the "official" stable tree, that is why it is not mentioned in the
> release notes :)

Fair enough -- it's just a little bit easier from my side for
mirroring to only have to mirror one tree rather simply rather than
pulling multiple trees into one (and thus having to add to the list as
time goes on).

> I'll let Chris decide if he wishes to maintain it or not, Chris?

Thanks,
Nish
