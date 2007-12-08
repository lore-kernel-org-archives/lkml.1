Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXLHVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXLHVKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLHVKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:10:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50391 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751592AbXLHVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:10:08 -0500
Date: Sat, 8 Dec 2007 21:04:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071208210427.535aa9a0@the-village.bc.nu>
In-Reply-To: <475B02E9.7000007@reed.com>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<475AEF8E.5040906@reed.com>
	<20071208195035.GA22497@one.firstfloor.org>
	<475B02E9.7000007@reed.com>
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

> The point here is that Linux is NOT using a defined-to-be "unused" 
> port.  It IS using the "diagnostic" port, and talking to a diagnostic 
> device that *is* used, and may be present.

Just like millions of other pieces of software from the same era. 

> 2) Start a background task with the maintainers of drivers to clean up 
> their code regarding these short delays for slow devices (note that it's 
> never because the *bus* is slow, but because the *device* is slow.)  
> Perhaps this could be helped by "deprecating" the _p calls and 
> suggesting an alternative that requires the coder to be precise about 
> what the delay is for, and how long it is supposed to be, perhaps on a 
> per-machine basis.

Send patches. For a lot of the devices we know what the requirements are
as its locked to ISA cycle times.

Alan
