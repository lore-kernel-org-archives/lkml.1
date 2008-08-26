Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYHZXAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYHZXAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYHZXAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:00:34 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:25624 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYHZXAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:00:32 -0400
X-IronPort-AV: E=Sophos;i="4.32,273,1217808000"; 
   d="scan'208";a="69760669"
Message-ID: <48B48B11.8050000@cisco.com>
Date: Tue, 26 Aug 2008 16:00:33 -0700
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com>	 <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>	 <200808261111.19205.rusty@rustcorp.com.au>	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>	 <20080826183051.GB10925@cs181140183.pp.htv.fi>	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>	 <20080826205916.GB11734@cs181140183.pp.htv.fi>	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
In-Reply-To: <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> On Tue, Aug 26, 2008 at 5:04 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> 
>> And embedded people (the ones that might care about 1% code size) are the
>> ones that would also want smaller stacks even more!
> 
> This is something I never understood - embedded devices are not going
> to run more than a few processes and 4K*(Few Processes)
>  IMHO is not worth a saving now a days even in embedded world given
> falling memory prices. Or do I misunderstand?

Embedded applications span a huge range of sizes, from the very small devices to 
which you refer, to quite complex devices. The cable settop boxes we develop have 
over a hundred interrupt sources, typically run 250-300 threads, and have 192+ 
MiB of memory. For all that, we are very cost sensitive and are under constant 
pressure to come up with reliable ways to save memory.

> Parag
--
David VomLehn


