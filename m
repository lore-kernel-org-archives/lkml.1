Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbXINONl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbXINONl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXINONd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:13:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:13990 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXINONc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=D3IayAMtIF3bjTo7mR1mqZBSSGpLh479jOMBcSFYzCtNK/VYEKVAkpYXWhYvTuhiFXdXfr46Jlccqolfb0dibQJyu1ddZqmFj/W/qUusz4nCtDhPAaYvc7sGYhen2O5jylpnAt+o7dsiiVghEYCb0Z5rnXeAq3CUOcWz3g/gjug=
Message-ID: <46EAA4C0.3070703@gmail.com>
Date: Fri, 14 Sep 2007 17:12:00 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: jirislaby@gmail.com, jeff@garzik.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: ath5k driver not working on ThinkPad
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909122251.GA31986@skynet.ie>
In-Reply-To: <20070909122251.GA31986@skynet.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> (To list based on CC's in net-add-ath5k-wireless-driver-fix.patch . If
> that is in error, apologies)
>
> On (31/08/07 21:58), Andrew Morton didst pronounce:
>   
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
>>
>>     
>
> I thought I would give the ath5k driver a shot on my Thinkpad T60p to see
> what happened but it wasn't particularly successful. lspci -v shows
>
> 03:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
>         Subsystem: IBM ThinkPad 11a/b/g Wireless LAN Mini Express Adapter (AR5BXB6)
>         Flags: bus master, fast devsel, latency 0, IRQ 22
>         Memory at edf00000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [40] Power Management version 2
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
>         Capabilities: [60] Express Legacy Endpoint IRQ 0
>         Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
>
> During boot, the following relevant information in dmesg shows up;
>
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
> PCI: Setting latency timer of device 0000:03:00.0 to 64
> Uhhuh. NMI received for unknown reason b1 on CPU 0.
> You have some hardware problem, likely on the PCI bus.
> Dazed and confused, but trying to continue
> ath5k_hw_nic_wakeup: failed to resume the MAC Chip
> ACPI: PCI interrupt for device 0000:03:00.0 disabled
> ath_pci: probe of 0000:03:00.0 failed with error -5
>
> Needless to say, it fails to bring up networking later. I have no real idea
> how to debug something like this. Any suggestions?
>
>   
I just tried Fedora 8test2 LiveCD which includes the 0.9.5-BSD version 
of the ath5k driver and get the exact same thing on my ThinkPad T60.
Fedora 8test2 uses a 2.6.23 based kernel.
