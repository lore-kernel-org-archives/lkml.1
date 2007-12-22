Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXLVOAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXLVOAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 09:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbXLVOAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 09:00:05 -0500
Received: from puffyports.org ([213.61.174.206]:50124 "EHLO puffyports.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbXLVOAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 09:00:04 -0500
Subject: Re: drive appears confused; hda lost interrupt; IRQ169: nobody
	cared
From: Michael Schmitt <mschmitt@unixkiste.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071221131812.7d362e7e@the-village.bc.nu>
References: <1198237821.4577.63.camel@elara.tcw.local>
	 <20071221131812.7d362e7e@the-village.bc.nu>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 14:59:54 +0100
Message-Id: <1198331994.5964.12.camel@elara.tcw.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan

thanks for the input! This BIOS seems to be current, there are just two
beta BIOS available and as in the changelog there is nothing IRQ related
written (there is almost nothing in it) I don't think I want to flash
one of them, but here are the various options I tried:

noapic > the one and the same thing, but this time (as classic PIC is
used) nobody cared about IRQ 11.

acpi=noirq > the same, this time IRQ 185

pci=routeirq > the same as right above

pci=nobios > without irqpoll hda DMA expire, IRQ lost, with irqpoll IRQ
169 again

pci=noacpi > the same as two and three above

irqfixup (instead of irqpoll) > hda DMA timer expire, IRQ lost

I may have missed some options to try out, do you suggest some else?
I've read kernel-parameters.txt and tried to find reasonable options...
But what I don't get... how tragic are those "irq N nobody cared" and
"drive appears confused" messages as I don't see a negative impact? And
at the end, what do they mean? If an IRQ is disabled I thought the
device behind it would not work anymore... but...
Maybe I will give the two beta BIOS a try nevertheless.

greetings
Michael

Am Freitag, den 21.12.2007, 13:18 +0000 schrieb Alan Cox: 
> > I changed the mainboard of this computer recently to this P4P800-SE from
> > a rubish oem SIS chipset board and I had the problems right away,
> > starting with kernel 2.6.18 but problems persist even with 2.6.23
> > (Debian kernels).
> 
> Your IRQ routing appears broken. That is usually a BIOS problem.
> 
> > So, my main concern is that there may be some sort of data corruption
> > even if I don't see them right now but as the messages seem to be very
> > serious... dunno. Any thoughts?
> 
> Check for BIOS uupdates also try playing with the various pci irq
> routing, APIC and acpi options. 
> 
> Alan

