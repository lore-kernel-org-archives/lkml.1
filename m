Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbXDZCJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbXDZCJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 22:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXDZCJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 22:09:38 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbXDZCJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 22:09:37 -0400
Message-ID: <463008A2.9020301@zytor.com>
Date: Wed, 25 Apr 2007 19:04:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <20070425235718.66b71f01@the-village.bc.nu> <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org> <20070425235235.GN17387@elf.ucw.cz> <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org> <20070426001414.GO17387@elf.ucw.cz> <alpine.LFD.0.98.0704251734320.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704251734320.9964@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 26 Apr 2007, Pavel Machek wrote:
>> Ok, I guess I'll have nightmares of DMA controllers doing DMAs from
>> chips that are no longer there tonight.
> 
> Umm. Welcome to the 21st century: we don't do that "separate DMA 
> controller" thing any more. All devices do their own DMA.
> 

That was the 1990s.  On a brand new server system:

00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA
Engine (rev b1)

For better or worse, slave DMA seems to be making a comeback of sorts.
Not to mention all kinds of embedded crap^Whardware with optimized DMA
engines which look nothing like PCI at all.

	-hpa
