Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYLRXlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYLRXlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYLRXkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:40:37 -0500
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:38309 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754442AbYLRXkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:40:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ucyFtMYepVmZOPiQ7IX8HxurayyAEI6+jcLsoe4FkbPSw+aUCeSmTZgcfNwHkknphKT1Y0LB1xuOCLPgo+ik/DNFrnpdA4p2IrfZTm3PfMwHmtB10fWw1ZC/GtGU06xG;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] drm/i915: fix sparse warnings: declare one-bit bitfield as unsigned
Date: Thu, 18 Dec 2008 15:40:33 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Hannes Eder <hannes@hanneseder.net>, David Airlie <airlied@linux.ie>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <494ad5d2.190c660a.55a0.ffff96ff@mx.google.com>
In-Reply-To: <494ad5d2.190c660a.55a0.ffff96ff@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181540.34147.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2008 6:09 am Hannes Eder wrote:
> Fix this sparse warnings:
>
>   drivers/gpu/drm/i915/i915_drv.h:169:22: error: dubious one-bit signed
> bitfield drivers/gpu/drm/i915/i915_drv.h:169:22: warning: dubious bitfield
> without explicit `signed' or `unsigned'
> drivers/gpu/drm/i915/i915_drv.h:170:19: error: dubious one-bit signed
> bitfield drivers/gpu/drm/i915/i915_drv.h:170:19: warning: dubious bitfield
> without explicit `signed' or `unsigned'
> drivers/gpu/drm/i915/i915_drv.h:171:16: error: dubious one-bit signed
> bitfield drivers/gpu/drm/i915/i915_drv.h:171:16: warning: dubious bitfield
> without explicit `signed' or `unsigned'
> drivers/gpu/drm/i915/i915_drv.h:172:23: error: dubious one-bit signed
> bitfield drivers/gpu/drm/i915/i915_drv.h:172:23: warning: dubious bitfield
> without explicit `signed' or `unsigned'
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/gpu/drm/i915/i915_drv.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.h
> b/drivers/gpu/drm/i915/i915_drv.h index 467572a..a640bcf 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -166,10 +166,10 @@ typedef struct drm_i915_private {
>  	struct drm_display_mode *vbt_mode; /* if any */
>
>  	/* Feature bits from the VBIOS */
> -	int int_tv_support:1;
> -	int lvds_dither:1;
> -	int lvds_vbt:1;
> -	int int_crt_support:1;
> +	unsigned int int_tv_support:1;
> +	unsigned int lvds_dither:1;
> +	unsigned int lvds_vbt:1;
> +	unsigned int int_crt_support:1;
>
>  	struct drm_i915_fence_reg fence_regs[16]; /* assume 965 */
>  	int fence_reg_start; /* 4 if userland hasn't ioctl'd us yet */

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center

