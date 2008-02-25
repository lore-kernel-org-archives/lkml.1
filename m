Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbYBYTkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbYBYTkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYBYTkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:40:21 -0500
Received: from www.tglx.de ([62.245.132.106]:47794 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbYBYTkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:40:19 -0500
Date: Mon, 25 Feb 2008 20:39:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: Clocksource tsc is always unstable with 2.6.25-* kernels and
 CONFIG_NO_HZ=y on my box
In-Reply-To: <47C2F350.1060107@googlemail.com>
Message-ID: <alpine.LFD.1.00.0802252031180.7583@apollo.tec.linutronix.de>
References: <fa.FpheN5sIQ5rxoLHYuhxxf6uauVs@ifi.uio.no> <47C24517.7010204@shaw.ca> <alpine.LFD.1.00.0802250839240.7583@apollo.tec.linutronix.de> <47C2F350.1060107@googlemail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Gabriel C wrote:
> >>> Booting nohz=off fixes that.
> >>>
> >>> Another strange thing is when I try to boot that kernel with
> >>> clocksource=acpi_pm it just hangs.

What happens if you add clocksource=acpi_pm and nohz=off to the kernel
commandline ?

> >> Please post your full dmesg output.
> > 
> > Yes please.
>
> dmesg's from 2.6.25-rc3 witch nohz={on,off} , lspci , dmidecode and
> the used config for this kernel can be found there :
>
> http://frugalware.org/~crazy/dmesg/lara/

Hmm. Nothing really obvious.

Thanks,
	tglx
