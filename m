Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbZLOWyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbZLOWyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761508AbZLOWyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:54:47 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:60638 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761644AbZLOWyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=x+Jq6XvQtacc2qbDiwc8ZgYzLHJbO9ewojosTSah8NJVzXvIUsaj7k3XMfHWFWvEiU
         afK5S1nymM9EHjHJTFTmPKx/QnyuFBo2KeZ4pPO9Fh0PKFW7/iL6L+1cDMJ7EmHcKVZu
         9IELh71+9BMCpUE8NBBcSmhtdBw8WhnJ+SEok=
MIME-Version: 1.0
Date: Tue, 15 Dec 2009 14:54:39 -0800
Message-ID: <dd18b0c30912151454l1aa7fb97g951483993ab42502@mail.gmail.com>
Subject: [drm] nouveau iMac crashes and burns
From: Justin Mattock <justinmattock@gmail.com>
To: xorg@freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had figured this would happen,
but was curious to see if this
new bad boy would work.
(probably why fedora 12 doesnt boot as well).

basically the system freezes during boot once
drn nouveau is loaded. here's dmesg captured
with firescope:(a bit long)



<6>[    6.001461] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8502)
<6>[    6.006567] input: Built-in iSight as
/devices/pci0000:00/0000:00:04.1/usb1/1-4/1-4:1.0/input/input4
<6>[    6.006643] usbcore: registered new interface driver uvcvideo
<6>[    6.006644] USB Video Class driver (v0.1.0)
<6>[    6.062422] nouveau 0000:02:00.0: PCI INT A -> Link[Z003] -> GSI
23 (level, low) -> IRQ 23
<7>[    6.075927] nouveau 0000:02:00.0: setting latency timer to 64
<6>[    6.078287] [drm] nouveau 0000:02:00.0: Detected an NV50
generation card (0x094700a1)
<6>[    6.092826] [drm] nouveau 0000:02:00.0: Attempting to load BIOS
image from PRAMIN
<6>[    6.175238] [drm] nouveau 0000:02:00.0: ... appears to be valid
<6>[    6.199990] [drm] nouveau 0000:02:00.0: BIT BIOS found
<6>[    6.224262] [drm] nouveau 0000:02:00.0: Bios version 62.94.74.00
<4>[    6.247464] [drm] nouveau 0000:02:00.0: TMDS table revision 2.0
not currently supported
<6>[    6.270847] [drm] nouveau 0000:02:00.0: Found Display
Configuration Block version 4.0
<6>[    6.294284] [drm] nouveau 0000:02:00.0: DCB connector table:
VHER 0x40 5 16 4
<6>[    6.317755] [drm] nouveau 0000:02:00.0:   0: 0x00000040: type
0x40 idx 0 tag 0xff
<6>[    6.317769] usb 1-1.2: new low speed USB device using ehci_hcd
and address 5
<6>[    6.364963] [drm] nouveau 0000:02:00.0:   1: 0x00001161: type
0x61 idx 1 tag 0x07
<6>[    6.388685] [drm] nouveau 0000:02:00.0:   2: 0x00001231: type
0x31 idx 2 tag 0x07
<6>[    6.411250] [drm] nouveau 0000:02:00.0:   3: 0x01100331: type
0x31 idx 3 tag 0xff
<6>[    6.433337] [drm] nouveau 0000:02:00.0:   4: 0x01100446: type
0x46 idx 4 tag 0xff
<6>[    6.455141] [drm] nouveau 0000:02:00.0:   5: 0x02000546: type
0x46 idx 5 tag 0xff
<6>[    6.476717] [drm] nouveau 0000:02:00.0:   6: 0x00410631: type
0x31 idx 6 tag 0x51
<6>[    6.498117] [drm] nouveau 0000:02:00.0:   7: 0x00410746: type
0x46 idx 7 tag 0x51
<6>[    6.519136] [drm] nouveau 0000:02:00.0:   8: 0x00020846: type
0x46 idx 8 tag 0x52
<6>[    6.540124] [drm] nouveau 0000:02:00.0:   9: 0x00000900: type
0x00 idx 9 tag 0xff
<5>[    6.560838] [drm] nouveau 0000:02:00.0: Raw DCB entry 0: 01000113 00010034
<5>[    6.581250] [drm] nouveau 0000:02:00.0: Raw DCB entry 1: 040142a6 0f220010
<5>[    6.601240] [drm] nouveau 0000:02:00.0: Raw DCB entry 2: 04014242 00020010
<6>[    6.612124] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
0 at offset 0xD216
<6>[    6.643094] input: Apple Inc. Apple Keyboard as
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1.2/1-1.2:1.0/input/input5
<6>[    6.654659] apple 0003:05AC:021D.0001: input: USB HID v1.11
Keyboard [Apple Inc. Apple Keyboard] on usb-0000:00:04.1-1.2/input0
<6>[    6.663076] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:08.0/input/input6
<6>[    6.663279] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
1 at offset 0xD685
<6>[    6.668019] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
2 at offset 0xE64E
<6>[    6.668025] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
3 at offset 0xE76F
<6>[    6.671605] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
4 at offset 0xEA96
<6>[    6.671606] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table
at offset 0xEAFB
<4>[    6.692024] [drm] nouveau 0000:02:00.0: 0xEAFB: Condition still
not met after 20ms, skipping following opcodes
<6>[    6.692030] [drm] nouveau 0000:02:00.0: 0xB45C: parsing output script 0
<6>[    6.692032] [drm] nouveau 0000:02:00.0: 0xBB62: parsing output script 0
<6>[    6.692034] [drm] nouveau 0000:02:00.0: 0xB8A4: parsing output script 0
<6>[    6.772776] [TTM] Zone  kernel: Available graphics memory: 2016034 kiB.
<6>[    6.772793] [drm] nouveau 0000:02:00.0: 512 MiB VRAM
<6>[    6.805881] input: Apple Inc. Apple Keyboard as
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1.2/1-1.2:1.1/input/input7
<6>[    6.815359] [drm] nouveau 0000:02:00.0: 512 MiB GART (aperture)
<6>[    6.831344] nouveau 0000:02:00.0: firmware: requesting
nouveau/nv94.ctxprog
<6>[    6.831853] apple 0003:05AC:021D.0002: input: USB HID v1.11
Device [Apple Inc. Apple Keyboard] on usb-0000:00:04.1-1.2/input1
<3>[    6.891531] [drm] nouveau 0000:02:00.0: No ctxprog for NV94
<6>[    6.913304] [drm] nouveau 0000:02:00.0: Allocating FIFO number 1
<6>[    6.913328] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.913333] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.913337] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.913341] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127

   <--------cut *this message goes on for a while  ----------->

