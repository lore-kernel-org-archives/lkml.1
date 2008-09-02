Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbYIBOyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbYIBOyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYIBOx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:53:59 -0400
Received: from smtp-out1.iol.cz ([194.228.2.86]:44641 "EHLO smtp-out1.iol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYIBOx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:53:59 -0400
Message-ID: <48BD5348.6080708@quick.cz>
Date: Tue, 02 Sep 2008 16:52:56 +0200
From: Martin Doucha <next_ghost@quick.cz>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: re : ACPI PnP on Intel MU440EX
References: <48BAD734.305@free.fr> <48BC5080.2040607@free.fr>
In-Reply-To: <48BC5080.2040607@free.fr>
Content-Type: multipart/mixed;
 boundary="------------090903020609090409050709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090903020609090409050709
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

matthieu castet wrote:
> Hi,
> Please keep CC.
>> What should I do to get lspnp work with pnpacpi?
>
> Use a newer version of lspnp.
> An alternative is to do a for i in /sys/bus/pnp/devices/*; do echo $i; 
> cat $i/*; done
> Matthieu

Looking for any version of lspnp seems harder than finding a needle in 
barn full of hay... Here're the contents of /sys/bus/pnp/devices, the 
parallel port seems to be detected as device 00:08 (line 81) but there's 
no mention of it in dmesg, /dev or /proc/sys/dev/parport

Regards,
Martin Doucha

--------------090903020609090409050709
Content-Type: text/plain;
 name="pnpacpi.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnpacpi.out"

/sys/bus/pnp/devices/00:0a
PNP8294
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
state = disabled
PHYSDEVBUS=pnp
/sys/bus/pnp/devices/00:00
PNP0a03
state = active
io 0xcf8-0xcff
PHYSDEVBUS=pnp
/sys/bus/pnp/devices/00:01
PNP0303
state = active
io 0x60-0x60
io 0x64-0x64
irq 1
DRIVER=i8042 kbd
PHYSDEVBUS=pnp
PHYSDEVDRIVER=i8042 kbd
/sys/bus/pnp/devices/00:02
PNP0f13
state = active
irq 12
DRIVER=i8042 aux
PHYSDEVBUS=pnp
PHYSDEVDRIVER=i8042 aux
/sys/bus/pnp/devices/00:03
PNP0201
state = active
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
PHYSDEVBUS=pnp
/sys/bus/pnp/devices/00:04
PNP0b00
state = active
io 0x70-0x71
irq 8
PHYSDEVBUS=pnp
/sys/bus/pnp/devices/00:05
PNP0c04
state = active
io 0xf0-0xff
irq 13
PHYSDEVBUS=pnp
/sys/bus/pnp/devices/00:06
PNP0800
state = active
io 0x61-0x61
PHYSDEVBUS=pnp
/sys/bus/pnp/devices/00:07
PNP0c02
state = active
io 0x7000-0x700f
io 0x8000-0x803f
DRIVER=system
PHYSDEVBUS=pnp
PHYSDEVDRIVER=system
/sys/bus/pnp/devices/00:08
PNP0700
Dependent: 01 - Priority preferred
   port 0x3f0-0x3f0, align 0x0, size 0x6, 16-bit address decoding
   port 0x3f7-0x3f7, align 0x0, size 0x1, 16-bit address decoding
   irq 6 High-Edge
   dma 2 8-bit compatible
state = active
io 0x3f0-0x3f5
io 0x3f7-0x3f7
irq 6
dma 2
PHYSDEVBUS=pnp
/sys/bus/pnp/devices/00:09
PNP0501
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
state = active
io 0x3f8-0x3ff
irq 4
DRIVER=serial
PHYSDEVBUS=pnp
PHYSDEVDRIVER=serial

--------------090903020609090409050709--
