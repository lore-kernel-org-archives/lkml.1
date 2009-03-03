Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZCCTF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZCCTF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZCCTFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:05:14 -0500
Received: from mail.polezero.com ([216.68.55.34]:40696 "EHLO
	firewall.polezero.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753760AbZCCTFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:05:12 -0500
Subject: Re: New HID device support
From: Jason Noble <nobleja@polezero.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
Content-Type: multipart/mixed; boundary="=-5ZxNR6Av8+ztxj6ygPtg"
Date: Tue, 03 Mar 2009 14:04:55 -0500
Message-Id: <1236107096.7793.1.camel@paradox.pz.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5ZxNR6Av8+ztxj6ygPtg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Attached is the output.
Geez, that was a pain. I ended up connecting a PS/2 keyboard and mouse,
to stop mucking up the logs.

On Tue, 2009-03-03 at 17:21 +0100, Jiri Kosina wrote:
> On Tue, 3 Mar 2009, Jason Noble wrote:
> 
> > Jiri,
> > 	After a bit of googling I'm pretty sure you are the person to ask for
> > help.
> > 
> > I have a new Kensington Slimblade Trackball 
> > http://us.kensington.com/html/16632.html. This device just recently 
> > started shipping, I'm probably one of the first few people to connect 
> > one to linux.
> > 
> > Using "evtest /dev/input/eventX" two of the four buttons are not
> > registering at all. With usbmon I can see data coming from these
> > buttons.
> > Can you help? If so, what info do you need?
> > If not, can you point me in the correct direction?
> 
> Could you please compile your kernel with CONFIG_HID_DEBUG, modprobe the 
> 'hid' module with 'debug=2' option, and send me the output that appears in 
> dmesg when you
> 
> - connect the device
> - press the non-working buttons
> 
> Thanks,
> 

--=-5ZxNR6Av8+ztxj6ygPtg
Content-Description: 
Content-Disposition: inline; filename=kensington_debug.txt
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

usb 6-2: new low speed USB device using uhci_hcd and address 2
usb 6-2: configuration #1 chosen from 1 choice
drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 0
drivers/hid/usbhid/hid-core.c: report descriptor (size 75, read 1) =  05 01 09 02 a1 01 09 01 a1 00 05 09 19 01 29 02 15 00 25 01 95 02 75 01 81 02 95 01 75 06 81 03 05 01 09 30 09 31 09 38 15 81 25 7f 75 08 95 03 81 06 06 00 ff 19 01 29 02 15 00 25 01 95 02 75 01 81 02 95 01 75 06 81 03 c0 c0
  INPUT[INPUT]
    Field(0)
      Physical(GenericDesktop.Pointer)
      Usage(2)
        Button.0001
        Button.0002
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(2)
      Report Offset(0)
      Flags( Variable Absolute )
    Field(1)
      Physical(GenericDesktop.Pointer)
      Usage(3)
        GenericDesktop.X
        GenericDesktop.Y
        GenericDesktop.Wheel
      Logical Minimum(-127)
      Logical Maximum(127)
      Report Size(8)
      Report Count(3)
      Report Offset(8)
      Flags( Variable Relative )
    Field(2)
      Physical(GenericDesktop.Pointer)
      Usage(2)
        ff00.0001
        ff00.0002
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(2)
      Report Offset(32)
      Flags( Variable Absolute )
drivers/hid/hid-input.c: Mapping: Button.0001 ---> Key.LeftBtn
drivers/hid/hid-input.c: Mapping: Button.0002 ---> Key.RightBtn
drivers/hid/hid-input.c: Mapping: GenericDesktop.X ---> Relative.X
drivers/hid/hid-input.c: Mapping: GenericDesktop.Y ---> Relative.Y
drivers/hid/hid-input.c: Mapping: GenericDesktop.Wheel ---> Relative.Wheel
drivers/hid/hid-input.c: Mapping: ff00.0001 ---> IGNORED
drivers/hid/hid-input.c: Mapping: ff00.0002 ---> IGNORED
input: Kensington Kensington Slimblade Trackball as /class/input/input7
generic-usb 0003:047D:2041.0002: input,hidraw1: USB HID v1.10 Mouse [Kensington Kensington Slimblade Trackball] on usb-0000:00:1a.0-2/input0
usb 6-2: New USB device found, idVendor=047d, idProduct=2041
usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 6-2: Product: Kensington Slimblade Trackball
usb 6-2: Manufacturer: Kensington
drivers/hid/hid-core.c: report (size 5) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 5) =  00 00 00 00 01
hid-debug: input Button.0001 = 0
hid-debug: input Button.0002 = 0
hid-debug: input GenericDesktop.X = 0
hid-debug: input GenericDesktop.Y = 0
hid-debug: input GenericDesktop.Wheel = 0
hid-debug: input ff00.0001 = 1
hid-debug: input ff00.0002 = 0
drivers/hid/hid-core.c: report (size 5) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 5) =  00 00 00 00 00
hid-debug: input Button.0001 = 0
hid-debug: input Button.0002 = 0
hid-debug: input GenericDesktop.X = 0
hid-debug: input GenericDesktop.Y = 0
hid-debug: input GenericDesktop.Wheel = 0
hid-debug: input ff00.0001 = 0
hid-debug: input ff00.0002 = 0
drivers/hid/hid-core.c: report (size 5) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 5) =  00 00 00 00 02
hid-debug: input Button.0001 = 0
hid-debug: input Button.0002 = 0
hid-debug: input GenericDesktop.X = 0
hid-debug: input GenericDesktop.Y = 0
hid-debug: input GenericDesktop.Wheel = 0
hid-debug: input ff00.0001 = 0
hid-debug: input ff00.0002 = 1
drivers/hid/hid-core.c: report (size 5) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 5) =  00 00 00 00 00
hid-debug: input Button.0001 = 0
hid-debug: input Button.0002 = 0
hid-debug: input GenericDesktop.X = 0
hid-debug: input GenericDesktop.Y = 0
hid-debug: input GenericDesktop.Wheel = 0
hid-debug: input ff00.0001 = 0
hid-debug: input ff00.0002 = 0

--=-5ZxNR6Av8+ztxj6ygPtg--

