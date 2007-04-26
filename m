Return-Path: <linux-kernel-owner+w=401wt.eu-S1031291AbXDZP6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031291AbXDZP6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbXDZP6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:58:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbXDZP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:58:34 -0400
Date: Thu, 26 Apr 2007 08:56:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Johannes Berg <johannes@sipsolutions.net>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070426112641.GS17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704260855380.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg>
 <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz>
 <1177585897.6814.49.camel@johannes.berg> <20070426111645.GR17387@elf.ucw.cz>
 <1177586850.6814.52.camel@johannes.berg>
 <20070426112641.GS17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Pavel Machek wrote:
> 
> Yes, probably will. The other option is to break existing 32-bit
> userspace, which is a bit more common AFAICT.

And *this* is why kernel/userspace things simply should not be done.

It's simply better to do things entirely in the kernel. Because you add 
bugs and complications otherwise, and doing it in the kernel allows you 
to just switch things around.

As it is, it appears that user-space suspend is just broken whichever way 
we turn.

		Linus
