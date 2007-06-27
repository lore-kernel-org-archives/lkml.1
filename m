Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbXF0O6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbXF0O6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbXF0O6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:58:23 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:43133 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659AbXF0O6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QjqdFqHMlVarzLqy102WglN/yKFsF/XAYYs+w1r5TQqpCz21vrVC4nsxc7KG4n403EnF5Mt2ZXuhcHvr/ZyoK017yOvYLVKjLLUa/zOoVWjLoLpQ9SDOnVBtdn5pske1Qgn2M4aEVDh7q8ZmMW9ET6DF/cvQ3AcF0TmSv22Sh6M=
Message-ID: <5486cca80706270758x540f75a9vfdd4aa5b6a7d8e4f@mail.gmail.com>
Date: Wed, 27 Jun 2007 16:58:21 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [Possible BUG] Logitech USB keyboard inconsistent led state
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel Developers,

I'm using a logitech USB keyboard, I think it's one of the most cheap
and diffuse logitech keyboard models.

I have an inconsistent led state. During boot the NumLock led blinks
several times and is on as boot finishes. However the numeric keypad
works as it was off (no numbers, keypad '.' works as Canc, '0' as Ins
and so on).

To restore a consistent state I have to press one key that change one
of the 3 leds on the keyboards: NumLock, CapsLock or ScrollLock.

Once I pressed one of those key the NumLock led turns off and,
eventually, another led turns on. After this if I press NumLock I have
the keypad enabled.

I'm able to reproduce the problem only once after a system boot (with
or without X). Unplugging the keyboard and unloading/reloading all the
usb stack always gives again a consistent state.

The problem is reproduced with various kernels from 2.6.18 official
debian etch build, until 2.6.22-rc5-cfs-v18-cfs.

Some keyboard info from dmesg:

kernel: usb 1-1.2: new low speed USB device using uhci_hcd and address 5
kernel: usb 1-1.2: Product: USB Multimedia Keyboard
kernel: usb 1-1.2: Manufacturer: BTC
kernel: usb 1-1.2: configuration #1 chosen from 1 choice
kernel: input: BTC USB Multimedia Keyboard as /class/input/input8
kernel: input: USB HID v1.10 Keyboard [BTC USB Multimedia Keyboard] on
usb-0000:00:07.2-1.2
kernel: input: BTC USB Multimedia Keyboard as /class/input/input9
kernel: input,hiddev96: USB HID v1.10 Device [BTC USB Multimedia
Keyboard] on usb-0000:00:07.2-1.2

If you need further information just ask.


Regards,

    ~ Antonio
