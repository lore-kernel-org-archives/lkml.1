Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbXL3R5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbXL3R5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXL3R5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:57:39 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:50633 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXL3R5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:57:38 -0500
Message-ID: <4777DB4E.9080105@keyaccess.nl>
Date: Sun, 30 Dec 2007 18:54:22 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <20071230160751.GB26221@elte.hu> <4777C6E8.7060202@keyaccess.nl> <20071230170612.GA16502@elte.hu>
In-Reply-To: <20071230170612.GA16502@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 18:06, Ingo Molnar wrote:

> * Rene Herman <rene.herman@keyaccess.nl> wrote:

>> Real ISA systems will also generally respond faster to it than the 
>> unused port (this thing actually has an ISA bus but not VGA on it 
>> ofcourse) which means that "a perfect delay register" it is not. But 
>> yes, I have an actual Am386DX-40 with ISA VGA up and running which 
>> also doesn't care either way, about the ones in misc_32.c or anywhere 
>> else for that matter.
> 
> yeah - and that's typical of most _p() use: most of them are totally 
> bogus, but the global existence of the delay was used as a "it _might_ 
> break system" boogey-man against replacing it.

No delaying at all does break a few systems.

> so _IF_ we do any delay in x86 platform drivers, we at most do a delay 
> on the order of the round-trip latency to the same piece of hardware we 
> are handling.

Given that part of the problem is 2 MHz devices on a 8 MHz bus, you can't do 
this generally.

Rene.
