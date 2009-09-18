Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZIRA7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZIRA7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbZIRA7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:59:09 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:37385 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755145AbZIRA7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:59:08 -0400
Message-ID: <4AB2DB3F.5050009@snapgear.com>
Date: Fri, 18 Sep 2009 10:58:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] Actually show KiB rather than pages in "Freeing initrd
 memory:" message on m68knommu.
References: <20090915165037.GA23702@csclub.uwaterloo.ca> <20090917154941.GG23702@csclub.uwaterloo.ca>
In-Reply-To: <20090917154941.GG23702@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lennart,

Lennart Sorensen wrote:
> Fix "Freeing initrd memory:" message m68knommu to show kilobytes as
> claimed rather than number of pages.
> 
> Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

Looks good. I have applied to the m68knommu git tree.

Regards
Greg


> diff --git a/arch/m68knommu/mm/init.c b/arch/m68knommu/mm/init.c
> index b1703c6..f3236d0 100644
> --- a/arch/m68knommu/mm/init.c
> +++ b/arch/m68knommu/mm/init.c
> @@ -162,7 +162,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>  		totalram_pages++;
>  		pages++;
>  	}
> -	printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
> +	printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
>  }
>  #endif
>  

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
