Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbYARRab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbYARRab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbYARR1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:49 -0500
Received: from gw.goop.org ([64.81.55.164]:34593 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbYARR1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:48 -0500
Message-ID: <4790E193.20003@goop.org>
Date: Fri, 18 Jan 2008 09:27:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       huang ying <huang.ying.caritas@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Stephen Tweedie <sct@redhat.com>
Subject: Re: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced
 bt_ioremap - enhance bt_ioremap
References: <1200375906.3505.30.camel@caritas-dev.intel.com> <1200646105.17230.28.camel@cthulhu.hellion.org.uk> <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com> <4790BD90.9060303@zytor.com> <1200671665.9891.45.camel@localhost.localdomain> <20080118162257.GB6819@elte.hu>
In-Reply-To: <20080118162257.GB6819@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ian Campbell <ijc@hellion.org.uk> wrote:
>
>   
>>> Eric Biederman had a patchset that makes a PAE kernel use PAE page 
>>> tables from the start.  That is really The Right Thing[TM].
>>>       
>> That's much saner than dup'ing up the early ioremap stuff to support 
>> both PAE and non-PAE at runtime, which is about the only idea I've got 
>> for fixing this right now...
>>
>> I think I'll just back out the early_ioremap patches locally for now 
>> and wait for Eric's patches which should cause the fix for this issue 
>> to just fall out in the wash.
>>     
>
> Eric's patchset is nowhere near being submitted - he _had_ a patchset. 
> So this needs to be fixed by the Xen-guest folks. (if the easiest/best 
> fix is to pick up Eric's patchset, then plese do it so)
>   

This is only relevent to dom0 isn't it?  sct is looking at that at the 
moment.  

    J
