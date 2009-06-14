Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbZFNXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbZFNXhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZFNXh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:37:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:32816 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbZFNXh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:37:27 -0400
Date: Mon, 15 Jun 2009 00:37:27 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Ryan Hope <rmh3093@gmail.com>
cc: Jerome Glisse <glisse@freedesktop.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [PATCH 1/3] Re: Radeon kernel modesetting patch (as staging)
 please review
In-Reply-To: <48f7fe350906140642i595fa90ep182838e3ad4893fd@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0906150037110.20307@skynet.skynet.ie>
References: <1244649318.9942.33.camel@earl.localdomain> <48f7fe350906140642i595fa90ep182838e3ad4893fd@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Ryan Hope wrote:

> commit 85adafcf5d18e58c60d9fdbb718abe9149661736
> Author: Ryan Hope <rmh3093@gmail.com>
> Date:   Fri Jun 12 12:17:54 2009 -0400
> 
>     fix ttm kconfig

Thanks I've merged this into the patchset.

Dave.

> 
> diff --git a/drivers/gpu/drm/ttm/Makefile b/drivers/gpu/drm/ttm/Makefile
> index 0686829..299a73c 100644
> --- a/drivers/gpu/drm/ttm/Makefile
> +++ b/drivers/gpu/drm/ttm/Makefile
> @@ -6,4 +6,4 @@ ttm-y := ttm_agp_backend.o ttm_memory.o ttm_tt.o ttm_bo.o \
>         ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o
> 
> 
> -obj-m += ttm.o
> +obj-$(CONFIG_DRM_TTM) += ttm.o
> 
> ------------------------------------------------------------------------------
> Crystal Reports - New Free Runtime and 30 Day Trial
> Check out the new simplified licensing option that enables unlimited
> royalty-free distribution of the report engine for externally facing 
> server and web deployment.
> http://p.sf.net/sfu/businessobjects
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
> 
