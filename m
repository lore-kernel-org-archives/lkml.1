Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbYD2TqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbYD2TqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYD2Tp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:45:57 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39756 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbYD2Tp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:45:56 -0400
Date: Tue, 29 Apr 2008 22:45:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>, paulus@samba.org
Cc: Tony Breeds <tony@bakeyournoodle.com>,
       Christian Kujau <lists@nerdbynature.de>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: pmac_newworld undefined
Message-ID: <20080429194517.GC2898@cs181133002.pp.htv.fi>
References: <alpine.DEB.1.10.0804271951190.11017@sheep.housecafe.de> <20080428042044.GX20457@bakeyournoodle.com> <20080428193324.GC13400@uranus.ravnborg.org> <20080429133514.GA30524@cs181133002.pp.htv.fi> <20080429191753.GA32685@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080429191753.GA32685@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 09:17:53PM +0200, Sam Ravnborg wrote:
>...
> So something like:
> 
> config PPC32_NVRAM
> 	bool
> 	depends on NVRAM
> 
> obj-$(CONFIG_PPC32_NVRAM) += nvram.o
> obj-$(CONFIG_NVRAM)       += nvram.o
> 
> Or did you have another solution in mind?

I start to understand the problem, and I'm currently wondering why 
powerpc uses CONFIG_NVRAM although the code CONFIG_NVRAM enables on 
other platforms is not enabled on powerpc.

Can we rename it and move drivers/char/generic_nvram.c under 
arch/powerpc/ ?

Can some powerpc person bring some background what's going on and why 
it's this way?

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

