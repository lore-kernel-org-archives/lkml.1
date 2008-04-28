Return-Path: <linux-kernel-owner+w=401wt.eu-S965020AbYD1Rup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020AbYD1Rup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935772AbYD1RuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:50:08 -0400
Received: from main.gmane.org ([80.91.229.2]:54475 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935514AbYD1RuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:50:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: x86: 4kstacks default
Date: Mon, 28 Apr 2008 13:56:51 -0400
Message-ID: <48160FE3.6000401@tmr.com>
References: <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B3FCF.1090207@firstfloor.org> <20080420133007.GB1899@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
X-Gmane-NNTP-Posting-Host: pool-68-236-140-141.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20080420133007.GB1899@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Apr 20, 2008 at 03:06:23PM +0200, Andi Kleen wrote:
>> Willy Tarreau wrote:
>> ...
>>> I have nothing against changing the default setting to 4k provided that
>>> it is easy to get back to the save setting
>> So you're saying that only advanced users who understand all their
>> CONFIG options should have the safe settings? And everyone else
>> the "only explodes once a week" mode?
>>
>> For me that is exactly the wrong way around.
>>
>> If someone is sure they know what they're doing they can set whatever
>> crazy settings they want (given there is a quick way to check
>> for the crazy settings in oops reports so that I can ignore those), but
>> the default should be always safe and optimized for reliability.
> 
> That means we'll have nearly zero testing of the "crazy setting" and 
> when someone tries it he'll have a high probability of running into some
> problems.
> 
> Such a "crazy setting" shouldn't be offered to users at all.
> 
> We should either aim at 4k stacks unconditionally for all 32bit 
> architectures with 4k page size or don't allow any architecture
> to offer 4k stacks.
> 
I have suggested before that the solution is to allocate memory in 
"stack size" units (obviously must be a multiple of the hardware page 
size). The reason allocation fails is more often fragmentation than 
actual lack of memory, or so it has been reported.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

