Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbXE2X5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbXE2X5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbXE2X5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:57:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:55372 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXE2X5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qpVrKvCAzKGNX9w0trB1FxAH/HokzkGlzTukIu2/n3c6znpwdTINeZ1tr3ysWNFCOP25fE6MgYvuk/rWH+UNQLIv/O1L5mhyTp16S/jcRfvMsR43HsvC3PJLJfva1W4trfNx2zbqFNjuiR2qDe6GHokpd5FffUzdILm2RJZhc/o=
Message-ID: <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com>
Date: Wed, 30 May 2007 00:57:33 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@insightbb.com>
In-Reply-To: <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <200705210016.20794.dtor@insightbb.com>
	 <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/07, Jiri Kosina <jkosina@suse.cz> wrote:
> could you please turn on the HID debugging support ("Device Drivers -> HID
> devices -> HID debugging support" in menuconfig of any reasonably recent
> kernel) and show the output that appears when the joystick is plugged in,
> and also when you generate the events that are messed up? This would
> hopefully avoid any confusion regarding what is really going on and we'll
> see what we can do with it.

Hi Jiri,

Couldn't make the generic kernel work on Ubuntu, it's quite a mess.
The distro kernel have USB general debugging instead of HID_DEBUG but
I had to manually redefine DEBUG and DEBUG_DATA on all hid*.c sources
and recompile the modules.

The HID sources are quite different from 2.6.21 and 2.6.20 but I don't
know how much was because Canonical guys and how much it really
changed. :( I will eventually put a Gentoo on my old laptop and try it
for real, sorry I couldn't be of much help now...

The only additional thing I got from debugging hid.ko and usbhid.ko
was right after detecting the mouse so I guess it didn't help at all.

--renato



May 30 00:40:06 jobim kernel: [ 7151.757499] usbcore: deregistering
interface driver usbhid
May 30 00:40:06 jobim kernel: [ 7151.769001] usbcore: deregistering
interface driver hiddev
May 30 00:40:06 jobim kernel: [ 7151.786229] usbcore: registered new
interface driver hiddev
May 30 00:40:06 jobim kernel: [ 7151.792457] input: Dell Dell USB
Mouse as /class/input/input56
May 30 00:40:06 jobim kernel: [ 7151.792816] input: USB HID v1.10
Mouse [Dell Dell USB Mouse] on usb-0000:00:0b.0-3
May 30 00:40:06 jobim kernel: [ 7151.807413] input: Saitek Cyborg Evo
Force as /class/input/input57
May 30 00:40:06 jobim kernel: [ 7151.807766] input: USB HID v1.00
Joystick [Saitek Cyborg Evo Force] on usb-0000:00:0b.0-7
May 30 00:40:06 jobim kernel: [ 7151.808122] usbcore: registered new
interface driver usbhid
May 30 00:40:06 jobim kernel: [ 7151.808328]
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
May 30 00:41:54 jobim kernel: [ 7260.252015] usbcore: deregistering
interface driver usbhid
May 30 00:41:54 jobim kernel: [ 7260.258180] usbcore: deregistering
interface driver hiddev
May 30 00:41:54 jobim kernel: [ 7260.276444] usbcore: registered new
interface driver hiddev
May 30 00:41:54 jobim kernel: [ 7260.293406] input: Dell Dell USB
Mouse as /class/input/input58
May 30 00:41:54 jobim kernel: [ 7260.293709] input: USB HID v1.10
Mouse [Dell Dell USB Mouse] on usb-0000:00:0b.0-3
May 30 00:41:54 jobim kernel: 09 02 26 2b 01 45 00 95 02 91 02 c0 05
0f 09 a7 27 fe ff 00 00 47 fe ff 00 00 95 01 55 fd 66 01 10 91 02 55
00 65 00 c0 09 5a a1 02 85 0c 09 23 26 2b 01 45 00 91 02 09 5c 26 10
27 46 10 27 55 fd 66 01 10 91 02 55 00 65 00 09 5b 25 7f 75 08 91 02
09 5e 26 10 27 75 10 55 fd 66 01 10 91 02 55 00 65 00 09 5d 25 7f 75
08 91 02 c0 09 73 a1 02 85 0d 09 23 26 2b 01 45 00 75 10 91 02 09 70
15 81 25 7f 36 f0 d8 46 10 27 75 08 91 02 c0 09 6e a1 02 85 0e 09 23
15 00 26 2b 01 35 00 45 00 75 10 91 02 09 70 25 7f 46 10 27 75 08 91
02 09 6f 15 81 36 f0 d8 91 02 09 71 15 00 26 ff 00 35 00 46 68 01 91
02 09 72 26 10 27 46 10 27 75 10 55 fd 66 01 10 91 02 55 00 65 00 c0
09 5f a1 02 85 0f 09 23 26 2b 01 45 00 91 02 09 61 15 9c 25 64 36 f0
d8 46 10 27 75 08 91 02 09 62 91 02 09 60 16 0c fe 26 f4 01 75 10 91
02 09 65 15 00 26 e8 03 35 00 91 02 09 63 25 64 75 08 91 02 09 64 91
02 c0 09 77 a1 02 85 51 09 22 25 09 45 00 91 02 09 78 a1 02 09 7b 09
79 09 7a 15 01 25 03 91 00 c0 09 7c 15 00 26 fe 00 91 02 c0
May 30 00:41:54 jobim kernel: 92 a1 02 85 52 09 96 a1 02 09 9a 09 99
09 97 09 98 09 9b 09 9c 15 01 25 06 91 00 c0 c0 05 ff 0a 01 03 a1 02
85 40 0a 02 03 a1 02 1a 11 03 2a 20 03 25 10 91 00 c0 0a 03 03 15 00
27 ff ff 00 00 75 10 91 02 c0 05 0f 09 7d a1 02 85 43 09 7e 26 80 00
46 10 27 75 08 91 02 c0 09 85 a1 02 85 44 09 86 27 ff ff 00 00 45 00
75 10 91 02 09 87 91 02 09 88 91 02 c0 05 ff 0a 00 01 a1 02 85 81 05
01 09 30 15 81 25 7f 36 f0 d8 46 10 27 75 08 91 02 09 31 91 02 c0 05
0f 09 7f a1 02 85 0b 09 80 15 00 26 ff 7f 35 00 45 00 75 0f b1 03 09
a9 25 01 75 01 b1 03 09 83 26 ff 00 75 08 b1 03 09 84 25 10 b1 03 09
a8 a1 02 09 73 09 6e 09 5a 09 5f 95 04 b1 03 c0 c0 c0
May 30 00:41:54 jobim kernel: [ 7260.320561] input: Saitek Cyborg Evo
Force as /class/input/input59
May 30 00:41:54 jobim kernel: [ 7260.320633] input: USB HID v1.00
Joystick [Saitek Cyborg Evo Force] on usb-0000:00:0b.0-7
May 30 00:41:54 jobim kernel: [ 7260.320654] usbcore: registered new
interface driver usbhid
May 30 00:41:54 jobim kernel: [ 7260.320660]
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
