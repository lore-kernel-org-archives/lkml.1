Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXBEUSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXBEUSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbXBEUSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:18:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:54094 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbXBEUSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:18:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NxlQWwzEanN9pGM4FrbtA17EU9+9Qsl6DQJUAUQY0s5G57X9CdwCHyHp7zro/sjVswbtY5ZabMNAZ0OC5z2QKAVr2vVnt/qePB7cwxo8NDTMxVFtPm5nK3AYDm6n6/a32Nr1gzwpTQ1FUXUNqFp2QxtaJ9ruu5eaU/6y0gRo2/c=
Date: Mon, 5 Feb 2007 23:18:04 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: jeffrey.t.kirsher@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] ixgb: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205201804.GC11055@martell.zuzino.mipt.ru>
References: <20070205165429.GD3896@Ahmed> <20070205165933.GL3896@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165933.GL3896@Ahmed>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 06:59:33PM +0200, Ahmed S. Darwish wrote:
> A patch to use ARRAY_SIZE macro already defined in kernel.h.

Remove it and use ARRAY_SIZE instead.

> --- a/drivers/net/ixgb/ixgb_param.c
> +++ b/drivers/net/ixgb/ixgb_param.c
> @@ -245,7 +245,7 @@ ixgb_validate_option(int *value, struct ixgb_option *opt)
>  	return -1;
>  }
>  
> -#define LIST_LEN(l) (sizeof(l) / sizeof(l[0]))
> +#define LIST_LEN(l) ARRAY_SIZE(l)

