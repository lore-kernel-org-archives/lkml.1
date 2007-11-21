Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXKUCXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXKUCXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbXKUCXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:23:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:15473 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXKUCXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=isv4DK15jEBTif126a9frYsLrijSCORlazAJ/5K/ePBEVrKvsSo3j2zHk+prXaK6u/+okpVQD4c3mz+hai+a3v+vi7jbc5zOZHY1Y7fFWihjyRaLIhFePXIAG4WrfHY4n7MpGFGwihOSuwAbP+VqQKUJfuB8rGVoxbgNxPas178=
Message-ID: <f17812d70711201823w6201bf88uf6268aaee3a32312@mail.gmail.com>
Date: Wed, 21 Nov 2007 10:23:41 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: ian <spyro@f2s.com>
Subject: Re: [patch] 0/4 Support for Toshiba TMIO multifunction devices
Cc: "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "ARM Linux" <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1195597252.2329.70.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195591234.2329.52.camel@wirenth> <474359E3.2020603@gmail.com>
	 <1195597252.2329.70.camel@wirenth>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roughly went through the patch, looks good, here comes the remind, though :-)

1. is it possible to use some name other than "soc_core", maybe
"tmio_core" so that
other multifunction chips sharing a core base will live easier.

2. those C++ style comments "//" are not so pleasant...

- eric

On Nov 21, 2007 6:20 AM, ian <spyro@f2s.com> wrote:
> On Wed, 2007-11-21 at 01:04 +0300, Dmitry Baryshkov wrote:
> > Just to note, that there is an alternative implementation for at least
> > the tc6393 chip devices. Most current version of those patches can be
> > found in the OpenEmbedded monotone.
>
> Yes, this is true. The core code in both cases originates from my and
> Dirks work.
>
> I'd just like to get something pushed up to mainline so that work can
> begin on expanding the number of chips supported.
>
> This would include the ASICs found in many iPAQ PDAs (their MMC module
> seems to be an IRQ-less TMIO chip).
>
> I havent submitted the subdevice drivers yet, only the base/core
> drivers.
>
> The OE versions probably have better USB and video subdevice support
> (which I shall evaluate as I go on), wheras the NAND flash and MMC
> drivers in hh.org are probably more up to date (I run root on SD usinf
> the hh.org tmio_mmc driver on all three of the MFD chips in this patch
> series on a daily basis).
>
> merging the best of these patch series is my goal and it shouldnt be too
> hard.
>
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
