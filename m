Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYFRUKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYFRUKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYFRUKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:10:05 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:22972
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbYFRUKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:10:04 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 16:10:04 EDT
X-Trace: 99538328/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8AACAGWUjDiV6i/2dsb2JhbAAIsSY
X-IronPort-AV: E=Sophos;i="4.27,667,1204502400"; 
   d="scan'208";a="99538328"
X-IP-Direction: IN
Subject: Re: [PATCH] w100fb: do not depend on SHARPSL
From: ian <spyro@f2s.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alberto Mardegan <mardy@users.sourceforge.net>,
       Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <1213810146.8144.5.camel@localhost.localdomain>
References: <1213810146.8144.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 20:59:57 +0100
Message-Id: <1213819197.17281.7.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 19:29 +0200, Philipp Zabel wrote:
> Apart from Sharp SL-Cxx series, there are a few other devices that have
> ATI Imageon chips, among them HP iPAQ hx4700.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>

Acked-by: Ian Molton <spyro@f2s.com>

> ---
>  drivers/video/Kconfig |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 002b61b..e0c5f96 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -1825,12 +1825,13 @@ config FB_FSL_DIU
>  
>  config FB_W100
>  	tristate "W100 frame buffer support"
> -	depends on FB && PXA_SHARPSL
> +	depends on FB && ARCH_PXA
>   	select FB_CFB_FILLRECT
>   	select FB_CFB_COPYAREA
>   	select FB_CFB_IMAGEBLIT
>  	---help---
>  	  Frame buffer driver for the w100 as found on the Sharp SL-Cxx series.
> +	  It can also drive the w3220 chip found on iPAQ hx4700.
>  
>  	  This driver is also available as a module ( = code which can be
>  	  inserted and removed from the running kernel whenever you want). The

