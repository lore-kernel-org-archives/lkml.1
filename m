Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYI0RbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYI0RbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYI0RbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:31:10 -0400
Received: from mail.daysofwonder.com ([87.98.213.69]:34381 "EHLO
	mail.daysofwonder.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbYI0RbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:31:09 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2008 13:31:08 EDT
Message-ID: <48DE6B6E.4050306@daysofwonder.com>
Date: Sat, 27 Sep 2008 19:20:46 +0200
From: Brice Figureau <brice+lkml@daysofwonder.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Serial console not working after device detection.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On two of my servers (some Dell poweredge 1850 and 2850), booting a 
2.6.26 debian kernel while at the same time looking at the serial 
console, nothing is printed after the following snippet:
...
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????

The serial port of these servers is configured as 115200n8 and connected 
to an Opengear serial console server for remote administration through ssh.

This is not an issue per-se, but for an unknown reason 2.6.25 and 2.6.26 
debian kernels don't boot succesfully, and I'm trying to understand why, 
which is a complex task when you don't see anything :-)
The latest known debian kernel that boots fine is a 2.6.22 (I didn't try 
2.6.23 or 2.6.24).

On this kernel that boots, the first lines that the serial console 
displays are those from the initrd.

After the boot the dmesg contains the following lines which are just 
after the last line displayed (ie the serial8250: ttyS0 is at... line):

pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:06' and the driver 'serial'
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
pnp: the driver 'parport_pc' has been registered
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
...

Is there anything I can do to display something after the device 
detection, in order to understand why those kernels are not booting?

Many thanks for any answer,
Please CC: me on replies, as I'm not subscribed to the list.
--
Brice Figureau
