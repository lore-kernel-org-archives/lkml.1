Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbXL3Vhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbXL3Vhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbXL3Vhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:37:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36740 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753215AbXL3Vho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:37:44 -0500
Date: Sun, 30 Dec 2007 21:28:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230212820.0d53f389@the-village.bc.nu>
In-Reply-To: <20071230203417.GA12949@elte.hu>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<4777BDA5.4050203@keyaccess.nl>
	<alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
	<20071230203417.GA12949@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fact even io_delay=udelay would be wrong because any problem will be 
> less clearly triggerable and thus less bisectable/debuggable.

And if this eats someones disk because you drive the hardware out of spec
you are going to sit there and tell them to bisect it ? Lovely. 

Ingo - put the christmas wine away and have a coffee. Now think first.
You won't bisect obscure timing triggered problems, and the _p users are
almost all for hardware where performance doesn't matter one iota (eg
CMOS).

This isn't even all down to the chipset internal logic - several of my
boxes have external CMOS NVRAM/RTC chips which are probably the same
design (if a little smaller) as ten years ago.

io_delay = none is exactly the same thing as CPU overclocking. Hard to
debug, unpredictable and stupid.

Alan
