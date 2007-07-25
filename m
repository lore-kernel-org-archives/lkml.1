Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbXGYOya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbXGYOya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXGYOyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:54:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:23827 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761214AbXGYOyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rcP9GEuAbrhYEr8CzSxhsijSkag7WAHBv5kVEBddj/DTCCLB/6kD/0BMO2gJ9I6f2nrDUcmrWFOqNEQ0RfiiBi+YjySEk2KLDmY7/Bsh01xOovvcQ1QtvuROMKC5nkCvzW0AksgLFlI0HhmqD/PxL4aIMYH1DBVPI0BBHJfCFXU=
Message-ID: <dda83e780707250754k5d611439ta9d383981ab12eb9@mail.gmail.com>
Date: Wed, 25 Jul 2007 07:54:20 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear mappings
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46A6C72A.9020801@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780707241027k369c2f01j6d16b21266df3a05@mail.gmail.com>
	 <46A6C72A.9020801@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Bret Towe wrote:
> > for a while in -git I've had an issue that on boot when gdm loads the
> > screen stays black
> > using ctrl-f1 doesn't return to a console and killing X doesn't help any
> > ssh'ing into the box does work top only shows 100% io-wait
> > dmesg shows nothing odd
> >
> > the work around I have is at the moment is to just move the radeon drm
> > module
> > out of the way so it doesn't load on boot and X works just fine like that
> > I did some bisecting which took a few days and tracked it down to
> > commit d00806b183152af6d24f46f0c33f14162ca1262a
> >
> > its way to complex for me to revert it on top of -rc1 to verify that's
> > the issue tho
> > I keep forgetting to get a trace of what its waiting on when I'm in that
> > kernel
> > I assume that would be of use and Ill get that later
> >
> > the box this is happening on is a g4 mac mini the built in card is a
> > radeon 9200
> > I'm not seeing any issues on an amd64 box with radeon card it's also a
> > 9600 tho
>
> Is this with a binary-only module? We saw an issue with that in SLES9
> where the module is returning a locked page from its nopage handler
> when it isn't really supposed to. It might be fixed in latest drivers,
> have you tried them?

you mean the drivers ati releases? no its all open source drivers
I didn't think ati release powerpc versions of their drivers?
not that id use them ether way

> Thanks,
> Nick
>
> --
> SUSE Labs, Novell Inc.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
