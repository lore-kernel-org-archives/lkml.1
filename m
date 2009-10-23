Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbZJWHCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbZJWHCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZJWHCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:02:10 -0400
Received: from mailout11.t-online.de ([194.25.134.85]:33061 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZJWHCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:02:09 -0400
MIME-Version: 1.0
Date: Fri, 23 Oct 2009 09:02:07 +0200
Reply-To: "harald.dunkel@t-online.de" <harald.dunkel@t-online.de>
To: linux-kernel@vger.kernel.org
X-UMS: email
X-Mailer: TOI Kommunikationscenter V9-3-0-6
Subject: 2.6.31.4, ps2-to-usb adapter: fourth mouse button not working
From: "harald.dunkel@t-online.de" <harald.dunkel@t-online.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <1N1EA3-10pOoy0@fwd05.aul.t-online.de>
X-ID: TF2ijGZ6rhuG6TrUrB+2NlWx3nkPjxkJbiqC9TrUD2LArv69uXiAHX9UBRw9ndKw0R@t-dialin.net
X-TOI-MSGID: bdccd6fc-28c2-40d9-b409-5b3cad3a76d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I've got a Logitech Trackman FX connected to my PC via a Chesen 
ps/2 usb adapter for mouse and keyboard. Problem: The fourth 
mouse button doesn't trigger any events. 

This means that I cannot enable scroll wheel emulation in the Xorg 
mouse driver. It is a severe restriction for a mouse without dedicated 
wheel.

I had opened a bug report for the Xorg mouse driver, but a low level 
test program ("cat </dev/input/event2") running outside of X shows 
that this is indeed a restriction of the kernel (2.6.31.4).

The same Trackman FX works fine connected to a PC with a "real" 
ps/2 port, of course.


It would be very nice if this could be fixed. Of course I would be glad 
to help.


Many thanx

Harri
=====================================================================
% cat /proc/bus/input/devices
I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/devices/platform/i8042/serio0/input/input0
U: Uniq=
H: Handlers=kbd event0
B: EV=120013
B: KEY=402000000 3803078f800d001 feffffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0003 Vendor=0a81 Product=0205 Version=0110
N: Name="CHESEN PS2 to USB Converter"
P: Phys=usb-0000:00:1a.2-2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input1
U: Uniq=
H: Handlers=kbd event1
B: EV=120013
B: KEY=1000000000007 ff980000000007ff febeffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0003 Vendor=0a81 Product=0205 Version=0110
N: Name="CHESEN PS2 to USB Converter"
P: Phys=usb-0000:00:1a.2-2/input1
S: Sysfs=/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input2
U: Uniq=
H: Handlers=kbd mouse0 event2
B: EV=17
B: KEY=1f001f 2020000 3878d801d001 1e000000000000 0
B: REL=103
B: MSC=10

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
U: Uniq=
H: Handlers=kbd event3
B: EV=3
B: KEY=10000000000000 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
U: Uniq=
H: Handlers=kbd event4
B: EV=3
B: KEY=10000000000000 0

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input5
U: Uniq=
H: Handlers=kbd event5
B: EV=40001
B: SND=6



