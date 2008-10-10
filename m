Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbYJJUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbYJJUoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbYJJUoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:44:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbYJJUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:44:10 -0400
Message-ID: <48EFBE65.60505@zytor.com>
Date: Fri, 10 Oct 2008 13:43:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
References: <20081009234705.GA20540@elte.hu>	 <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org>	 <20081010152631.GB26231@elte.hu> <20081010155830.GA4767@elte.hu> <19f34abd0810101339x66afc6d3mb6efa1a52e186816@mail.gmail.com>
In-Reply-To: <19f34abd0810101339x66afc6d3mb6efa1a52e186816@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 
> Note: If you don't want the double underscores anywhere, this patch is
> not enough.
> 
> For example:
> 
>> -#endif /* ASM_X86__MACH_DEFAULT__MACH_TIMER_H */
>> +#endif /* _ASM_X86_MACH_DEFAULT__MACH_TIMER_H */
> 
> There are also a few non-trivial changes, which could break with a
> naïve sed script. So I suggest to simply revert it, it's a lot safer
> than trying to patch it up in the last minute.
> 
> I'm obviously also sorry for causing this problem in the first place... *blush*
> 

Double underscores aren't the problem per se, the problem is having 
changes _ASM_X86_ to ASM_X86__ and therefore violating the namespace.

That being said, I don't personally like the double underscores.

	-hpa
