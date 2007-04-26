Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbXDZQ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbXDZQ3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXDZQ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:29:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbXDZQ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:29:21 -0400
Date: Thu, 26 Apr 2007 09:27:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Friesen <cfriesen@nortel.com>
cc: Johannes Berg <johannes@sipsolutions.net>, Pavel Machek <pavel@ucw.cz>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <4630CFE6.1050702@nortel.com>
Message-ID: <alpine.LFD.0.98.0704260924590.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg>
 <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz>
 <1177585897.6814.49.camel@johannes.berg> <20070426111645.GR17387@elf.ucw.cz>
 <1177586850.6814.52.camel@johannes.berg> <20070426112641.GS17387@elf.ucw.cz>
 <1177587308.6814.57.camel@johannes.berg> <4630CFE6.1050702@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Chris Friesen wrote:
> 
> I disagree...it's quite common.  I think its the standard way of doing things
> for ppc64, for instance.

It is, although most x86-64 installations seem to be 64-bit user space 
*if*you*install*from*scatch*.

Of course, at least some users (yeah, I've done it) started with a 32-bit 
CD they had lying around, and upgraded just the kernel. And I'm sure some 
distro out there just defaults to 32-bit binaries just because (in 
practice, you have to use a 32-bit firefox anyway if you want flash etc, 
so you need all the 32-bit libraries, so the argument might go that you 
might as well use 32-bit stuff for all the common stuff, and only 64-bit 
binaries when actually needed).

		Linus
