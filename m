Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbYGQSqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbYGQSqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbYGQSqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:46:13 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:7516 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbYGQSqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:46:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.26-rc9: ACPI PCI irq routing on NUMA? + early_ioremap trouble
Date: Thu, 17 Jul 2008 12:45:31 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, venkatesh.pallipadi@intel.com,
       "Huang Ying" <ying.huang@intel.com>, "Andi Kleen" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <19f34abd0807060647k54490088uf8859d8a1646fd41@mail.gmail.com>
In-Reply-To: <19f34abd0807060647k54490088uf8859d8a1646fd41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171245.31641.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 July 2008 07:47:19 am Vegard Nossum wrote:
> I have produced a config which doesn't boot correctly on either of my
> computers with v2.6.26-rc9.
> 
> The first problem is with my laptop, which hangs on boot, see
> screenshot (sorry for the bad quality, I was in a hurry):
> http://folk.uio.no/vegardno/linux/DSCF3026.JPG
> 
> I figured there's something wrong with ACPI PCI irq routing as I'm
> missing a message that shows up in my usual configs:
> 
> calling  ide_scan_pcibus+0x0/0xf0
> ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
>     --- HERE: ---
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
>     ----
> ICH8M: not 100% native mode: will probe irqs later
> 
> ...and as can be seen in the screenshot, ide-cd "lost interrupt".
> Unfortunately, I don't have a serial line on this machine, so it's
> hard to get the full log. (Maybe I can try netconsole, it seems to be
> up by the time this happens.)

If you could get netconsole working and collect the complete
console log from both the working config and the broken one,
that would help a lot.

Bjorn
