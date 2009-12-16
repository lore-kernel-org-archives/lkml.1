Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbZLPDXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbZLPDXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZLPDXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:23:14 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:54218 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZLPDXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:23:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ntkXIY5OeBaMIpPRMa4IZ/YjANmTrzhX9IN+32P/UuiXUWTFiEIBsHX/Qpa83NVyLh
         I4jIn8hftEjOwB0k7fQEyQZkvNmLmd+6EXw6aMn1Eq4sEhfXHuGoTPy+w5BMAuJJo2GV
         bVkTHNVO7wqz8/56ycwjx/XPddrzSlduERTe0=
MIME-Version: 1.0
In-Reply-To: <4B2817DD.4000005@gmail.com>
References: <dd18b0c30912151454l1aa7fb97g951483993ab42502@mail.gmail.com>
	 <586c2acd0912151502o303f6b14g7277289ff5dc69b3@mail.gmail.com>
	 <586c2acd0912151508q5361d6a5o12016648935b4eec@mail.gmail.com>
	 <4B2817DD.4000005@gmail.com>
Date: Tue, 15 Dec 2009 19:23:12 -0800
Message-ID: <dd18b0c30912151923v605a6795ie3bef549c81373b1@mail.gmail.com>
Subject: Re: [drm] nouveau iMac crashes and burns
From: Justin Mattock <justinmattock@gmail.com>
To: Younes Manton <younes.m@gmail.com>
Cc: xorg@freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. I didn't see the urls at the bottom pointing
to where to get the firmware(was figuring out the trace thing.

Anyways I think I need to generate a new firmware file because
even with the firmware compiled in I still freeze up:


<7>[    6.492976] nouveau 0000:02:00.0: setting latency timer to 64
<6>[    6.495238] [drm] nouveau 0000:02:00.0: Detected an NV50
generation card (0x094700a1)
<6>[    6.515838] [drm] nouveau 0000:02:00.0: Attempting to load BIOS
image from PRAMIN
<6>[    6.565633] usb 1-1.3: new low speed USB device using ehci_hcd
and address 6
<6>[    6.593407] [drm] nouveau 0000:02:00.0: ... appears to be valid
<6>[    6.607755] [drm] nouveau 0000:02:00.0: BIT BIOS found
<6>[    6.621926] [drm] nouveau 0000:02:00.0: Bios version 62.94.74.00
<4>[    6.635626] [drm] nouveau 0000:02:00.0: TMDS table revision 2.0
not currently supported
<6>[    6.649157] [drm] nouveau 0000:02:00.0: Found Display
Configuration Block version 4.0
<6>[    6.662635] [drm] nouveau 0000:02:00.0: DCB connector table:
VHER 0x40 5 16 4
<6>[    6.669105] input: Mitsumi Electric Apple Optical USB Mouse as
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1.3/1-1.3:1.0/input/input8
<6>[    6.669194] apple 0003:05AC:0304.0003: input: USB HID v1.10
Mouse [Mitsumi Electric Apple Optical USB Mouse] on
usb-0000:00:04.1-1.3/input0
<6>[    6.704298] [drm] nouveau 0000:02:00.0:   0: 0x00000040: type
0x40 idx 0 tag 0xff
<6>[    6.718420] [drm] nouveau 0000:02:00.0:   1: 0x00001161: type
0x61 idx 1 tag 0x07
<6>[    6.732352] [drm] nouveau 0000:02:00.0:   2: 0x00001231: type
0x31 idx 2 tag 0x07
<6>[    6.746063] [drm] nouveau 0000:02:00.0:   3: 0x01100331: type
0x31 idx 3 tag 0xff
<6>[    6.746065] [drm] nouveau 0000:02:00.0:   4: 0x01100446: type
0x46 idx 4 tag 0xff
<6>[    6.746067] [drm] nouveau 0000:02:00.0:   5: 0x02000546: type
0x46 idx 5 tag 0xff
<6>[    6.746069] [drm] nouveau 0000:02:00.0:   6: 0x00410631: type
0x31 idx 6 tag 0x51
<6>[    6.746070] [drm] nouveau 0000:02:00.0:   7: 0x00410746: type
0x46 idx 7 tag 0x51
<6>[    6.746072] [drm] nouveau 0000:02:00.0:   8: 0x00020846: type
0x46 idx 8 tag 0x52
<6>[    6.746074] [drm] nouveau 0000:02:00.0:   9: 0x00000900: type
0x00 idx 9 tag 0xff
<5>[    6.746076] [drm] nouveau 0000:02:00.0: Raw DCB entry 0: 01000113 00010034
<5>[    6.746078] [drm] nouveau 0000:02:00.0: Raw DCB entry 1: 040142a6 0f220010
<5>[    6.746079] [drm] nouveau 0000:02:00.0: Raw DCB entry 2: 04014242 00020010
<6>[    6.746086] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
0 at offset 0xD216
<6>[    6.934477] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
1 at offset 0xD685
<6>[    6.962090] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
2 at offset 0xE64E
<6>[    6.974498] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
3 at offset 0xE76F
<6>[    6.988191] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
4 at offset 0xEA96
<6>[    7.000396] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
at offset 0xEAFB
<4>[    7.033096] [drm] nouveau 0000:02:00.0: 0xEAFB: Condition still
not met after 20ms, skipping following opcodes
<6>[    7.055682] [drm] nouveau 0000:02:00.0: 0xB45C: parsing output script 0
<6>[    7.078326] [drm] nouveau 0000:02:00.0: 0xBB62: parsing output script 0
<6>[    7.100583] [drm] nouveau 0000:02:00.0: 0xB8A4: parsing output script 0
<6>[    7.225581] [TTM] Zone  kernel: Available graphics memory: 2016018 kiB.
<6>[    7.240487] [drm] nouveau 0000:02:00.0: 512 MiB VRAM
<7>[    7.240520] ieee1394: The root node is not cycle master capable;
selecting a new root node and resetting...
<6>[    7.264721] [drm] nouveau 0000:02:00.0: 512 MiB GART (aperture)
<6>[    7.277953] nouveau 0000:02:00.0: firmware: using built-in
firmware nouveau/nv94.ctxprog
<6>[    7.290232] nouveau 0000:02:00.0: firmware: using built-in
firmware nouveau/nv94.ctxvals
<6>[    7.302607] [drm] nouveau 0000:02:00.0: Allocating FIFO number 1
<6>[    7.302626] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    7.302629] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    7.302632] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127


<---long trail of these    ----->


<6>[    7.303118] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    7.303120] [drm] nouveau 0000:02:00.0: PFIFO still angry after
101 spins, halt
<6>[    7.782786] [drm] nouveau 0000:02:00.0: nouveau_channel_alloc:
initialised FIFO 1
<7>[    7.972267] ieee1394: Speed probe of node 0-00:1023 yields S400
<7>[    7.972954] ieee1394: Node added: ID:BUS[0-00:1023]
GUID[0019e3fffe2ad87e]
<7>[    7.973293] ieee1394: Host added: ID:BUS[0-01:1023]
GUID[0023dffffe8cd104]
<6>[    7.978665] eth1394: eth0: IPv4 over IEEE 1394 (fw-host0)
<3>[    9.403981] [drm] nouveau 0000:02:00.0: PRAMIN flush timeout


looking at
http://nouveau.freedesktop.org/wiki/CtxInit
seems understandable to me, and I'm willing to
try this out(even if I go crazy), but could take a while.

-- 
Justin P. Mattock
