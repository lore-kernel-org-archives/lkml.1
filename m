Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXLaXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXLaXnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 18:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXLaXnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 18:43:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41819 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbXLaXnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 18:43:11 -0500
Message-ID: <47797E39.7090208@zytor.com>
Date: Mon, 31 Dec 2007 15:41:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<4778FE42.6010003@keyaccess.nl>	<20071231155600.0b06552c@the-village.bc.nu>	<200712312122.13739.linux@rainbow-software.org>	<20071231212525.6940ce70@the-village.bc.nu>	<47796363.8060604@zytor.com> <20071231232412.64347335@the-village.bc.nu>
In-Reply-To: <20071231232412.64347335@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> However, assuming a bus clock of 6 MHz should be safe (167 ns).
> 
> Agreed - or ISA timings directly. Boxes using WD80x3 are not going to
> have a TSC so might as well stick with port 0x80 as they have done just
> fine for the past 15 years.
> 
>> None of this really helps with *memory-mapped* 8390, though, since 
>> memory mapped writes can be posted.  Putting any IOIO transaction in the 
> 
> ISA isn't posted only PCI.
> 
> PCI 8390 clones seem to be a mix of ASICs and 8390x chips with
> some quite disgusting FPGA glue logic.
> 

ISA isn't posted no, but on several chipsets the upstream PCI bus will 
post MMIO writes to ISA space regardless of the spec.

	-hpa
