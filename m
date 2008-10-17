Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYJQNaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYJQNaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYJQNaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:30:18 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55371 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbYJQNaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:30:17 -0400
Date: Fri, 17 Oct 2008 16:30:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: akpm@linux-foundation.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/mca-legacy.h: Fix the warning
Message-ID: <20081017133002.GA32584@cs181140183.pp.htv.fi>
References: <20081017132044.GA22457@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081017132044.GA22457@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 09:20:44PM +0800, Jianjun Kong wrote:
> Fix the warning of annotation.
> 
>   CC    drivers/mca/mca-legacy.o
>   In file included from drivers/mca/mca-legacy.c:31:
>   include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy -
>   please move your driver to the new sysfs api"
>   In file included from drivers/mca/mca-legacy.c:31:
>   include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy -
>   please move your driver to the new sysfs api"
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
> ---
>  include/linux/mca-legacy.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/mca-legacy.h b/include/linux/mca-legacy.h
> index 7a3aea8..e349f2b 100644
> --- a/include/linux/mca-legacy.h
> +++ b/include/linux/mca-legacy.h
> @@ -9,7 +9,7 @@
>  
>  #include <linux/mca.h>
>  
> -#warning "MCA legacy - please move your driver to the new sysfs api"
> +/* warning "MCA legacy - please move your driver to the new sysfs api" */
>...

NAK

If you want to get rid of the warning fix the drivers still using the 
obsolete API.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

