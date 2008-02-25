Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYBYQ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYBYQ5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYBYQ44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:56:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:22974 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYBYQ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:56:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=TNXWR3iIrcmuT/7sQnERslWOAY90DMQUzWzoBVpY37/k4ovrGpw78TjbO5lkiRFCMaCCVKFz2mFTzg7JcOfhbnRGK9VXMa6AQtWYAxo+WR1+wtNRQC3+AZvvXiLn/wwn4tfs8TWpscdbBaY3nOgpYfB0Innh3GtSkDJZSyF9Vu4=
Message-ID: <47C2F350.1060107@googlemail.com>
Date: Mon, 25 Feb 2008 17:56:48 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: Clocksource tsc is always unstable with 2.6.25-* kernels and
 CONFIG_NO_HZ=y on my box
References: <fa.FpheN5sIQ5rxoLHYuhxxf6uauVs@ifi.uio.no> <47C24517.7010204@shaw.ca> <alpine.LFD.1.00.0802250839240.7583@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802250839240.7583@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sun, 24 Feb 2008, Robert Hancock wrote:
>> Gabriel C wrote:
>>> Hi,
>>>
>>> I noticed tsc is always marked unstable on my box with 2.6.25* , 2.6.24 is
>>> fine.
>>>
>>> ..
>>>
>>> [    0.825760] ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 22 (level, low) ->
>>> IRQ 22
>>> [    0.805755] Switched to high resolution mode on CPU 1
>>> [    0.794244] Switched to high resolution mode on CPU 2
>>> [    0.766968] Switched to high resolution mode on CPU 3
>>> [    1.083944] Switched to high resolution mode on CPU 0
>>> [   15.388792] Clocksource tsc unstable (delta = 9373391604 ns)
> 
> Doh, this looks like the acpi_pm timer is not working at all.
> 
>>> [   15.714648] Time: acpi_pm clocksource has been installed.
>>> ..
>>>
>>> Booting nohz=off fixes that.
>>>
>>> Another strange thing is when I try to boot that kernel with
>>> clocksource=acpi_pm it just hangs.
> 
> Which confirms the above.
>  
>>> config is attached.
>>>
>>> Please let me know if you need more infos / want me to try patches or
>>> anything else.
>> Please post your full dmesg output.
> 
> Yes please.

dmesg's from 2.6.25-rc3 witch nohz={on,off} , lspci , dmidecode and the used config for this kernel can be found there :

http://frugalware.org/~crazy/dmesg/lara/

> 
> Thanks,
> 	tglx
> 


Regards,

Gabriel
