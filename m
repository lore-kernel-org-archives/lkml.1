Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbXDZOEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbXDZOEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXDZOEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:04:55 -0400
Received: from rtr.ca ([64.26.128.89]:4542 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbXDZOEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:04:54 -0400
Message-ID: <4630B183.1000905@rtr.ca>
Date: Thu, 26 Apr 2007 10:04:51 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <20070425235718.66b71f01@the-village.bc.nu> <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org> <20070426012454.3495b5d8@the-village.bc.nu> <alpine.LFD.0.98.0704251808150.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704251808150.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> See? Two *totally* different cases. They have *nothing* in common. Not the 
> call sequence, not the logic, not *anything*.

Except that both methods cannot rely upon hot-pluggable devices
still being present on resume/restore.  It is exceptionally common
to unplug all USB/firewire cables, mouse, keyboard, docking cables etc..
after a machine is in S2R state.

Cheers
