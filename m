Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZK1WBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZK1WBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 17:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZK1WBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 17:01:53 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:51488 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZK1WBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 17:01:53 -0500
Date: Sat, 28 Nov 2009 17:01:59 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: PROBLEM: BUG: Constant freezes and kernel panics on a quad core
 (with dumps)
In-reply-to: <4B119D95.6090806@gmail.com>
To: Bruno Barberi Gnecco <brunobg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4B119DD7.8020303@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <4B119D95.6090806@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd think this is a hardware problem. Some things that have caused me 
similar grief in the past:

Bad IDE cable
Bad SATA cable
Bad power supply
Bad motherboard
Bad memory (memtest doesn't necessarily access things the same way as 
the kernel)
Bad cards (pci, agp, whatever)
Any of the above with loose connections
And did I mention bad power supply?

Bruno Barberi Gnecco wrote:
> Summary: a PC I'm testing is unstable and freezing often. Freezes 
> occur in various situations, including under no load (not even the X 
> running). Dumps are provided below.
>
> Sometimes it's a plain freeze, sometimes a kernel panic with the 
> blinking leds and a dump. It seems the problem is related to memory, 
> most of the messages are related to null memory references (see more 
> below). System ran once for several hours before freezing.
>
> * System specification: Intel Core 2 Quad Q9550 @ 2.83GHz, 4GB DDR3, 
> Motherboard Asus P5QC. No overclocking.
>
> * Tested under the following kernels/distros, all had the bug. Since I 
> used their vanilla kernels, I'm not posting a copy of the .configs:
>
> - 2.6.27.7-smp (slackware 12.2 hugesmp kernel; distro heavily 
> updated), 32 bits
> - 2.6.29.6-smp (slackware 13.0 hugesmp kernel; fresh install), both 32 
> and 64 bits
> - 2.6.29.6-nosmp (slackware 13.0 huge kernel; fresh install), both 32 
> and 64 bits
> - 2.6.31-14-generic SMP (ubuntu 9.10 netbook remix live cd), 32 bits
>
> * Here are some screen dumps (sorry, no serial cable for a text dump).
>
> http://ultraxs.com/share-208E_4B118ED2.html
> http://ultraxs.com/share-2FDD_4B118ED2.html
> http://ultraxs.com/share-D0D9_4B118ED2.html
> http://ultraxs.com/share-498F_4B118ED2.html
> http://ultraxs.com/share-0AD8_4B118ED2.html
>
> * Turning off ACPI and APIC, either through the BIOS or through kernel 
> parameters did not help, even when only one processor is recognized.
>
> * I ran memtest and no errors were detected. I completed the tests 
> three times.
>
> * Nothing is ever output to the logs.
>
> * A sure way to get a freeze is to recompile the kernel, but the 
> freeze does not happen at the same point of the compilation and I 
> can't even say if the compilation triggers the bug or if it's just a 
> coincidence and the compilation just takes long enough for it to happen.
>
> * Any other information, testing or debugging you need, just ask. I 
> just can't use the PC, it usually freezes within minutes. Please CC 
> any replies to me [brunobg at gmail]. Thank you very much for any help.
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

