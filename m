Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYBUHyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYBUHyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYBUHyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:54:01 -0500
Received: from www.tglx.de ([62.245.132.106]:40744 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbYBUHyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:54:00 -0500
Date: Thu, 21 Feb 2008 08:53:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Diego Calleja <diegocg@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: BUG?: "Cannot map mmconfig aperture"
In-Reply-To: <20080220223156.578e0a5d.diegocg@gmail.com>
Message-ID: <alpine.LFD.1.00.0802210853060.7583@apollo.tec.linutronix.de>
References: <20080220223156.578e0a5d.diegocg@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Diego Calleja wrote:

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

Hmm, that's confusing. Can you please provide a complete boot log ?

Thanks,

	tglx
