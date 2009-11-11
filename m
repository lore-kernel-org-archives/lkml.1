Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZKKNtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZKKNtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZKKNtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:49:05 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:41364 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbZKKNtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:49:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PGPZh3CUH5qjuaOljdqHi4qCFkn0p8J1KUyF94yNvvTcFltBkhmZpv2VwST/BSaxsr
         dK1tWLt4Z3NAm1rte9WAp6gzC9fVW7HJqj2n5XRS8gIrBdeGbMVNUovMwA0pro9tDRHT
         xYJa8oC0anakHfz1fjVMPKMHUYzYdmoW7YZv4=
Date: Wed, 11 Nov 2009 16:48:44 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Ben Dooks <ben@simtec.co.uk>, Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Lars-Peter Clausen <lars@metafoo.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 3/6] gta02: set pcf50633 charger_reference_current_ma
Message-ID: <20091111134844.GB22476@home.pavel.comp>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com> <1257369899-325-2-git-send-email-fercerpav@gmail.com> <1257369899-325-3-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257369899-325-3-git-send-email-fercerpav@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ben, please give us an advice on how to proceed with this rather
trivial patch. Anton doesn't merge the other patches from this series
because we do not know via which tree to merge this particular patch.

On Thu, Nov 05, 2009 at 12:24:56AM +0300, Paul Fertser wrote:
> From: Lars-Peter Clausen <lars@metafoo.de>
> 
> This value is board-specific and is needed for calculations to set charging
> current limit properly.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Acked-by: Nelson Castillo <arhuaco@freaks-unidos.net>
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
> 
> Since this patch compile-depends on previous probably it should go through
> the same tree as others. Nelson (gta02 maintainer) agrees with whatever you
> think is best.
> 
> Anton Vorontsov is ok with merging it through his tree but needs an explicit
> ack.
> 
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
> +	.charger_reference_current_ma = 1000,
> +
>  	.reg_init_data = {
>  		[PCF50633_REGULATOR_AUTO] = {
>  			.constraints = {
> -- 
> 1.6.4.4
> 

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
