Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYDTNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYDTNaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 09:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYDTNac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 09:30:32 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46035 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbYDTNab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 09:30:31 -0400
Date: Sun, 20 Apr 2008 16:30:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Willy Tarreau <w@1wt.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420133007.GB1899@cs181133002.pp.htv.fi>
References: <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B3FCF.1090207@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <480B3FCF.1090207@firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 03:06:23PM +0200, Andi Kleen wrote:
> Willy Tarreau wrote:
>...
> > I have nothing against changing the default setting to 4k provided that
> > it is easy to get back to the save setting
> 
> So you're saying that only advanced users who understand all their
> CONFIG options should have the safe settings? And everyone else
> the "only explodes once a week" mode?
> 
> For me that is exactly the wrong way around.
> 
> If someone is sure they know what they're doing they can set whatever
> crazy settings they want (given there is a quick way to check
> for the crazy settings in oops reports so that I can ignore those), but
> the default should be always safe and optimized for reliability.

That means we'll have nearly zero testing of the "crazy setting" and 
when someone tries it he'll have a high probability of running into some
problems.

Such a "crazy setting" shouldn't be offered to users at all.

We should either aim at 4k stacks unconditionally for all 32bit 
architectures with 4k page size or don't allow any architecture
to offer 4k stacks.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

