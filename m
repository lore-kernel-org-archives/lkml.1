Return-Path: <linux-kernel-owner+w=401wt.eu-S1764188AbXKNU0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764188AbXKNU0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbXKNU0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:26:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:39456 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509AbXKNU0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:26:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R+hvTdELDHyDLPuhMFJOfeXCEMfGq/DdDm4InbJmBoLA3bhFjKRKWJWp3Fmutmj6udxl6uNMvkrcUO3DLsPXN5lVhbiO12op8hIcYGI998NRkJ/ZOunxvdpFC43qcXgwNqX6X80qMcuwSkTimeVTbhzRheZv0hlBbqmLY6hXsd4=
Message-ID: <19f34abd0711141226n60323630rdc4833db0bfb2eeb@mail.gmail.com>
Date: Wed, 14 Nov 2007 21:26:01 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

With 2.6.23 kernel, the laptop middle button worked fine. With
2.6.24-rc1, when I press the middle button, the cursor jumps around
the screen and this appears in the kernel log (for each time I press
the button):

psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
psmouse.c: GlidePoint at isa0060/serio1/input0 - driver resynched.

Related dmesg:

input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
mice: PS/2 mouse device common for all mice
input: PS/2 Mouse as /class/input/input2
input: AlpsPS/2 ALPS GlidePoint as /class/input/input3

Earlier dmesgs (2.6.23) had (only) this:

input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
mice: PS/2 mouse device common for all mice
input: ImPS/2 Generic Wheel Mouse as /class/input/input2


It seems that the driver used is different. What can I do to fix this?


Kind regards,
Vegard Nossum
