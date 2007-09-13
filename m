Return-Path: <linux-kernel-owner+w=401wt.eu-S1764043AbXIMUcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764043AbXIMUcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXIMUbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:31:48 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:46950 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765655AbXIMUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:31:47 -0400
X-IronPort-AV: i="4.20,251,1186372800"; 
   d="scan'208"; a="39576076:sNHT33638983"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Josh Boyer" <jwboyer@gmail.com>
Subject: Re: [patch] update CFI URI n mtd kconfig
Date: Thu, 13 Sep 2007 16:31:56 -0400
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier@gentoo.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
References: <200709122339.55267.vapier@gentoo.org> <625fc13d0709131128m5a606b6ewe729c1e72f73f9d9@mail.gmail.com>
In-Reply-To: <625fc13d0709131128m5a606b6ewe729c1e72f73f9d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131631.56867.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 13 Sep 2007 20:31:39.0725 (UTC) FILETIME=[16B167D0:01C7F645]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13 Sep 2007 14:28, Josh Boyer pondered:
> On 9/12/07, Mike Frysinger <vapier@gentoo.org> wrote:
> > Since AMD shunted its flash memory division, the URI in the mtd Kconfig is now
> > broken, so the attached patch points people to Wikipedia.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> > diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
> > index 479d32b..980117a 100644
> > --- a/drivers/mtd/chips/Kconfig
> > +++ b/drivers/mtd/chips/Kconfig
> > @@ -11,8 +11,8 @@ config MTD_CFI
> >           AMD and other flash manufactures that provides a universal method

Even on the Intel page, it gives "Intel, AMD, Sharp, and Fujitsu" credit - why
limit Sharp, and Fujitsu to "others"? (I would just take out everyone's name).

> >           for probing the capabilities of flash devices. If you wish to
> >           support any device that is CFI-compliant, you need to enable this
> > -         option. Visit <http://www.amd.com/products/nvd/overview/cfi.html>
> > -         for more information on CFI.
> > +         option. For more information on CFI, visit:
> > +         <http://wikipedia.org/wiki/Common_Flash_Memory_Interface>
> 
> Erm, I'd rather not point to wikipedia.  Can you change it to point to:
> 
> http://www.intel.com/design/flash/swb/cfi.htm

Why not from the place that you can get the standard? http://jedec.org/

or http://www.jedec.org/download/search/jesd68-01.pdf 

There isn't any point to pick one vendor - unless you work there, own
stock, or one provides outstanding support (free hardware) for driver 
development. :)

-Robin
