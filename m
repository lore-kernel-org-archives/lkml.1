Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYBPA1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYBPA1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYBPA1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:27:34 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:49753 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYBPA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:27:32 -0500
Message-ID: <47B62D97.9040608@oracle.com>
Date: Fri, 15 Feb 2008 16:25:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       torvalds@linux-foundation.org, jeff@garzik.org, davem@davemloft.net,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org> <20080212204813.GA21650@kroah.com> <20080215232308.GC31474@flint.arm.linux.org.uk> <20080215153732.a93caec7.akpm@linux-foundation.org> <20080215154724.132ad4f3.randy.dunlap@oracle.com> <20080216001712.GE31474@flint.arm.linux.org.uk>
In-Reply-To: <20080216001712.GE31474@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Fri, Feb 15, 2008 at 03:47:24PM -0800, Randy Dunlap wrote:
>> On Fri, 15 Feb 2008 15:37:32 -0800 Andrew Morton wrote:
>>> I wonder why I didn't see any of this - I build arm allmodconfig at least
>>> once a week, usually more frequently.
> 
> Basically, you don't build any of the PXA platforms, which is what was
> affected.
> 
>>> So either the offending patches weren't in my pile or arm allmodconfig is
>>> worse than I thought :(
>>>
>>> It really is in arch maintainers' best interest to keep their allmodconfig
>>> in good shape, for this reason.  arm's _isn't_ in good shape: the compile
>>> fails for several long-standing reasons (eg: no hope of building DRM) and I
>>> don't think the coverage is very broad either.
>> I think that Russell has said that allmodconfig isn't very realistic
>> for ARM, with its 70+ config files.  Nevertheless, having a usable
>> allmodconfig would be very helpful.
> 
> Which is quite impossible.  I've said all along that all*config is bad
> news for ARM and folk haven't listened.
> 
> allmodconfig can (and does) work on some platform configurations such as
> the one Andrew builds - which will be based on the Versatile platform.
> However, that doesn't get _any_ of the PXA SoC drivers scattered throughout
> the tree, the PXA SoC support in arch/arm/mach-pxa, none of the PXA platform
> support files.
> 
> If you built an allmodconfig PXA configuration, you'd get those, but you
> wouldn't get the OMAP SoC drivers, nor the ARM Primecell drivers found on
> ARMs Integrator, Versatile and Realview platforms and the Cirrus EP93xx
> SoCs.  Nor the Atmel AT91 drivers... and so the list goes on.
> 
> Each family of platforms are, unfortunately, quite distinct from each
> other.
> 

Does that mean that an artificial allarmconfig can't be made to build?
We clearly don't care whether it can boot or work, but we would just as
clearly like to be able to build more ARM stuff without N (N > 10) configs.

-- 
~Randy
