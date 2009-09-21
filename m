Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZIUMqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZIUMqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZIUMqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:46:16 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:43106 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbZIUMqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:46:15 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 08:46:15 EDT
Message-ID: <4AB773F6.7090901@petalogix.com>
Date: Mon, 21 Sep 2009 14:39:18 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] Actually show KiB rather than pages in "Freeing initrd
 memory:" message on microblaze.
References: <20090915165037.GA23702@csclub.uwaterloo.ca> <20090917154623.GD23702@csclub.uwaterloo.ca> <20090917154706.GE23702@csclub.uwaterloo.ca>
In-Reply-To: <20090917154706.GE23702@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added to next branch.

There were some problems which I fixed.
1. long first description
2. missing microblaze: at the beginning
3. line longer than 80chars

Thanks,
Michal


Lennart Sorensen wrote:
> Fix "Freeing initrd memory:" message on microblaze to show kilobytes as
> claimed rather than number of pages.
> 
> Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
> 
> diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
> index f207f1a..ed5f96b 100644
> --- a/arch/microblaze/mm/init.c
> +++ b/arch/microblaze/mm/init.c
> @@ -180,7 +180,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>  		totalram_pages++;
>  		pages++;
>  	}
> -	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
> +	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
>  }
>  #endif
>  

