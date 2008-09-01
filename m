Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYIAQMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYIAQMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYIAQM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:12:27 -0400
Received: from smtp-out1.iol.cz ([194.228.2.86]:49330 "EHLO smtp-out1.iol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYIAQM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:12:26 -0400
Message-ID: <48BC10AC.40408@quick.cz>
Date: Mon, 01 Sep 2008 17:56:28 +0200
From: Martin Doucha <next_ghost@quick.cz>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: re : ACPI PnP on Intel MU440EX
References: <48BAD734.305@free.fr>
In-Reply-To: <48BAD734.305@free.fr>
Content-Type: multipart/mixed;
 boundary="------------070209060807080003020902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070209060807080003020902
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

matthieu castet wrote:
> Could you post the result of "lspnp -v" with pnpacpi and pnpbios ?

Here's the output of lspnp -v with pnpbios. When I run it with pnpacpi, 
it says that /proc/bus/pnp doesn't exist and dies. These 4 lines appear 
about halfway through dmesg output (in this order, no text omitted 
between first and last line):

ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP

What should I do to get lspnp work with pnpacpi?

Regards,
Martin Doucha

--------------070209060807080003020902
Content-Type: text/plain;
 name="pnpbios.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnpbios.out"

00 PNP0c02 system peripheral: other
	io 0x0370-0x0371
	io 0x00ea-0x00eb
	mem 0xfffc0000-0xffffffff

01 PNP0c01 memory controller: RAM
	mem 0x00000000-0x0009ffff
	mem 0x000e4000-0x000fffff
	mem 0x00100000-0x05ffffff
	mem 0xfff80000-0xfffbffff

02 PNP0200 system peripheral: DMA controller
	io 0x0000-0x000f
	io 0x0081-0x008f
	io 0x00c0-0x00df
	dma 4

03 PNP0000 system peripheral: programmable interrupt controller
	io 0x0020-0x0021
	io 0x00a0-0x00a1
	irq 2

04 PNP0100 system peripheral: system timer
	io 0x0040-0x0043
	irq 0

05 PNP0b00 system peripheral: real time clock
	io 0x0070-0x0071
	irq 8

06 PNP0303 input device: keyboard
	io 0x0060-0x0060
	io 0x0064-0x0064
	irq 1

07 PNP0c04 reserved: other
	io 0x00f0-0x00ff
	irq 13

08 PNP0800 multimedia controller: audio
	io 0x0061-0x0061

09 PNP0a03 bridge controller: PCI
	io 0x0cf8-0x0cff

0a PNP0c02 bridge controller: ISA
	io 0x04d0-0x04d1
	io 0x8000-0x803f
	io 0x7000-0x700f

0b PNP0c02 memory controller: RAM
	mem 0x000e0000-0x000e3fff

0c PNP0c02 memory controller: RAM
	mem disabled
	mem disabled
	mem disabled
	mem disabled
	mem disabled
	mem disabled

0d PNP0f13 input device: mouse
	irq 12

0e PNP0501 communications device: RS-232
	io 0x03f8-0x03ff
	irq 4

11 PNP0700 mass storage device: floppy
	io 0x03f0-0x03f5
	io 0x03f7-0x03f7
	irq 6
	dma 2

15 PNP0400 communications device: AT parallel port
	io 0x0378-0x037f
	irq 7


--------------070209060807080003020902--
