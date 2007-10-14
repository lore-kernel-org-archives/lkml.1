Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbXJNRHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbXJNRHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbXJNRG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:06:56 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:57164 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbXJNRGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:06:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PRAx8Gylsd2LwTE+tIdM64AEvof655XA0nO8OdUIzhUb4VIu6SZzIJRRpRKd6qUnYu8Lzl1cZK5kaN541uP1vcaJbWzFhl+0R/ATi/pqmunzoBBbpSXYspq3Jw4IP9UY4B6WKcjKWyF+eu9N0R5FOTnc3UGAWGOhPhzZupAIojk=
Message-ID: <386072610710141006kc3897b3s80db77d348971c7e@mail.gmail.com>
Date: Mon, 15 Oct 2007 01:06:53 +0800
From: "Wu, Bryan" <cooloney.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 02/10] Blackfin SPI driver: use new GPIO API and add error handling
Cc: bryan.wu@analog.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <200710121017.47645.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
	 <200710112326.34500.david-b@pacbell.net>
	 <1192172077.6247.15.camel@roc-laptop>
	 <200710121017.47645.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 11 October 2007, Bryan Wu wrote:
> > On Thu, 2007-10-11 at 23:26 -0700, David Brownell wrote:
> > > On Thursday 11 October 2007, Bryan Wu wrote:
> > > > @@ -1182,12 +1198,9 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
> > > >                 return -ENOMEM;
> > > >         }
> > > >
> > > > -       if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
> > > > -                peripheral_request(P_SPI0_MISO, DRV_NAME) ||
> > > > -                peripheral_request(P_SPI0_MOSI, DRV_NAME) ) {
> > > > -
> > > > +       if (setup_pin_mux(1)) {
> > > >                 dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
> > > > -               goto out_error_queue_alloc;
> > > > +               goto out_error;
> > > >         }
> > > >
> > > >         drv_data = spi_master_get_devdata(master);
> > > >
> > >
> > > Still doesn't apply ... what tree are you generating this series against??
> >
> > I apply this patch on Linus git tree at 2.6.23 tag
>
> Then why don't my copies of that tree have the lines flagged
> above with "-" ??
>
> In fact, if I look at the kernel.org GIT tree, it doesn't have
> them either.  Your tree must have somehow gotten a bunch of
> private changes.
>
>
Yes, the GIT tree's code is without that lines, which are introduced
by the first patch of my SPI update patches: Blackfin SPI driver:
Initial supporting BF54x in SPI driver.

So please apply the latest whole Blackfin SPI driver update patchset
including 10 patches instead of 9 patches in previous email.

Thanks a lot
Best Regards
