Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0CAVmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:42:36 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:40534 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0CAVmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:42:35 -0500
Date: Mon, 1 Mar 2010 13:40:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>,
       Arnd Bergmann <arnd@arndb.de>, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net, David Airlie <airlied@linux.ie>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DRM: fix headers_check warnings
Message-Id: <20100301134024.829ef2ad.randy.dunlap@oracle.com>
In-Reply-To: <1267262856.26906.12.camel@i7.satnam>
References: <1267262856.26906.12.camel@i7.satnam>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B8C3479.0166:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 14:57:36 +0530 Jaswinder Singh Rajput wrote:

> 
> Fixed following headers_check warnings:
>   CHECK   include/drm (14 files)
>  include/drm/drm_mode.h:84: found __[us]{8,16,32,64} type without #include <linux/types.h>
>  include/drm/i915_drm.h:119: found __[us]{8,16,32,64} type without #include <linux/types.h>
>  include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
>  include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
>  include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Kristian Høgsberg <krh@bitplanet.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dave Airlie <airlied@redhat.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks much.

> ---
>  include/drm/drm_mode.h   |    2 ++
>  include/drm/i915_drm.h   |    1 +
>  include/drm/mga_drm.h    |    1 +
>  include/drm/radeon_drm.h |    1 +
>  include/drm/via_drm.h    |    1 +
>  5 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
> index c5ba163..c5aa66d 100644
> --- a/include/drm/drm_mode.h
> +++ b/include/drm/drm_mode.h
> @@ -27,6 +27,8 @@
>  #ifndef _DRM_MODE_H
>  #define _DRM_MODE_H
>  
> +#include <linux/types.h>
> +
>  #define DRM_DISPLAY_INFO_LEN	32
>  #define DRM_CONNECTOR_NAME_LEN	32
>  #define DRM_DISPLAY_MODE_LEN	32
> diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
> index b64a8d7..5cf7f5b 100644
> --- a/include/drm/i915_drm.h
> +++ b/include/drm/i915_drm.h
> @@ -27,6 +27,7 @@
>  #ifndef _I915_DRM_H_
>  #define _I915_DRM_H_
>  
> +#include <linux/types.h>
>  #include "drm.h"
>  
>  /* Please note that modifications to all structs defined here are
> diff --git a/include/drm/mga_drm.h b/include/drm/mga_drm.h
> index 3ffbc47..ae23df9 100644
> --- a/include/drm/mga_drm.h
> +++ b/include/drm/mga_drm.h
> @@ -35,6 +35,7 @@
>  #ifndef __MGA_DRM_H__
>  #define __MGA_DRM_H__
>  
> +#include <linux/types.h>
>  #include "drm.h"
>  
>  /* WARNING: If you change any of these defines, make sure to change the
> diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
> index 39537f3..459ff45 100644
> --- a/include/drm/radeon_drm.h
> +++ b/include/drm/radeon_drm.h
> @@ -33,6 +33,7 @@
>  #ifndef __RADEON_DRM_H__
>  #define __RADEON_DRM_H__
>  
> +#include <linux/types.h>
>  #include "drm.h"
>  
>  /* WARNING: If you change any of these defines, make sure to change the
> diff --git a/include/drm/via_drm.h b/include/drm/via_drm.h
> index fd11a5b..23880b0 100644
> --- a/include/drm/via_drm.h
> +++ b/include/drm/via_drm.h
> @@ -24,6 +24,7 @@
>  #ifndef _VIA_DRM_H_
>  #define _VIA_DRM_H_
>  
> +#include <linux/types.h>
>  #include "drm.h"
>  
>  /* WARNING: These defines must be the same as what the Xserver uses.
> -- 


---
~Randy
