Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbYEACNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbYEACNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYEACNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:13:40 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40283 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842AbYEACNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:13:40 -0400
Date: Thu, 1 May 2008 05:12:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080501021254.GR29330@cs181133002.pp.htv.fi>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501011703.GA27574@elte.hu> <20080501013739.GQ29330@cs181133002.pp.htv.fi> <20080501020645.GD27574@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080501020645.GD27574@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 04:06:45AM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > The bug is in arch/x86/Kconfig .
> > 
> > Caused by commit 4cf31841762954ad2868156ccba94d798a16630f (x86: 
> > mach-rdc321x Kconfig fix).
> 
> ah, indeed - Florian Cc:-ed. Preliminary quick hack below.

Why couldn't you *read* my email completely before sending yet another 
kconfig patch?

I said:
Roman's patch to remove the need to select NEW_LEDS that just appeared 
in another thread will actually also fix your bug (and makes my idea 
to add a "select NEW_LEDS" to X86_RDC321X obsolete).

> 	Ingo
> 
> --------------->
> Subject: rdc: leds hack
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu May 01 03:46:22 CEST 2008
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/arch/x86/Kconfig
> ===================================================================
> --- linux.orig/arch/x86/Kconfig
> +++ linux/arch/x86/Kconfig
> @@ -322,6 +322,7 @@ config X86_RDC321X
>  	select GENERIC_GPIO
>  	select LEDS_CLASS
>  	select LEDS_GPIO
> +	select NEW_LEDS
>  	help
>  	  This option is needed for RDC R-321x system-on-chip, also known
>  	  as R-8610-(G).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

