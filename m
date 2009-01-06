Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZAFPZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZAFPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZAFPZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:25:50 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53947 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750836AbZAFPZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:25:50 -0500
Message-ID: <496377FA.6050507@sgi.com>
Date: Tue, 06 Jan 2009 07:25:46 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/11] x86: cleanup remaining cpumask_t ops in smpboot
 code
References: <1231222512.3235.6.camel@jaswinder.satnam>	 <1231223480.3235.22.camel@jaswinder.satnam> <4963645A.1040201@sgi.com> <3f9a31f40901060628t3bffe020v6e70c5d6cf17f51e@mail.gmail.com>
In-Reply-To: <3f9a31f40901060628t3bffe020v6e70c5d6cf17f51e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> Hi Mike,
> 
> On Tue, Jan 6, 2009 at 7:32 PM, Mike Travis <travis@sgi.com> wrote:
>> I'll look closer but I had assumed that these masks would not be
>> used for UP configurations (it did not get any compile errors
>> with the allnoconfig).  In fact, any access to these masks for
>> UP would be unnecessary since there are no callouts, the boot
>> cpu is assumed initialized, and it has no siblings.  So the
>> masks are specific to SMP.
>>
> 
> If it is specific to SMP then:
> CONFIG_X86_64 should be CONFIG_X86_64_SMP
> CONFIG_X86_32 should be CONFIG_X86_32_SMP
> 
> I am in the process of cleaning smp.h and moving out non-smp from
> smp.h as per Ingo's suggestion.
> 
> I am planning to move cpumask related things to asm/cpumask.h
> 
> Is this OK to you.
> 
> --
> JSR

It's fine with me, anything to untangle the web we've weaved... ;-)

Thanks,
Mike
