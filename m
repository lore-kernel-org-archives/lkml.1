Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbZJHQIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbZJHQIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZJHQIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:08:46 -0400
Received: from mx1.emlix.com ([193.175.82.87]:38860 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbZJHQIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:08:45 -0400
X-Greylist: delayed 2251 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 12:08:45 EDT
From: "Oskar Schirmer" <os@emlix.com>
Date: Thu, 8 Oct 2009 17:30:37 +0200
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>
Subject: Re: [PATCH] add missing include in lib/rational.c
Message-ID: <20091008153037.GA13717@emlix.com>
References: <20091008075403.GE30719@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091008075403.GE30719@pengutronix.de>
Organization: emlix GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 09:54:03 +0200, Sascha Hauer wrote:
> 
> Hi,
> 
> Here is a little patch to fix a compiler warning
> 
> fixes:
> 
> lib/rational.c:62: warning: data definition has no type or storage class
> lib/rational.c:62: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
> lib/rational.c:62: warning: parameter names (without types) in function declaration

Oh yes, we didnt use it with modules up to now.
Thank You for the fix.

> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Oskar Schirmer <os@emlix.com>

> ---
>  lib/rational.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/rational.c b/lib/rational.c
> index b3c099b..3ed247b 100644
> --- a/lib/rational.c
> +++ b/lib/rational.c
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/rational.h>
> +#include <linux/module.h>
>  
>  /*
>   * calculate best rational approximation for a given fraction
> -- 
> 1.6.4.3
> 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 

-- 
oskar schirmer, emlix gmbh, http://www.emlix.com
fon +49 551 30664-0, fax -11, bahnhofsallee 1b, 37081 göttingen, germany
sitz der gesellschaft: göttingen, amtsgericht göttingen hr b 3160
geschäftsführer: dr. uwe kracke, ust-idnr.: de 205 198 055

emlix - your embedded linux partner
