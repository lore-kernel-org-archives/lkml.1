Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbXEFVpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbXEFVpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbXEFVpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:45:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:49630 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbXEFVpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:45:20 -0400
Subject: Re: [-mm patch] get_unmapped_area: remove now unused ret variable
	(was Re: 2.6.21-mm1)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070506090333.GB29299@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	 <20070506090333.GB29299@slug>
Content-Type: text/plain
Date: Mon, 07 May 2007 07:45:07 +1000
Message-Id: <1178487908.6353.187.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-06 at 11:03 +0200, Frederik Deweerdt wrote:
> On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > 
> 
> mm/mmap.c:1393: warning: unused variable 'ret'
> 
> The get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch and
> get_unmapped_area-handles-map_fixed-in-generic-code.patch rendered the ret
> variable useless.

Ah good catch.. I wonder why my gcc didn't spot it...

> Regards,
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> diff --git a/mm/mmap.c b/mm/mmap.c
> index b0f6eb8..fabf7f4 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1390,7 +1390,6 @@ unsigned long
>  get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  		unsigned long pgoff, unsigned long flags)
>  {
> -	unsigned long ret;
>  	unsigned long (*get_area)(struct file *, unsigned long,
>  				  unsigned long, unsigned long, unsigned long);
>  

