Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXLHUcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXLHUcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXLHUcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:32:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58871 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752728AbXLHUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:32:30 -0500
Date: Sat, 8 Dec 2007 20:26:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071208202631.14b0f768@the-village.bc.nu>
In-Reply-To: <475AEF8E.5040906@reed.com>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<475AEF8E.5040906@reed.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In any case, my machine does not have an ISA bus.  Why should it?  It's 
> a laptop!

Yes it does. The branding spec said "No ISA bus" so it was renamed "LPC"
and hidden internally, but its alive and well.

> has already serviced the bus and delivered data!  Why put many 
> microseconds into the bus, locking out other ISA transactions (and PCI 
> maybe too) with an out to port 80?

Historically processors didn't have a high precision time source so it
was the normal way to do it on all PC operating systems

> Some of the code in linux is really nice, really clean, really 
> well-thought out.  Some is ... well, I'm not trolling for a fight.

Like all things, it doesn't always age well 8)
