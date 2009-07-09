Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbZGIAEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbZGIAEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZGIAEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:04:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44156 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbZGIAEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:04:36 -0400
Date: Thu, 9 Jul 2009 01:04:34 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: dri-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 36/44] includecheck fix: include/drm, drm_memory.h
In-Reply-To: <1247068169.4382.99.camel@ht.satnam>
Message-ID: <alpine.DEB.2.00.0907090104170.20307@skynet.skynet.ie>
References: <1247063308.4382.12.camel@ht.satnam> <1247068169.4382.99.camel@ht.satnam>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> fix the following 'make includecheck' warning:
> 
>   include/drm/drm_memory.h: linux/vmalloc.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Dave Airlie <airlied@redhat.com>

Dave.
> ---
>  include/drm/drm_memory.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/include/drm/drm_memory.h b/include/drm/drm_memory.h
> index 63e425b..15af9b3 100644
> --- a/include/drm/drm_memory.h
> +++ b/include/drm/drm_memory.h
> @@ -44,8 +44,6 @@
>  
>  #if __OS_HAS_AGP
>  
> -#include <linux/vmalloc.h>
> -
>  #ifdef HAVE_PAGE_AGP
>  #include <asm/agp.h>
>  #else
> 
