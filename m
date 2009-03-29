Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZC2P6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZC2P6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZC2P6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:58:42 -0400
Received: from gw.goop.org ([64.81.55.164]:60540 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZC2P6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:58:41 -0400
Message-ID: <49CF9AAE.2010509@goop.org>
Date: Sun, 29 Mar 2009 08:58:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.30 Xen merge plan (what's in xen.git)
References: <49C915A3.3020809@goop.org> <20090324174859.GB31117@elte.hu>
In-Reply-To: <20090324174859.GB31117@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Branches with non-trivial non-Xen changes:
>>
>> push2/x86/paravirt
>>
>>    Allow preemption while doing a lazy mmu update.
>>     
>
> That's probably OK, just a bit late. If Thomas signs off on them 
> then i guess it might be OK later in the window - he's the one who 
> was struggling with paravirt lazy mmu fallout in the past. Thomas?
>   

Those patches were actually in response to PeterZ's (and NickP+AKPM) 
concerns about adding preempt-disabled section to 
apply_to_page_range().  He's acked them now.

Thanks,
    J
