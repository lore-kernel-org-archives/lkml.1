Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZJ1RCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZJ1RCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZJ1RCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:02:20 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51498 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752683AbZJ1RCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:02:20 -0400
Message-ID: <4AE8792F.8070200@sgi.com>
Date: Wed, 28 Oct 2009 10:02:39 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <20091028033219.GE7744@basil.fritz.box> <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com> <20091028041159.GI7744@basil.fritz.box>
In-Reply-To: <20091028041159.GI7744@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
>> MAX_LOCAL_APIC was definitely an arbitrary choice here and has very little 
>> relevance.  scnlistprintf will protect against overflow, but we still need 
>> to decide upon a constant that will emit the most information possible 
>> while not overly polluting the printk and saving on bss, as you mentioned.  
>> I suspect we could agree on a value as little as 128 and it would work for 
>> the overwhelming majority (all?) of users.
> 
> For now at least seems reasonable to limit to 128 or so yes (and go
> back to the stack). if we ever have sparse apic ids for nodes 
> then that might change; but in this case could still just do
> a acpidump or teach the printer to be more clever and support
> strides.
> 
> It would be just good to have some indication in the output
> if there was a overflow.
> 
> -Andi
> 

I don't understand the importance of this when the memory is given back
after the system starts up anyway...?

Thanks,
Mike
