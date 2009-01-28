Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZA1KU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZA1KU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZA1KUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:20:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:58028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZA1KUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:20:18 -0500
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, avi@redhat.com,
       Marcelo Tosatti <mtosatti@redhat.com>
Message-Id: <A6E711C3-9127-4B57-9BD2-0C00D773C8EA@suse.de>
From: Alexander Graf <agraf@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090128015149.791e10dd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: linux-next: Tree for January 23 (kvm)
Date: Wed, 28 Jan 2009 11:20:16 +0100
References: <20090123184826.f2c91472.sfr@canb.auug.org.au> <497A29D0.2010307@oracle.com> <20090128015149.791e10dd.akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28.01.2009, at 10:51, Andrew Morton wrote:

> On Fri, 23 Jan 2009 12:34:24 -0800 Randy Dunlap <randy.dunlap@oracle.com 
> > wrote:
>
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> News:  I will be on leave next week, so there will probably be no
>>> linux-next release until Feb 2.
>>>
>>> Changes since 20090122:
>>
>>
>> kvm changes cause this build error on i386:
>>
>> when kvm is built as module:
>> ERROR: "__moddi3" [arch/x86/kvm/kvm.ko] undefined!
>>
>> or when kvm is built into the kernel image:
>> lapic.c:(.text+0x19276): undefined reference to `__moddi3'
>>
>>
>> I guess it's this line:
>> 	ns = ktime_to_ns(remaining) % apic->timer.period;
>>
>
> dammit, I just spent N minutes hunting down the same thing in
> the Jan 26 linux-next :(
>

Yeah, Clemens Foss posted a real fix on kvm@vger already.

Sorry for the fuss :-).

Alex
