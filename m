Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbXL3Vqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbXL3Vqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXL3Vqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:46:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43288 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120AbXL3Vq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:46:29 -0500
Date: Sun, 30 Dec 2007 21:36:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230213623.410d480a@the-village.bc.nu>
In-Reply-To: <47780B93.4050606@reed.com>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<20071230153818.1a554a7e@the-village.bc.nu>
	<20071230160132.GA14311@elte.hu>
	<20071230164828.039916c8@the-village.bc.nu>
	<4777E010.7030703@keyaccess.nl>
	<20071230183927.5a5a3c42@the-village.bc.nu>
	<4777F297.9070207@keyaccess.nl>
	<alpine.LFD.1.00.0712301158410.32517@woody.linux-foundation.org>
	<47780B93.4050606@reed.com>
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

> Now what's interesting is that the outb to port 80 is *faster* than an 
> outb to an unused port, on my machine.  So there's something there - 
> actually accepting the bus transaction.   In the ancient 5150 PC, 80 was 

Yes and I even told you a while back how to verify where it is. From the
timing you get its not on the LPC bus but chipset core so pretty
certainly an SMM trap as other systems with the same chipset don't have
the bug. Probably all that is needed is a BIOS upgrade

Alan


