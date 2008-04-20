Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbYDTRTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbYDTRTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYDTRTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:19:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37275 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbYDTRTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:19:39 -0400
Message-ID: <480B7B1E.7010707@firstfloor.org>
Date: Sun, 20 Apr 2008 19:19:26 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca> <20080420133857.GB26536@1wt.eu> <480B50F1.8040309@firstfloor.org> <20080420164133.GB20694@logfs.org>
In-Reply-To: <20080420164133.GB20694@logfs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Sun, 20 April 2008 16:19:29 +0200, Andi Kleen wrote:
>> Only if you believe that 4K stack pages are a worthy goal.
>> As far as I can figure out they are not. They might have been
>> a worthy goal on crappy 2.4 VMs, but these times are long gone.
>>
>> The "saving memory on embedded" argument also does not 
>> quite convince me, it is unclear if that is really
>> a significant amount of memory on these systems and if that 
>> couldn't be addressed better (e.g. in running generally
>> less kernel threads).  I don't have numbers on this,
>> but then the people who made this argument didn't have any
>> either :) 
> 
> It is not uncommon for embedded systems to be designed around 16MiB.

But these are SoC systems. Do they really run x86?
(note we're talking about an x86 default option here)

Also I suspect in a true 16MB system you have to strip down
everything kernel side so much that you're pretty much outside
the "validated by testers" realm that Adrian cares about.

> When dealing in those dimensions, savings of 100k are substantial.  In
> some causes they may be the difference between 16MiB or 32MiB, which
> translates to manufacturing costs.  In others it simply means that the
> system can cache 

If you need the stack you don't have any less cache foot print.
If you don't need it you don't have any either.

-Andi
