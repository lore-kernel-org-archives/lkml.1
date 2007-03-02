Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbXCBBBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbXCBBBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbXCBBBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:01:39 -0500
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:29727 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932574AbXCBBBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:01:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eVFA1CXnMtNOXrBUraXKcbcEx1uRmg8ofkavk7d/9g4g69gpfTLCVg+4qS/ckf3ujY86cqR8DPSIaN0xN8mJjPjrfUbi8Qylnyi/98Fz4g674dqmlE6LSJhoqzHXMSLtBZU2iqxs4ykvAQgcPzr9J83EVbHzkPZYZFMIuCmmi+k=  ;
X-YMail-OSG: kvQTCbAVM1kX7fxvKuCehv2J7Roe1JShTh1vx0LRJF1kAmnFof8_dka9O7tFHEtpkFyjRvGpu4aPNEhqkFwh6weD2CqckcTlI0JSca27WWDexX09m6DJcbfmXeZzlTqR6khmjQ_pe3QQGg--
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <ben.nizette@iinet.net.au>
Subject: Re: [patch 2.6.21-rc2] gpio_keys driver shouldn't be ARM-specific
Date: Thu, 1 Mar 2007 16:54:18 -0800
User-Agent: KMail/1.7.1
Cc: Dmitry Torokhov <dtor@mail.ru>, pHilipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200703011551.29696.david-b@pacbell.net> <45E76D65.30405@iinet.net.au>
In-Reply-To: <45E76D65.30405@iinet.net.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011654.18682.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 4:18 pm, Ben Nizette wrote:
> David Brownell wrote:
> > The gpio_keys driver is wrongly ARM-specific; it can't build on
> > other platforms with GPIO suport.  This fixes that problem.
> > 
> I did up a similar patch a few days back, you beat me too it ;).  I've 
> been using this driver on AVR32 for a while now.

I know various folk have been doing that very thing ...


> The other thing was that this driver only depends on the machine 
> supporting your generic GPIO conventions.  Currently the Kconfig entry 
> for gpio_keys reads:
> 
> 	depends on (ARCH_SA1100 || ARCH_PXA || ARCH_S3C2410)
> 
> With the || AVR32 I've added to my version it's getting a bit out of 
> hand!  Anyone else think it would be worth introducing a GPIO_FRAMEWORK 
> symbol selected by each machine which supports it and just set the 
> gpio_keys dependency to that?

Earlier today I posted a patch adding CONFIG_GENERIC_GPIO, and
I think that will get merged soonish ...

- Dave


> 
> Ben.
> 