<6>[    6.914479] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.914483] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.914487] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.914491] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.914494] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.915488] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.915491] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.915495] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.915500] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.915503] [drm] nouveau 0000:02:00.0: PFIFO_INTR 0x00000010 - Ch 127
<6>[    6.915506] [drm] nouveau 0000:02:00.0: PFIFO still angry after
101 spins, halt
<6>[    8.540685] usb 1-1.3: new low speed USB device using ehci_hcd
and address 6
<6>[    8.545087] [drm] nouveau 0000:02:00.0: nouveau_channel_alloc:
initialised FIFO 1
<6>[    8.640144] input: Mitsumi Electric Apple Optical USB Mouse as
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1.3/1-1.3:1.0/input/input8
<6>[    8.642258] apple 0003:05AC:0304.0003: input: USB HID v1.10
Mouse [Mitsumi Electric Apple Optical USB Mouse] on
usb-0000:00:04.1-1.3/input0
<7>[    8.798067] ieee1394: The root node is not cycle master capable;
selecting a new root node and resetting...
<7>[    9.056250] ieee1394: Speed probe of node 0-00:1023 yields S400
<7>[    9.056708] ieee1394: Node added: ID:BUS[0-00:1023]
GUID[0019e3fffe2ad87e]
<7>[    9.057063] ieee1394: Host added: ID:BUS[0-01:1023]
GUID[0023dffffe8cd104]

<3>[   10.166575] [drm] nouveau 0000:02:00.0: PRAMIN flush timeout

machine is an iMac with the gt130 card
I loaded mesa,dri, but didn't find any
firmware(if any) for /lib/firmware

-- 
Justin P. Mattock
