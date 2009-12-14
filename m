Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbZLNBsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbZLNBsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZLNBsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:48:32 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33995 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZLNBsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:48:31 -0500
Date: Sun, 13 Dec 2009 18:48:28 -0700
From: Alex Chiang <achiang@hp.com>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: synaptics touchpad doesn't click
Message-ID: <20091214014828.GA28402@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I just got a shiny new piece of hardware (HP Envy 15) with a
Synaptics touchpad, and I can't seem to make the touchpad work
correctly.  In this version of the touchpad, there are actually
two physical buttons underneath the pad. In essence, this is a
touchpad that you can click too.

I can't get the clicking to work. Of course, I can tap to click,
but lacking access to the physical buttons means that I can't
right-click.

Currently, I'm not sure if this is a driver issue or perhaps
something higher up the stack, perhaps in X or maybe pilot error.
;)

Distro is Ubuntu Karmic, kernel is latest upstream last pulled on
13 Dec.

Would like some pointers on how to get started debugging.

Thanks,
/ac

dmesg snip:
 Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
 brd: module loaded
 loop: module loaded
 input: Macintosh mouse button emulation as /devices/virtual/input/input3
 [...]
 Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04771/0xe40000
 input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input10

/proc/bus/input/devices snip:
I: Bus=0017 Vendor=0001 Product=0001 Version=0100
N: Name="Macintosh mouse button emulation"
P: Phys=
S: Sysfs=/devices/virtual/input/input3
U: Uniq=
H: Handlers=mouse0 event3 
B: EV=7
B: KEY=70000 0 0 0 0
B: REL=3

I: Bus=0011 Vendor=0002 Product=0007 Version=01b1
N: Name="SynPS/2 Synaptics TouchPad"
P: Phys=isa0060/serio1/input0
S: Sysfs=/devices/platform/i8042/serio1/input/input10
U: Uniq=
H: Handlers=mouse2 event10 
B: EV=b
B: KEY=420 30000 0 0 0 0
B: ABS=11000003

xinput list snip:
"Macintosh mouse button emulation"	id=9	[XExtensionPointer]
	Type is MOUSE
	Num_buttons is 5
	Num_axes is 2
	Mode is Relative
	Motion_buffer is 256
	Axis 0 :
		Min_value is -1
		Max_value is -1
		Resolution is 1
	Axis 1 :
		Min_value is -1
		Max_value is -1
		Resolution is 1
"SynPS/2 Synaptics TouchPad"	id=10	[XExtensionPointer]
	Type is TOUCHPAD
	Num_buttons is 12
	Num_axes is 2
	Mode is Relative
	Motion_buffer is 256
	Axis 0 :
		Min_value is 1472
		Max_value is 5472
		Resolution is 1
	Axis 1 :
		Min_value is 1408
		Max_value is 4448
		Resolution is 1

