Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbYBYEbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbYBYEbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 23:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYBYEba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 23:31:30 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8394 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYBYEb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 23:31:28 -0500
Date: Sun, 24 Feb 2008 22:33:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Clocksource tsc is always unstable with 2.6.25-* kernels and
 CONFIG_NO_HZ=y on my box
In-reply-to: <fa.FpheN5sIQ5rxoLHYuhxxf6uauVs@ifi.uio.no>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>, Thomas Gleixner <tglx@linutronix.de>
Message-id: <47C24517.7010204@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
References: <fa.FpheN5sIQ5rxoLHYuhxxf6uauVs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
> 
> I noticed tsc is always marked unstable on my box with 2.6.25* , 2.6.24 is fine.
> 
> ..
> 
> [    0.825760] ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 22 (level, low) -> IRQ 22
> [    0.805755] Switched to high resolution mode on CPU 1
> [    0.794244] Switched to high resolution mode on CPU 2
> [    0.766968] Switched to high resolution mode on CPU 3
> [    1.083944] Switched to high resolution mode on CPU 0
> [   15.388792] Clocksource tsc unstable (delta = 9373391604 ns)
> [   15.714648] Time: acpi_pm clocksource has been installed.
> 
> ..
> 
> Booting nohz=off fixes that.
> 
> Another strange thing is when I try to boot that kernel with clocksource=acpi_pm it just hangs.
> 
> config is attached.
> 
> Please let me know if you need more infos / want me to try patches or anything else.

Please post your full dmesg output.
