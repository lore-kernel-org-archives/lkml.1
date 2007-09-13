Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbXIMXJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbXIMXJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXIMXJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:09:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:49457 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbXIMXJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qvHHlxvamP0NT6J1AQwMcQPQ5NySIQaileJQ5L+wDx+MIUNzzue1FlSrFYpmyjcGC7eMWZP0Jl66RcR/70xWr/fprcgoAg/P/jukwN3QVDv3cYgJ8LzF33qLeEUwJ4l8dbvq37mv0hQk6wOFFEwE8RLwW+X1mQOVXY/EvPA8zV4=
Message-ID: <625fc13d0709131609t94b9fcbtc66c87ebe6e8f1e0@mail.gmail.com>
Date: Thu, 13 Sep 2007 18:09:39 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [patch] update CFI URI n mtd kconfig
Cc: "Mike Frysinger" <vapier@gentoo.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
In-Reply-To: <200709131631.56867.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709122339.55267.vapier@gentoo.org>
	 <625fc13d0709131128m5a606b6ewe729c1e72f73f9d9@mail.gmail.com>
	 <200709131631.56867.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Thu 13 Sep 2007 14:28, Josh Boyer pondered:
> > On 9/12/07, Mike Frysinger <vapier@gentoo.org> wrote:
> > > Since AMD shunted its flash memory division, the URI in the mtd Kconfig is now
> > > broken, so the attached patch points people to Wikipedia.
> > >
> > > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > > ---
> > > diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
> > > index 479d32b..980117a 100644
> > > --- a/drivers/mtd/chips/Kconfig
> > > +++ b/drivers/mtd/chips/Kconfig
> > > @@ -11,8 +11,8 @@ config MTD_CFI
> > >           AMD and other flash manufactures that provides a universal method
>
> Even on the Intel page, it gives "Intel, AMD, Sharp, and Fujitsu" credit - why
> limit Sharp, and Fujitsu to "others"? (I would just take out everyone's name).

He wasn't changing that part of the option.  I'm fairly certain that
description has been there for years.  If you want to change it to be
a bit more "fair", feel free.

> > >           for probing the capabilities of flash devices. If you wish to
> > >           support any device that is CFI-compliant, you need to enable this
> > > -         option. Visit <http://www.amd.com/products/nvd/overview/cfi.html>
> > > -         for more information on CFI.
> > > +         option. For more information on CFI, visit:
> > > +         <http://wikipedia.org/wiki/Common_Flash_Memory_Interface>
> >
> > Erm, I'd rather not point to wikipedia.  Can you change it to point to:
> >
> > http://www.intel.com/design/flash/swb/cfi.htm
>
> Why not from the place that you can get the standard? http://jedec.org/
>
> or http://www.jedec.org/download/search/jesd68-01.pdf
>
> There isn't any point to pick one vendor - unless you work there, own
> stock, or one provides outstanding support (free hardware) for driver
> development. :)

I wasn't picking a vendor.  I was pointing out a well laid out webpage
that describes what CFI is and provides the spec for it.  If you want
to link directly to jedec, ok.

And no, I don't work at Intel, own stock in it, or know of them giving
out free hardware on a regular basis.  I do happen to like what Intel
is doing in regards to opening their drivers, but that has nothing to
do with this :).

josh
