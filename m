Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbXGJP7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbXGJP7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbXGJP7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:59:45 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:46440 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbXGJP7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:59:45 -0400
Message-ID: <4693ACD6.9040807@s5r6.in-berlin.de>
Date: Tue, 10 Jul 2007 17:59:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 10 Jul 2007, Stefano Rivoir wrote:
>> 2.6.22 hangs at boot on my box. Here attached a original dmesg from 2.6.21,
>> and a copy of it where it stops on 2.6.22
...
>    The next thing that you got on 2.6.21 after the point it hangs was 
>    apparently 
> 
> 	..
> 	input: PC Speaker as /class/input/input1
> 	ieee1394: Initialized config rom entry `ip1394'
> 	ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
> 	ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
> 	usbcore: registered new interface driver hiddev
> 	..
> 
>    so you could _try_ to disable the PC speaker or firewire, and see 
>    what's up. Did you switch from the old firewire drivers to the new one, 
>    for example?

His .config has the old 1394 drivers enabled and the new ones disabled.

>    Or if you didn't, try it.

Or actually disable one driver or subsystem in each test boot.  (Also
parport, USB...)
-- 
Stefan Richter
-=====-=-=== -=== -=-=-
http://arcgraph.de/sr/
