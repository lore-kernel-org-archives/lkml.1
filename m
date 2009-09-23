Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbZIWM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbZIWM7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZIWM7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:59:24 -0400
Received: from server78.greatnet.de ([83.133.96.102]:43701 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZIWM7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:59:23 -0400
Message-ID: <4ABA1B9C.9070302@nachtwindheim.de>
Date: Wed, 23 Sep 2009 14:59:08 +0200
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: khali@linux-fr.org, jbarnes@virtousgeek.org, linux-pci@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Crash on reading the whole PCI config of PIIX4 SMBus
References: <4AB8F142.9090609@nachtwindheim.de> <20090922231839.GA20656@pengutronix.de>
In-Reply-To: <20090922231839.GA20656@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang schrieb:
> On Tue, Sep 22, 2009 at 05:46:10PM +0200, Henrik Kretzschmar wrote:
>
>   
>> at boot time my system (Wincor/Nixdorf Beetle D1) sometimes crashs while loading the i2c-piix4 driver.
>>     
>
> Have you checked if you have the latest BIOS for this machine? Sometimes
> PCI-problems got fixed there...
>
>   
Thanks for you fast replies,

the latest BIOS (05/08) is already installed, so no fixing can be expected that way


I tested my killer-commands at the other box @home with no crashes.

The commands _work_ with a coldstarted Linux and i2c-piix not loaded,
so the only thing I can do is blacklisting it and renounce sensors support,
having a good a argument for a new hardware aquisition. :)

For completness the message with the SMBus revision, which is not the pci-revision, is:

SMBus Host Controller at 0x1040, revision 0


The "?" at the interrupt line of lspci is a little strange:

>> Interrupt: pin ? routed to IRQ 9

looking at lspci -x -s 7.3 I can see that PCI_INTERRUPT_PIN == 0 

I cant see that i2p-piix does any interrupts, refering /proc/irq/9/spurious

The driver says:
 
Using Interrupt SMI# for SMBus

I'm not sure, but my box @home has the same lspci output with the "?".

So long, thanks for help.



