Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYDTLza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYDTLza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 07:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYDTLzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 07:55:19 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55143 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbYDTLzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 07:55:19 -0400
Date: Sun, 20 Apr 2008 14:54:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420115455.GJ1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <20080420120250.4f496861@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080420120250.4f496861@the-village.bc.nu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 12:02:50PM +0100, Alan Cox wrote:
> > The code in the kernel that gets the fewest coverage at all are our 
> > error paths, and some vendor might try 4k stacks, validate it works in 
> > all use cases - and then it will blow up in some error condition he 
> > didn't test.
> 
> Which you won't fix by changing the x86 defaults.

Stuff like nfsd, xfs and raid is covered by the x86 defaults.

It's not a 100% coverage, but quite much.

> More of a problem in
> embedded small devices is the 8K allocation failing in the first place -
> plus 4K x 80 processes == lots.
> 
> > And from a QA point of view the only way of getting 4k thoroughly tested 
> > by users, and well also tested in -rc kernels for catching regressions 
> > before they get into stable kernels, is if we get 4k stacks enabled 
> > unconditionally on i386.
> 
> At which point some distros will simply patch it back no doubt.

Red Hat seems to get usable kernels with 4k for some years?

If we get whatever is still missing for 4k working once and then the 
coverage of all i386 -rc testers for noticing new issues immediately
there should be no stability reason for distros to patch it back in.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

