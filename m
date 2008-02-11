Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYBKMGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYBKMGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYBKMGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:06:23 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34939 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYBKMGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:06:23 -0500
Date: Mon, 11 Feb 2008 14:06:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: parisc - error: 'VMALLOC_START' undeclared...
Message-ID: <20080211120615.GB7119@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080211111953.GA18652@ska.dandreoli.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080211111953.GA18652@ska.dandreoli.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 12:19:53PM +0100, Domenico Andreoli wrote:
> Hi,
> 
> in building 2.6.25-rc1:
> 
>   CC      arch/parisc/kernel/asm-offsets.s
> In file included from include/asm/pgtable.h:13,
>                  from arch/parisc/kernel/asm-offsets.c:36:
> include/linux/mm.h: In function 'is_vmalloc_addr':
> include/linux/mm.h:243: error: 'VMALLOC_START' undeclared (first use in this function)
> include/linux/mm.h:243: error: (Each undeclared identifier is reported only once
> include/linux/mm.h:243: error: for each function it appears in.)
> include/linux/mm.h:243: error: 'VMALLOC_END' undeclared (first use in this function)
> make[1]: *** [arch/parisc/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 
> bisected to commit 9e2779fa281cfda13ac060753d674bbcaa23367e. it looks
> like is_vmalloc_addr() did not arrive down to the parisc stuff.

Kyle, you said you had a patch for this issue.

> cheers,
> Domenico

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

