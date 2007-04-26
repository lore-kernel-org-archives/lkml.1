Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXDZNUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXDZNUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbXDZNUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:20:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38207 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754670AbXDZNUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:20:05 -0400
Date: Thu, 26 Apr 2007 14:14:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
Message-ID: <20070426141423.20aa88ec@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0704251915460.9964@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	<alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	<20070425202741.GC17387@elf.ucw.cz>
	<alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	<20070425214420.GG17387@elf.ucw.cz>
	<alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
	<20070425235718.66b71f01@the-village.bc.nu>
	<alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
	<20070425235235.GN17387@elf.ucw.cz>
	<alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org>
	<20070426001414.GO17387@elf.ucw.cz>
	<alpine.LFD.0.98.0704251734320.9964@woody.linux-foundation.org>
	<463008A2.9020301@zytor.com>
	<alpine.LFD.0.98.0704251915460.9964@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The PCI spec for controlling DMA is really pretty nasty. You can disable 
> it in the PCI config word, of course, but that usually just messes up the 
> device entirely.

And some devices ignore it. Some of the older Cyrix stuff I have appears
not to care how the master bit is set.

