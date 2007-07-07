Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbXGGR7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbXGGR7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 13:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXGGR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 13:59:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53701 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752721AbXGGR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 13:59:09 -0400
Date: Sat, 7 Jul 2007 19:59:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Willy Tarreau <w@1wt.eu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Dave Jones <davej@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707175939.GI3492@stusta.de>
References: <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706233827.GC13125@redhat.com> <20070707001008.GV3492@stusta.de> <y0mvecwusj3.fsf@ton.toronto.redhat.com> <20070707170157.GH3492@stusta.de> <20070707172011.GB943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070707172011.GB943@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 07:20:12PM +0200, Willy Tarreau wrote:
> On Sat, Jul 07, 2007 at 07:01:57PM +0200, Adrian Bunk wrote:
> > On Sat, Jul 07, 2007 at 11:45:20AM -0400, Frank Ch. Eigler wrote:
>...
> > You always have to decide between some debug code and some small bit of 
> > performance. There's a reason why options to disable things like BUG() 
> > or printk() are in the kernel config menus hidden behind CONFIG_EMBEDDED
> > although they obviously have some performance impact.
> 
> It is not for the CPU performance they can be disabled, but for the code
> size which is a real problem on embedded system. While you often have
> mem/cpu_mhz ratios around 1GB/1GHz on servers and desktops, you more often
> have ratios like 16MB/500MHz which is 1:32 of the former. That's why you
> optimize for size at the expense of speed on such systems.

The latter is not true for my two examples.

CONFIG_PRINTK=n, CONFIG_BUG=n will obviously make the kernel both 
smaller and faster. [1]

> Regards,
> Willy

cu
Adrian

[1] faster due to less code to execute and positive cache effects due to 
    the smaller code [2]
[2] whether the "faster" is big enough that it is in any way measurable 
    is a different question

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

