Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZBTXbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZBTXbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbZBTXbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:31:13 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:34269 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZBTXbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Jh9xEW9Ci/2LDnoy10EdK9+exz84wMljjmRmj1MXO3+nr6W1zppjBHa69Ji12PLlZA
         DTRBrtfMBHTINmfvl/tlTqGRBvrBpE6Y9/9jxwLmOTLhzFnfyuG9yBm0g4iB65bV8VVH
         f2vk7Lml2tG76oxC+zgzg1Ml5vhxa7oQkevJ8=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <499F3709.2050501@linux.vnet.ibm.com>
References: <20090121185021.GA8852@elte.hu>
	 <499DD4BE.2000704@linux.vnet.ibm.com> <20090220081040.GA11490@elte.hu>
	 <499F30F4.509@linux.vnet.ibm.com> <1235170078.4736.42.camel@laptop>
	 <499F3709.2050501@linux.vnet.ibm.com>
Date: Sat, 21 Feb 2009 00:24:53 +0100
Message-ID: <7c86c4470902201524i413adea4udb4637da1053ffb5@mail.gmail.com>
Subject: Re: [announce] Performance Counters for Linux, v6
From: stephane eranian <eranian@googlemail.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 12:04 AM, Corey Ashford
<cjashfor@linux.vnet.ibm.com> wrote:
>
>
> Peter Zijlstra wrote:
>>
>> On Fri, 2009-02-20 at 14:38 -0800, Corey Ashford wrote:
>>>
>>> There may be other non-event-related changes that will not be handled
>>> quite as well in this way.  In the original email I hinted at that we may
>>> want an option for mmap'd sample buffers at some point, and so I'm not clear
>>> how you'd provide an ABI to request mmap'd buffers (you would probably need
>>> to be able to request the size and get back a pointer to the mmap'd buffer).
>>>  Would this be done through a special sys_perf_counter_open call?  Or
>>> through a subsequent ioctl call on the group leader after an open (which
>>> requires the counters to be initially disabled), etc.
>>
>> What's stopping a regular mmap() call using the fd obtained from
>> sys_perf_counter_open() ?
>
> Perhaps nothing.  I don't know why it didn't occur to me that this could be
> done.  If PCL supports this, great!
>
That has always been the way, I thought this could be done with PCL.
Except that I don't know who decides the size of the mmap().
