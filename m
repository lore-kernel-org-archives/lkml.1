Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab0CLKtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:49:22 -0500
Received: from lucidpixels.com ([75.144.35.66]:57433 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757624Ab0CLKtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:49:21 -0500
Date: Fri, 12 Mar 2010 05:49:20 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous
 reboots
In-Reply-To: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Mar 2010, Justin Piszcz wrote:

> Hello,
>
> I am trying to figure out why a particular host using a Gigabyte motherboard
> (AMD) continues to crash, memory/CPU OK, voltages normal, I see this in
> the kernel log:
>
> [    0.138774] PCI: Using ACPI for IRQ routing
> [    0.138825] PCI: pci_cache_line_size set to 64 bytes
> [    0.138830] pci 0000:00:00.0: address space collision: [mem 
> 0xe0000000-0xffffffff 64bit] already in use
>
> If memory gets mapped into this space somehow, can that cause a spontaenous
> reboot?  What is the workaround for this problem?
>
> There are no PCI cards in this system, only a graphics card.
>
> I suppose the next things to try:
> apic=off
> lapic=off

Correction-
noapic
nolapic
