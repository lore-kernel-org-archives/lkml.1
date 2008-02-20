Return-Path: <linux-kernel-owner+w=401wt.eu-S933573AbYBTXro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573AbYBTXro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYBTXrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:47:35 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:42343 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbYBTXre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:47:34 -0500
Date: Wed, 20 Feb 2008 17:47:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: BUG?: "Cannot map mmconfig aperture"
In-reply-to: <fa.ta6yFP+Jk2cm3xbIaPPD8L82kEs@ifi.uio.no>
To: Diego Calleja <diegocg@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Message-id: <47BCBBFA.9030004@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ta6yFP+Jk2cm3xbIaPPD8L82kEs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> I get the following new message in my dmesg:
> 
> [    0.155476] ACPI: bus type pci registered
> [    0.155567] PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support.
> [    0.161149] PCI: Cannot map mmconfig aperture for segment 0
> [    0.161181] PCI: Using configuration type 1
> [    0.165980] ACPI: EC: Look up EC in DSDT
> 
> when previously i'd have:
> 
> [    0.156577] PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support.
> [    0.166403] PCI: Using MMCONFIG at e0000000 - efffffff
> [    0.166407] PCI: Using configuration type 1
> [    0.171548] ACPI: EC: Look up EC in DSDT
> 
> 
> No idea if this is a regression or not, or what it means, the system works well.
> git-bisect says the problem cames from:
> 
> commit c31c7d4844ea4817692ae16bf70f9c96c05a50eb
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Feb 18 20:54:14 2008 +0100
> 
>     x86: CPA, fix alias checks

Yeah, sounds like a regression.
