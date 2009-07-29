Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZG2Vgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZG2Vgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZG2Vgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:36:31 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:19512
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260AbZG2Vg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:36:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicBAGNdcEp8qMex/2dsb2JhbAAI1BSCP4FSBYFJ
X-IronPort-AV: E=Sophos;i="4.43,290,1246809600"; 
   d="scan'208";a="484747254"
Subject: Re: [PATCH] favr32: improve touchscreen response
From: Ben Nizette <ben@niasdigital.com>
Reply-To: ben@niasdigital.com
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel <kernel@avr32linux.org>,
       "Egtvedt, Hans-Christian" <Hans-Christian.Egtvedt@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090727131758.050ca571@hskinnemoen-d830>
References: <1240195013.24329.38.camel@linux-51e8.site>
	 <1246002577.9414.62.camel@linux-51e8.site>
	 <20090727131758.050ca571@hskinnemoen-d830>
Content-Type: text/plain
Organization: Nias Digital
Date: Thu, 30 Jul 2009 07:39:21 +1000
Message-Id: <1248903561.13515.178.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 13:17 +0200, Haavard Skinnemoen wrote:
> Ben Nizette wrote:
> > Hi Haavard,
> > 
> > This has hce's ack, any chance of getting it in .31?
> 
> Yeah, should be a good chance :-) Sorry for taking so long.
> 
> It doesn't apply, however. I ended up doing this:
> 
> diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
> index 46c9b0a..75f19f4 100644
> --- a/arch/avr32/boards/favr-32/setup.c
> +++ b/arch/avr32/boards/favr-32/setup.c
> @@ -72,6 +72,10 @@ static struct ads7846_platform_data ads7843_data = {
>  	.debounce_max		= 20,
>  	.debounce_rep		= 4,
>  	.debounce_tol		= 5,
> +
> +	.keep_vref_on		= true,
> +	.settle_delay_usecs	= 500,
> +	.penirq_recheck_delay_usecs = 100,
>  };
>  
>  static struct spi_board_info __initdata spi1_board_info[] = {
> 
> It appears to compile, but please verify that it's still correct.

Looks good, thanks!

Tested-by: Ben Nizette <bn@niasdigital.com>

> 
> Haavard

