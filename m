Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYINTaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYINTaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYINT3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:29:53 -0400
Received: from smtp-out2.iol.cz ([194.228.2.87]:36866 "EHLO smtp-out2.iol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbYINT3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:29:52 -0400
Message-ID: <48CD65D0.9090202@quick.cz>
Date: Sun, 14 Sep 2008 21:28:16 +0200
From: Martin Doucha <next_ghost@quick.cz>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       matthieu castet <castet.matthieu@free.fr>
Subject: Re: ACPI PnP on Intel MU440EX
References: <48BA9B2C.7060007@quick.cz> <200809091034.46729.bjorn.helgaas@hp.com>
In-Reply-To: <200809091034.46729.bjorn.helgaas@hp.com>
Content-Type: multipart/mixed;
 boundary="------------080305090206030103020803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080305090206030103020803
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Bjorn Helgaas wrote:
> Thanks very much for the report.  This sounds like it could be a
> PNPACPI issue, which I am very interested in fixing.
>
> Can you please turn on CONFIG_PNP_DEBUG in your .config and collect
> the complete dmesg log with and without "pnpacpi=off"?
>
> I do have an "lspnp" that works with PNPACPI here:
>   http://kernel.org/pub/linux/kernel/people/helgaas/pnputils-0.1.tar.bz2
> but it's not widely used.  The debug information from the config
> option above is usually more useful.
>
> Bjorn

I'm sorry it took me so long, here's the output of lspnp -vvv from both 
PNPBIOS and ACPI PnP (same kernel, the only difference is pnpacpi=off 
boot argument). I can't find any mention of my parallel port in ACPI PnP 
output but it's the last listed device (00:15 PNP0400) in PNPBIOS output.

Regards,
Martin Doucha

--------------080305090206030103020803
Content-Type: text/plain;
 name="pnpacpi.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnpacpi.out"

00:00 PNP0a03 (unknown)
    state = active
    allocated resources:
	io 0xcf8-0xcff

00:01 PNP0303 (unknown)
    state = active
    allocated resources:
	io 0x60-0x60
	io 0x64-0x64
	irq 1

00:02 PNP0f13 (unknown)
    state = active
    allocated resources:
	irq 12

00:03 PNP0201 (unknown)
    state = active
    allocated resources:
	io 0x0-0xf
	io 0x80-0x91
	io 0x94-0x9f
	io 0xc0-0xdf
	io 0x40b-0x40b
	io 0x410-0x43f
	io 0x481-0x483
	io 0x487-0x487
	io 0x489-0x489
	io 0x4d6-0x4d6
	dma 4

00:04 PNP0b00 (unknown)
    state = active
    allocated resources:
	io 0x70-0x71
	irq 8

00:05 PNP0c04 (unknown)
    state = active
    allocated resources:
	io 0xf0-0xff
	irq 13

00:06 PNP0800 (unknown)
    state = active
    allocated resources:
	io 0x61-0x61

00:07 PNP0c02 (unknown)
    state = active
    allocated resources:
	io 0x7000-0x700f
	io 0x8000-0x803f

00:08 PNP0700 (unknown)
    state = active
    allocated resources:
	io 0x3f0-0x3f5
	io 0x3f7-0x3f7
	irq 6
	dma 2
    possible resources:
	Dependent: 01 - Priority preferred
	   port 0x3f0-0x3f0, align 0x0, size 0x6, 16-bit address decoding
	   port 0x3f7-0x3f7, align 0x0, size 0x1, 16-bit address decoding
	   irq 6 High-Edge
	   dma 2 8-bit compatible

00:09 PNP0501 (unknown)
    state = active
    allocated resources:
	io 0x3f8-0x3ff
	irq 4
    possible resources:
	Dependent: 01 - Priority preferred
	   port 0x3f8-0x3f8, align 0x0, size 0x8, 16-bit address decoding
	   irq 4 High-Edge
	Dependent: 02 - Priority preferred
	   port 0x3e8-0x3e8, align 0x0, size 0x8, 16-bit address decoding
	   irq 4 High-Edge
	Dependent: 03 - Priority preferred
	   port 0x2f8-0x2f8, align 0x0, size 0x8, 16-bit address decoding
	   irq 3 High-Edge
	Dependent: 04 - Priority preferred
	   port 0x2e8-0x2e8, align 0x0, size 0x8, 16-bit address decoding
	   irq 3 High-Edge
	Dependent: 05 - Priority functional
	   port 0x100-0x3f8, align 0x7, size 0x8, 16-bit address decoding
	   irq 1,3,4,5,6,7,8,10,11,12,13,14,15 High-Edge

00:0a PNP8294 (unknown)
    state = disabled
    possible resources:
	Dependent: 01 - Priority preferred
	   port 0x2f8-0x2f8, align 0x0, size 0x8, 16-bit address decoding
	   irq 3 High-Edge
	Dependent: 02 - Priority preferred
	   port 0x2e8-0x2e8, align 0x0, size 0x8, 16-bit address decoding
	   irq 3 High-Edge
	Dependent: 03 - Priority preferred
	   port 0x3f8-0x3f8, align 0x0, size 0x8, 16-bit address decoding
	   irq 4 High-Edge
	Dependent: 04 - Priority preferred
	   port 0x3e8-0x3e8, align 0x0, size 0x8, 16-bit address decoding
	   irq 4 High-Edge
	Dependent: 05 - Priority functional
	   port 0x100-0x3f8, align 0x7, size 0x8, 16-bit address decoding
	   irq 1,3,4,5,6,7,8,10,11,12,13,14,15 High-Edge


--------------080305090206030103020803
Content-Type: text/plain;
 name="pnpbios.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnpbios.out"

00:00 PNP0c02 (unknown)
    state = active
    allocated resources:
	io 0x370-0x371
	io 0xea-0xeb
	mem 0xfffc0000-0xffffffff

00:01 PNP0c01 (unknown)
    state = active
    allocated resources:
	mem 0x0-0x9ffff
	mem 0xe4000-0xfffff
	mem 0x100000-0x5ffffff
	mem 0xfff80000-0xfffbffff

00:02 PNP0200 (unknown)
    state = active
    allocated resources:
	io 0x0-0xf
	io 0x81-0x8f
	io 0xc0-0xdf
	dma 4

00:03 PNP0000 (unknown)
    state = active
    allocated resources:
	io 0x20-0x21
	io 0xa0-0xa1
	irq 2

00:04 PNP0100 (unknown)
    state = active
    allocated resources:
	io 0x40-0x43
	irq 0

00:05 PNP0b00 (unknown)
    state = active
    allocated resources:
	io 0x70-0x71
	irq 8

00:06 PNP0303 (unknown)
    state = active
    allocated resources:
	io 0x60-0x60
	io 0x64-0x64
	irq 1

00:07 PNP0c04 (unknown)
    state = active
    allocated resources:
	io 0xf0-0xff
	irq 13

00:08 PNP0800 (unknown)
    state = active
    allocated resources:
	io 0x61-0x61

00:09 PNP0a03 (unknown)
    state = active
    allocated resources:
	io 0xcf8-0xcff

00:0a PNP0c02 (unknown)
    state = active
    allocated resources:
	io 0x4d0-0x4d1
	io 0x8000-0x803f
	io 0x7000-0x700f

00:0b PNP0c02 (unknown)
    state = active
    allocated resources:
	mem 0xe0000-0xe3fff

00:0c PNP0c02 (unknown)
    state = disabled

00:0d PNP0f13 (unknown)
    state = active
    allocated resources:
	irq 12
    possible resources:
	irq 12 High-Edge

00:0e PNP0501 (unknown)
    state = active
    allocated resources:
	io 0x3f8-0x3ff
	irq 4
    possible resources:
	Dependent: 01 - Priority acceptable
	   port 0x3f8-0x3f8, align 0x7, size 0x8, 16-bit address decoding
	   irq 4 High-Edge
	Dependent: 02 - Priority acceptable
	   port 0x2f8-0x2f8, align 0x7, size 0x8, 16-bit address decoding
	   irq 3 High-Edge
	Dependent: 03 - Priority acceptable
	   port 0x3e8-0x3e8, align 0x7, size 0x8, 16-bit address decoding
	   irq 4 High-Edge
	Dependent: 04 - Priority acceptable
	   port 0x2e8-0x2e8, align 0x7, size 0x8, 16-bit address decoding
	   irq 3 High-Edge
	Dependent: 05 - Priority acceptable
	   port 0x3f8-0x3f8, align 0x7, size 0x8, 16-bit address decoding
	   irq 3 High-Edge
	Dependent: 06 - Priority acceptable
	   port 0x2f8-0x2f8, align 0x7, size 0x8, 16-bit address decoding
	   irq 4 High-Edge
	Dependent: 07 - Priority acceptable
	   port 0x3e8-0x3e8, align 0x7, size 0x8, 16-bit address decoding
	   irq 3 High-Edge
	Dependent: 08 - Priority acceptable
	   port 0x2e8-0x2e8, align 0x7, size 0x8, 16-bit address decoding
	   irq 4 High-Edge

00:11 PNP0700 (unknown)
    state = active
    allocated resources:
	io 0x3f0-0x3f5
	io 0x3f7-0x3f7
	irq 6
	dma 2
    possible resources:
	Dependent: 01 - Priority acceptable
	   port 0x3f0-0x3f0, align 0x7, size 0x6, 16-bit address decoding
	   port 0x3f7-0x3f7, align 0x0, size 0x1, 16-bit address decoding
	   irq 6 High-Edge
	   dma 2 8-bit compatible
	Dependent: 02 - Priority acceptable
	   port 0x370-0x370, align 0x7, size 0x6, 16-bit address decoding
	   port 0x377-0x377, align 0x0, size 0x1, 16-bit address decoding
	   irq 6 High-Edge
	   dma 2 8-bit compatible

00:15 PNP0400 (unknown)
    state = active
    allocated resources:
	io 0x378-0x37f
	irq 7
    possible resources:
	Dependent: 01 - Priority acceptable
	   port 0x378-0x378, align 0x7, size 0x8, 16-bit address decoding
	   irq 7 High-Edge
	Dependent: 02 - Priority acceptable
	   port 0x278-0x278, align 0x7, size 0x8, 16-bit address decoding
	   irq 5 High-Edge
	Dependent: 03 - Priority acceptable
	   port 0x228-0x228, align 0x7, size 0x8, 16-bit address decoding
	   irq 7 High-Edge
	Dependent: 04 - Priority acceptable
	   port 0x378-0x378, align 0x7, size 0x8, 16-bit address decoding
	   irq 5 High-Edge
	Dependent: 05 - Priority acceptable
	   port 0x278-0x278, align 0x7, size 0x8, 16-bit address decoding
	   irq 7 High-Edge
	Dependent: 06 - Priority acceptable
	   port 0x228-0x228, align 0x7, size 0x8, 16-bit address decoding
	   irq 5 High-Edge


--------------080305090206030103020803--
