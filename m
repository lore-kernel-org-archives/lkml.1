Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYHZXqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYHZXqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYHZXq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:46:27 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41768 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbYHZXq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:46:26 -0400
Date: Wed, 27 Aug 2008 02:45:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080826234537.GD11734@cs181140183.pp.htv.fi>
References: <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org> <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com> <48B48B11.8050000@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48B48B11.8050000@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 04:00:33PM -0700, David VomLehn wrote:
> Parag Warudkar wrote:
>> On Tue, Aug 26, 2008 at 5:04 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>
>>> And embedded people (the ones that might care about 1% code size) are the
>>> ones that would also want smaller stacks even more!
>>
>> This is something I never understood - embedded devices are not going
>> to run more than a few processes and 4K*(Few Processes)
>>  IMHO is not worth a saving now a days even in embedded world given
>> falling memory prices. Or do I misunderstand?
>
> Embedded applications span a huge range of sizes, from the very small 
> devices to which you refer, to quite complex devices. The cable settop 
> boxes we develop have over a hundred interrupt sources, typically run 
> 250-300 threads, and have 192+ MiB of memory. For all that, we are very 
> cost sensitive and are under constant pressure to come up with reliable 
> ways to save memory.

As you say correctly the term "embedded" gets used for many different 
devices.

And if you have 192+ MiB of memory you have so much that all these 
kernel size discussions don't really matter.

> David VomLehn

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

