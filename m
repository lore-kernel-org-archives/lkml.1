Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYIKNFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYIKNFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYIKNF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:05:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:34125 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYIKNF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cxkLmSYMUG8sPWSZW6Bpd1QfDccLhI6ULKOtaTY2Ce3IXJQV5vWqwvZtUhjTWcQOp6
         2/YM6EZ5svqqJoa12wYXA/ntMcyGRGDgdgnRv2WP+3txQFoTmYGyRaKgJoDWQyotbGVo
         KMhZHGZO7rU0uB5t19j191iEiNa3EfmDwduGg=
Date: Thu, 11 Sep 2008 09:05:22 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080911090103.ZZRA012@mailhub.coreip.homeip.net>
References: <20080813152459.4d6bb0cb@ephemeral> <20080815031435.GD9438@anvil.corenet.prv> <20080910175513.17d900bc@dev.queued.net> <20080911010124.79166d64@dev.queued.net> <20080911013209.3d7c70da@dev.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911013209.3d7c70da@dev.queued.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 01:32:09AM -0400, Andres Salomon wrote:
> 
> And here's the current touchpad driver after updating based upon your
> comments.
> 

Looks good. Care to respin it all thogether based on the attribute
change I requested so I can be sure I'm applying the latest version of
everything? Ummm....

> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index 7bbea09..fff0253 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -96,6 +96,16 @@ config MOUSE_PS2_TOUCHKIT
>  
>  	  If unsure, say N.
>  
> +config MOUSE_PS2_OLPC
> +	bool "OLPC PS/2 mouse protocol extension"
> +	depends on MOUSE_PS2 && OLPC

Are you sure it shoudl depend on OLPC? It looks like driver should
work on any box with PS/2 port. I understand that only OLPC has the
hardware installed but can this change?

Thanks!

-- 
Dmitry
