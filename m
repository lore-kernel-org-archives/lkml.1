Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbXFLXik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbXFLXik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXFLXia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:38:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33115 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752377AbXFLXia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:38:30 -0400
Date: Wed, 13 Jun 2007 01:38:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fix placement of inline keyword.
Message-ID: <20070612233842.GJ3588@stusta.de>
References: <20070612233035.GA24146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070612233035.GA24146@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 07:30:35PM -0400, Dave Jones wrote:

> gcc gets whiney about the placement of 'inline' at some warning levels.
>...

Since most of them are in C files, can you remove these when you are at it?
 
> --- linux-2.6.20.noarch/arch/ia64/sn/pci/pcibr/pcibr_ate.c~	2007-04-04 19:34:50.000000000 -0400
> +++ linux-2.6.20.noarch/arch/ia64/sn/pci/pcibr/pcibr_ate.c	2007-04-04 19:34:56.000000000 -0400
> @@ -138,7 +138,7 @@ static inline u64 __iomem *pcibr_ate_add
>  /*
>   * Update the ate.
>   */
> -void inline
> +inline void
>  ate_write(struct pcibus_info *pcibus_info, int ate_index, int count,
>  	  volatile u64 ate)
>  {
>...

And some are even non-static inline functions...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

