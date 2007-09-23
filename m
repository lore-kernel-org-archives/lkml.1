Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbXIWB4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbXIWB4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbXIWB4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:56:06 -0400
Received: from smtp1.Vir.com ([199.202.113.40]:45156 "EHLO smtp1.vir.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbXIWB4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:56:05 -0400
Message-ID: <46F5C7B4.7050802@soo.com>
Date: Sat, 22 Sep 2007 21:56:04 -0400
From: ben soo <lnx-kern@soo.com>
Reply-To: lnx-kern@soo.com
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Network sky2 Module, kernel version 2.6.23-rc7
References: <46E2BC6A.4070800@gmx.de>	<46EF4DE1.4000707@soo.com>	<46EFE09B.6090901@tmr.com> <20070918080525.7a49d110@freepuppy.rosehill.hemminger.net> <46F21692.4020607@soo.com>
In-Reply-To: <46F21692.4020607@soo.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i spoke too soon.  The Gbit interface still dies.  Lasted around 
19hrs. or so.  i can't tell if there are hardware issues: yesterday 
a Gbit NIC on the firewall died.  Different chip (Realtek), 
different driver, different machine, same segment.  Segment is a 
mix of 100Mbit and 1Gbit machines.

Symptoms of the failure are it just stops functioning with no error 
messages.  ifconfig says there are packets being TX'd and none 
being RX'd.  Interface can't be brought up again.

i use this box as the secondary DNS for our Internet domains 
(unblocked by firewall), as well as the database server for our 
developmental web CMS and the LAN ntp server (both services 
invisible outside the LAN).


dmesg says this on bootup:

> ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 18 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:01:00.0 to 64
> sky2 0000:01:00.0: v1.17 addr 0xdfefc000 irq 16 Yukon-EC (0xb6) rev 2
> sky2 eth0: addr 00:01:29:d6:35:f4
> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:02:00.0 to 64
> sky2 0000:02:00.0: v1.17 addr 0xdfcfc000 irq 17 Yukon-EC (0xb6) rev 2
> sky2 eth1: addr 00:01:29:d6:36:26

Motherboard manufacturer identifies the chips as:

> Dual Gigabit LAN - Marvell 88E8052 and Marvell 88E8053 Gigabit PCI LAN 

board is DFI LANPARTY UT CFX3200-DR/G running an Opteron 165.

i've brought up the other Gbit network interface on the motherboard 
and am using that.

ben soo wrote:
> i turned off the motherboard Marvell Gbit devices and installed a 
> Realtek 8169 card, all the while keeping to kernel version 2.6.23-rc6, 
> and saw all the network problems go away.  Must mean it was a sky2 
> driver bug.
> 
> Am currently running 2.6.23-rc7 on the affected server and the rc7 sky2 
> driver is holding up fine so far.
> 
> thank you!
