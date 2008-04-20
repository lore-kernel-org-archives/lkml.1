Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbYDTOWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbYDTOWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760021AbYDTOV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:21:57 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33888 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759672AbYDTOV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:21:56 -0400
Date: Sun, 20 Apr 2008 17:21:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420142131.GD1899@cs181133002.pp.htv.fi>
References: <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <20080420120250.4f496861@the-village.bc.nu> <20080420115455.GJ1595@cs181133002.pp.htv.fi> <20080420123731.7282bb16@the-village.bc.nu> <20080420121803.GK1595@cs181133002.pp.htv.fi> <480B4DB4.8070107@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <480B4DB4.8070107@sandeen.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 09:05:40AM -0500, Eric Sandeen wrote:
> Adrian Bunk wrote:
> 
> > But the more users will get 4k stacks the more testing we have, and the 
> > better both existing and new bugs get shaken out.
> > 
> > And if there were only 4k stacks in the vanilla kernel, and therefore 
> > all people on i386 testing -rc kernels would get it, that would give a 
> > better chance of finding stack regressions before they get into a 
> > stable kernel.
> 
> Heck, maybe you should make it 2k by default in all -rc kernels; that
> way when people run -final with the 4k it'll be 100% bulletproof, right?
>  'cause all those piggy drivers that blow a 2k stack will finally have
> to get fixed?

I'm arguing for aiming at having all 32bit architectures with 4k page 
size using the same stack size. Not for having -rc kernels differ from 
release kernels.

>  Or leave it at 2k and find a way to share pages for
> stacks, think how much memory you could save and how many java threads
> you could run!

The only architecture that already defaults to 4k stacks is m68knommu, 
and I doubt they do it for many java threads...

>...
> -Eric
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

