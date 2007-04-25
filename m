Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbXDYXBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbXDYXBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbXDYXBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:01:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499AbXDYXBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:01:36 -0400
Date: Wed, 25 Apr 2007 16:00:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <462FD9A1.5060700@redhat.com>
Message-ID: <alpine.LFD.0.98.0704251558400.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <462FD9A1.5060700@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Chuck Ebbert wrote:
> 
> Freeze is a subset of suspend, isn't it? (It might be an empty subset
> in some cases.)

NO IT IS NOT!

Yes, you are parroting Pavel, but he can say it a million times, and it's 
*still* not true.

That's like saying "read() is a subset of write(), isn't it?" On many 
devices, they share some of the setup, like writing the same sector 
registers with the same values.

Does that make them subsets of each other?

Or does it mean that they *may* use some of the same common helper 
functions for some devices?

			Linus
