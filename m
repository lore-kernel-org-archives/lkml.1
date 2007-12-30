Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXL3Ssh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXL3Ssh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXL3Ss3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:48:29 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49295 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752510AbXL3Ss2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:48:28 -0500
Date: Sun, 30 Dec 2007 18:39:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230183927.5a5a3c42@the-village.bc.nu>
In-Reply-To: <4777E010.7030703@keyaccess.nl>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<20071230153818.1a554a7e@the-village.bc.nu>
	<20071230160132.GA14311@elte.hu>
	<20071230164828.039916c8@the-village.bc.nu>
	<4777E010.7030703@keyaccess.nl>
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

On Sun, 30 Dec 2007 19:14:40 +0100
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 30-12-07 17:48, Alan Cox wrote:
> 
> > For processors with TSC I think we should aim for 2.6.25 to do this and 
> > to have the major other _p fixups done. I pity whoever does stuff like 
> > the scc drivers but most of the rest isn't too bad.
> 
> I'm by the way looking at drivers/net/wd.c which my 386 uses for its dual 
> mode NE2000/WD8013 clone ISA NIC and while it specifically needs no delay at 
> all it seems, the mixed use of out and outb_p seems to suggest that someone 
> once thought about that. Would you advice sticking in a udelay(2) manually 
> there?

I would need to dig out the documentation and NE2000 reference code if I
even still have them. From memory NE2K needs them but I don't know
offhand if the WD80x3 devices do, or if only some of them do. It'll also
depend on the port - the DPRAM is different to the 8390.

Don Becker wrote the drivers and at the time he tuned them carefully for
performance so I would expect delays to be the ones needed

Alan
