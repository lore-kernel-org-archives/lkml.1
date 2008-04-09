Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYDITjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYDITjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYDITjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:39:15 -0400
Received: from hs-out-0708.google.com ([64.233.178.245]:49950 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbYDITjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EKq3KYywM9cbb+jwGCrehnxkZyY1FYCRAvWKE0aFXqih9mL2BJUYF4ncDDZJ/qWitBLdisyyQn7H0KNOG+6GsmpYScq0EGG5J4i+ijlzsYtfQUaHncmwyJfHnmITZ9s6wcDfc7WlPrBX3D16tOXII5X/1GcpZVwBQC57+u83+OY=
Message-ID: <bc64b4640804091239k244010a8u6e61d2f25792bf94@mail.gmail.com>
Date: Wed, 9 Apr 2008 23:39:12 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       lethal@linux-sh.org, philipp.zabel@gmail.com, pavel@ucw.cz,
       tony@atomide.com, paul@pwsan.com
In-Reply-To: <20080409192009.GB13891@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	 <20080403132402.GA27008@doriath.ww600.siemens.net>
	 <20080407160029.f1f9ce4f.akpm@linux-foundation.org>
	 <20080407230434.GA525@flint.arm.linux.org.uk>
	 <bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com>
	 <20080408193309.GA18053@flint.arm.linux.org.uk>
	 <bc64b4640804090015m7dd640d5j31c54b99007f09a7@mail.gmail.com>
	 <20080409190504.GA13891@flint.arm.linux.org.uk>
	 <20080409200916.78615f39@core>
	 <20080409192009.GB13891@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Russell,

2008/4/9, Russell King <rmk+lkml@arm.linux.org.uk>:
> On Wed, Apr 09, 2008 at 08:09:16PM +0100, Alan Cox wrote:
>  > > Basically what I'm thinking is a serial_core function which could be
>  > > called to say "I'm an IrDA driver, and I think I should be using the
>  > > serial port located <here>, please give me control of it" and it'd
>  > > pass over the various parameters including the struct device for it.
>  > > Or something like that.
>  >
>  > It's called a line discipline, we've had them for many years. We may need
>  > a way for ldiscs and drivers to co-operate a bit more but these days we
>  > support proper buffering and arbitary baud rates (except on a few
>  > platforms whose maintainers are not paying attention ;)).

That would be a good thing to have.

> I feel that's a "it would be nice if" solution - and something worth
>  aiming for, but the amount of work required to get there is not going
>  to be insignificant.
>
>  Maybe Dmitry can bite his nails on the NULL device clklib issue for a
>  while as this transition is happening ?  (Though we need to find someone
>  to make it happen... we need volunteers!)

Russell, I'd propose to agree to bind PXA's IrDA to STUARTCLK and
leave UARTCLK function to real pxa uart driver. If you would oppose, I
won't have any choises other that to agree with it.

-- 
With best wishes
Dmitry
