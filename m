Return-Path: <linux-kernel-owner+w=401wt.eu-S935182AbZJORPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182AbZJORPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935162AbZJORPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:15:48 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:56103 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935160AbZJORPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sUf8RyZXaDyilplm6nIdmrbqQRMJpRWrE18nIbVCdHKYVo77IPeI6d9+cy7tGFcJow
         5IaK7XZyyiq9TmGQoA9QiPcjGTnjpJWwp3KMqQcG7mxDKvWhjemQrrV3hYo+BUWFkHyB
         1VIhCC52tZSm+QN3BJYJD2ztxx2g/nv6rKAQY=
Date: Thu, 15 Oct 2009 21:15:01 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben@simtec.co.uk>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] gta02: set pcf50633 chg_ref_current_ma
Message-ID: <20091015171501.GA25775@oksana.dev.rtsoft.ru>
Reply-To: cbouatmailru@gmail.com
References: <1255471148-29047-1-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-3-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1255471148-29047-3-git-send-email-fercerpav@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 01:59:05AM +0400, Paul Fertser wrote:
> From: Lars-Peter Clausen <lars@metafoo.de>
> 
> This value is board-specific and is needed for calculations to set charging
> current limit properly.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Acked-by: Nelson Castillo <arhuaco@freaks-unidos.net>
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
> 
> Since this patch compile-depends on previous probably it should go through
> the same tree as others. Nelson (gta02 maintainer) agrees with whatever you
> think is best.

I would happy to apply this patch via battery tree, along
with other your patches.

Just to make things clear: we no longer need RMK's Ack for
mach-specific patches that don't touch core code? Or maybe
Ben's Ack is still required?

Want to be on a safe side before applying.

Thanks!

>  arch/arm/mach-s3c2442/mach-gta02.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2442/mach-gta02.c b/arch/arm/mach-s3c2442/mach-gta02.c
> index 0fb385b..b0a3d74 100644
> --- a/arch/arm/mach-s3c2442/mach-gta02.c
> +++ b/arch/arm/mach-s3c2442/mach-gta02.c
> @@ -268,6 +268,9 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  
>  	.batteries = gta02_batteries,
>  	.num_batteries = ARRAY_SIZE(gta02_batteries),
> +
> +	.chg_ref_current_ma = 1000,
> +
>  	.reg_init_data = {
>  		[PCF50633_REGULATOR_AUTO] = {
>  			.constraints = {
> -- 
> 1.6.0.6

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
