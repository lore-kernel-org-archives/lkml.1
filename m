Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0BVW6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:58:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56946 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab0BVW6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:58:05 -0500
Message-ID: <4B830BD8.3090600@zytor.com>
Date: Mon, 22 Feb 2010 14:57:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: linux-next requirements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
References: <20100211195614.886724710@sbs-t61.sc.intel.com>	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>	<20100222090710.GA31357@elte.hu>	<20100222203319.8bd497a2.sfr@canb.auug.org.au>	<20100222102745.GJ20844@elte.hu> <20100222224752.0cbd5807.sfr@canb.auug.org.au>
In-Reply-To: <20100222224752.0cbd5807.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 03:47 AM, Stephen Rothwell wrote:
>>
>> So this kind of linux-next requirement causes the over-testing of code that 
>> doesnt get all that much active usage, plus it increases build testing 
>> overhead 10-fold. That, by definition, causes the under-testing of code that 
>> _does_ matter a whole lot more to active testers of the Linux kernel.
> 
> Which is why linux-next does *not* require that. (Did you read the part
> of my email that you removed?)  I do point out when build failures occur
> (that is part of the point of linux-next after all) but they only upset
> me when it is clear that the code that has been changed was not built at
> all (which doesn't happen too often).
>  
>> Which is a problem, obviously.
> 
> It certainly would be.
> 
> Maybe I don't understand what you are trying to say.

Sounds like a big source of confusion to me.

Either which way, Roland has a mitigation patch -- which basically
disables the broken bits of PARISC until the PARISC maintainers fix it.
 What is the best way to handle that kind of stuff?

	-hpa
