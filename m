Return-Path: <linux-kernel-owner+w=401wt.eu-S965442AbXCFSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965442AbXCFSEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965446AbXCFSEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:04:40 -0500
Received: from gw.goop.org ([64.81.55.164]:54712 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965442AbXCFSEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:04:38 -0500
Message-ID: <45EDAD33.7070903@goop.org>
Date: Tue, 06 Mar 2007 10:04:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
References: <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2F53.2040101@goop.org> <20070306092636.GC26073@elte.hu> <45ED99F8.9060705@goop.org> <20070306171813.GA21218@elte.hu>
In-Reply-To: <20070306171813.GA21218@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> My suggestion would be for Linux to make only a /single/ external 
>>> ABI promise: VMI. (and we can extend it with higher-level paravirt 
>>> ops, etc.)
>>>       
>> "VMI" is not a promise, it's just three letters.  It doesn't even mean 
>> the same thing now as it did 12 months ago.  Turning "VMI" from three 
>> letters into anything remotely like a promise is a huge amount of work 
>> which requires:
>>
>>    1. someone actually sit down and fully document what all those
>>       entrypoints are going to do
>>    2. everyone to implement them
>>    3. someone to test that all the implementations conform to the
>>       document (bearing in mind that if anyone is going to go to all
>>       this effort, they're going to use this with non-Linux guests)
>>    4. and repeat all that every subsequent update
>>     
>
> There's no process needed. The only thing needed is to treat the Linux 
> implementation as the reference design, documentation and specification. 
>   
What Linux implementation?  Linux as a client of this interface?  So
everyone implements as much of the ABI as needed to get Linux to boot?

We have an excellent example of how well that model works.  Thousands of
BIOS implementations all implementing just enough of the various BIOS
interfaces to get Windows to boot.  And then all fall over as soon as
you try to be non-Windows, or even a later version of Windows.  It's the
path to being absolutely inundated with legacy crap.

You're arguing that we should have a single hypervisor ABI in order to,
among other things, reduce the test matrix, and yet the ABI is entirely
defined by testing to see how well a given implementation runs some
random version of Linux.  And if Linux wants to use that interface in a
different way, everyone is supposed to magically keep up.

And all this is supposed to be managed by multiple disparate independent
out-of-tree implementations?

Yep, I want a pony too.

> Treat it as we treat the Linux system calls. We promise not to change 
> them.

OK.  How does that help with "not hindering Linux's development"?

    J
