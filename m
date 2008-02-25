Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYBYHlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYBYHlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYBYHlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:41:12 -0500
Received: from www.tglx.de ([62.245.132.106]:58164 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYBYHlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:41:11 -0500
Date: Mon, 25 Feb 2008 08:40:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robert Hancock <hancockr@shaw.ca>
cc: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: Clocksource tsc is always unstable with 2.6.25-* kernels and
 CONFIG_NO_HZ=y on my box
In-Reply-To: <47C24517.7010204@shaw.ca>
Message-ID: <alpine.LFD.1.00.0802250839240.7583@apollo.tec.linutronix.de>
References: <fa.FpheN5sIQ5rxoLHYuhxxf6uauVs@ifi.uio.no> <47C24517.7010204@shaw.ca>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Robert Hancock wrote:
> Gabriel C wrote:
> > Hi,
> > 
> > I noticed tsc is always marked unstable on my box with 2.6.25* , 2.6.24 is
> > fine.
> > 
> > ..
> > 
> > [    0.825760] ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 22 (level, low) ->
> > IRQ 22
> > [    0.805755] Switched to high resolution mode on CPU 1
> > [    0.794244] Switched to high resolution mode on CPU 2
> > [    0.766968] Switched to high resolution mode on CPU 3
> > [    1.083944] Switched to high resolution mode on CPU 0
> > [   15.388792] Clocksource tsc unstable (delta = 9373391604 ns)

Doh, this looks like the acpi_pm timer is not working at all.

> > [   15.714648] Time: acpi_pm clocksource has been installed.
> > ..
> > 
> > Booting nohz=off fixes that.
> > 
> > Another strange thing is when I try to boot that kernel with
> > clocksource=acpi_pm it just hangs.

Which confirms the above.
 
> > config is attached.
> > 
> > Please let me know if you need more infos / want me to try patches or
> > anything else.
> 
> Please post your full dmesg output.

Yes please.

Thanks,
	tglx
