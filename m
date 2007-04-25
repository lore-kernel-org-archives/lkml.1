Return-Path: <linux-kernel-owner+w=401wt.eu-S1423392AbXDYWsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423392AbXDYWsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423396AbXDYWsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:48:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423392AbXDYWsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:48:31 -0400
Message-ID: <462FD9A1.5060700@redhat.com>
Date: Wed, 25 Apr 2007 18:43:45 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Tell me, what does "suspend" do, and what does "freeze" (snapshot) do?
> 
> And name *one* thing that have in common.
> 
> I'll tell you: Nada. Zero. Zilch. Nothing.
> 
> "Freeze" for a disk is a total no-op. There is no DMA, there is no 
> nothing. In contrast, "suspend" for a disk is a totally valid operation.
> 

Freeze is a subset of suspend, isn't it? (It might be an empty subset
in some cases.)

