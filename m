Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbXCCIY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbXCCIY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 03:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXCCIY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 03:24:29 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:4493 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbXCCIY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 03:24:29 -0500
Message-ID: <45E93035.2070509@qumranet.com>
Date: Sat, 03 Mar 2007 10:22:13 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>,
       git@vger.kernel.org
Subject: Re: [patch] KVM: T60 resume fix
References: <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <20070302113920.GB9367@mellanox.co.il>
In-Reply-To: <20070302113920.GB9367@mellanox.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2007 08:22:20.0174 (UTC) FILETIME=[0FD452E0:01C75D6D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
>> Quoting Ingo Molnar <mingo@elte.hu>:
>> Subject: [patch] KVM: T60 resume fix
>> From: Ingo Molnar <mingo@elte.hu>
>>
>> my T60 laptop does not resume correctly due to KVM attempting to send an 
>> IPI to a CPU that might be down (or not up yet). (Doing so also triggers 
>> the send_IPI_mask_bitmask() warning in arch/i386/kernel/smp.c, line 
>> 732.)
>>
>> with this fix applied my laptop does not hang during resume.
>>
>> [ KVM will have to disable/enable virtualization on the CPU itself that
>>   goes down / comes up, not via an IPI sent from the requesting CPU. ]
>>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>     
>
> Since I don't normally have kvm loaded, this patch is unlikely
> to help me, is that right?
>
>   

That is correct.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

