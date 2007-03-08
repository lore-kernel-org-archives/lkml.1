Return-Path: <linux-kernel-owner+w=401wt.eu-S1030822AbXCHWgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030822AbXCHWgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030826AbXCHWgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:36:22 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55610 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030822AbXCHWgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:36:21 -0500
Message-ID: <45F08FE4.5090909@vmware.com>
Date: Thu, 08 Mar 2007 14:36:20 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       tglx@linutronix.de, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       Daniel Arai <arai@vmware.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: hardwired VMI crap
References: <45EF175D.6030609@vmware.com> <45F07D07.5090003@goop.org> <20070308213458.GA24634@elte.hu> <200703082243.31659.ak@suse.de> <20070308223041.GB30113@elte.hu>
In-Reply-To: <20070308223041.GB30113@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>   
>> [...] And apparently the VMI version is the same, just with some short 
>> cuts. Are you just worried about the ->apic_write() hooks or about 
>> something else too?
>>     
>
> i'm worried about those "shot cuts" (which in essence create software 
> variants of silicon), the hooks, the hardwirings combined with the 
> hypervisor-side ABIs creating a rigid mess that is harmful to Linux. 
> paravirt_ops and the hooks gives a license for all hypervisor 'backends' 
> to deviate into random arbitrary directions and to create all their 
> separate 'virtual silicon' playgrounds with no regard to Linux 
> maintainability. And once this gets released, Linux has no choice but to 
> play along.
>   

What?  And creating a high level API which allows you to implement 
totally random silicon with oodles of quirks and obfuscated 
implementation requirements creates more maintainability how?  We tried 
to stay as close as possible to the hardware ABI on purpose, 
specifically so we don't need to introduce 100 new concepts into the kernel.

Zaccch
