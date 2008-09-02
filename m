Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYIBNxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYIBNxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYIBNxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:53:39 -0400
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:53247
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYIBNxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:53:38 -0400
X-Greylist: delayed 1882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2008 09:53:38 EDT
Date: Tue, 2 Sep 2008 15:22:12 +0200
From: Henk Vergonet <Henk.Vergonet@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Move map_to_7segment.h to include/linux
Message-ID: <20080902132212.GA15741@god.dyndns.org>
References: <20080827.232913.119238767.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827.232913.119238767.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 11:29:13PM +0900, Atsushi Nemoto wrote:
> The map_to_7segment.h provides generic 7segment LED mappings and is
> designed to be used by other drivers.  Moving it to common area will
> make it more usable.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Henk Vergonet <henk.vergonet@gmail.com>
> ---
> This is renaming patch.  I can send no-rename patch if requested.
> 
>  drivers/input/misc/yealink.c                       |    2 +-
>  .../input/misc => include/linux}/map_to_7segment.h |    2 --
>  2 files changed, 1 insertions(+), 3 deletions(-)
>  rename {drivers/input/misc => include/linux}/map_to_7segment.h (99%)
> 
> diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
> index facefd3..11b5c7e 100644
> --- a/drivers/input/misc/yealink.c
> +++ b/drivers/input/misc/yealink.c
> @@ -52,8 +52,8 @@
>  #include <linux/module.h>
>  #include <linux/rwsem.h>
>  #include <linux/usb/input.h>
> +#include <linux/map_to_7segment.h>
>  
> -#include "map_to_7segment.h"
>  #include "yealink.h"
>  
>  #define DRIVER_VERSION "yld-20051230"
> diff --git a/drivers/input/misc/map_to_7segment.h b/include/linux/map_to_7segment.h
> similarity index 99%
> rename from drivers/input/misc/map_to_7segment.h
> rename to include/linux/map_to_7segment.h
> index a424094..db45f7c 100644
> --- a/drivers/input/misc/map_to_7segment.h
> +++ b/include/linux/map_to_7segment.h
> @@ -1,6 +1,4 @@
>  /*
> - * drivers/usb/input/map_to_7segment.h
> - *
>   * Copyright (c) 2005 Henk Vergonet <Henk.Vergonet@gmail.com>
>   *
>   * This program is free software; you can redistribute it and/or
> -- 
> 1.5.6.3
> 
