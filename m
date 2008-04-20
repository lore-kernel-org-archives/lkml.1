Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbYDTQED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbYDTQED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 12:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbYDTQDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 12:03:52 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39372 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbYDTQDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 12:03:51 -0400
Date: Sun, 20 Apr 2008 19:03:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420160327.GE1899@cs181133002.pp.htv.fi>
References: <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <20080420120250.4f496861@the-village.bc.nu> <20080420115455.GJ1595@cs181133002.pp.htv.fi> <20080420123731.7282bb16@the-village.bc.nu> <20080420121803.GK1595@cs181133002.pp.htv.fi> <480B4DB4.8070107@sandeen.net> <20080420084127.2fc324ec@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080420084127.2fc324ec@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 08:41:27AM -0700, Arjan van de Ven wrote:
>...
> yes. Adrian is waay off in the weeds on this one. Nobody but him is suggesting to remove
> 8Kb stacks. I think everyone else agrees that having both options is valuable; and there
> are better ways to find+fix stack bloat than removing this config option.

I'm not arguing for removing the option immediately, but long-term we 
shouldn't need it.

This comes from my experience of removing obsolete drivers for hardware 
for which also a more recent driver exists:
As long as there is some workaround (e.g. using an older driver or
8k stacks) the workaround will be used instead of the getting proper 
bug reports and fixes.

As far as I know all problems that are known with 4k stacks are some 
nested things with XFS in the trace.

If this class of issues would get fixed one day, why would it be 
valuable to also offer 8k stacks long-term? Especially weigthed
against the fact that with only 4k stacks we will have more people
running into stack problems in -rc kernels if any new ones pop up,
resulting in getting more such problems fixed during -rc.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

