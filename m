Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0BBNuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:50:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab0BBNuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:50:15 -0500
Date: Tue, 2 Feb 2010 14:50:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Dave Airlie <airlied@redhat.com>, Pavel Roskin <proski@gnu.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/kms: fix spelling of "CLOCK"
In-Reply-To: <4B55A4CE.4060000@ladisch.de>
Message-ID: <alpine.LNX.2.00.1002021449570.15395@pobox.suse.cz>
References: <4B55A4CE.4060000@ladisch.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010, Clemens Ladisch wrote:

> From: Pavel Roskin <proski@gnu.org>
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> [clemens@ladisch.de: merged into drm_fb_helper]
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -694,7 +694,7 @@ int drm_fb_helper_set_par(struct fb_info
>  	int i;
>  
>  	if (var->pixclock != 0) {
> -		DRM_ERROR("PIXEL CLCOK SET\n");
> +		DRM_ERROR("PIXEL CLOCK SET\n");
>  		return -EINVAL;
>  	}

Doesn't seem to be present in linux-next as of today. I have picked it up.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
