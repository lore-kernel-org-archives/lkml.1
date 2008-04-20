Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbYDTMTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbYDTMTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbYDTMSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:18:30 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:56181 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbYDTMS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:18:28 -0400
Date: Sun, 20 Apr 2008 15:18:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420121803.GK1595@cs181133002.pp.htv.fi>
References: <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <20080420120250.4f496861@the-village.bc.nu> <20080420115455.GJ1595@cs181133002.pp.htv.fi> <20080420123731.7282bb16@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080420123731.7282bb16@the-village.bc.nu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 12:37:31PM +0100, Alan Cox wrote:
> On Sun, 20 Apr 2008 14:54:55 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Red Hat seems to get usable kernels with 4k for some years?
> 
> Yes and I think it is the right setting.
> 
> > If we get whatever is still missing for 4k working once and then the 
> > coverage of all i386 -rc testers for noticing new issues immediately
> > there should be no stability reason for distros to patch it back in.
> 
> You don't get to dictate to people however. 

Everyone is free to patch whatever stacksize he wants into his kernel.

But the more users will get 4k stacks the more testing we have, and the 
better both existing and new bugs get shaken out.

And if there were only 4k stacks in the vanilla kernel, and therefore 
all people on i386 testing -rc kernels would get it, that would give a 
better chance of finding stack regressions before they get into a 
stable kernel.

If a distribution or user then wants to increase it that's his choice 
(and easy to do), but nothing the upstream kernel has to offer.

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

