Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbYEBP0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbYEBP0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934613AbYEBP0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:26:35 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:35196 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934605AbYEBP0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:26:34 -0400
Date: Fri, 02 May 2008 11:26:15 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2.6.25.1, stray noise in dmesg
To: LKML <linux-kernel@vger.kernel.org>
Message-id: <200805021126.15225.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I just rebooted to 2.6.25.1, and was momentarily panic'd by the messages going by early in the boot, but on putting 2&2 
together, found they were just noise.

>From dmesg:
[root@coyote ~]# dmesg|grep unable
[    2.093502] hub 1-0:1.0: unable to enumerate USB device on port 2
[    2.248475] hub 1-0:1.0: unable to enumerate USB device on port 5
[    2.454444] hub 1-0:1.0: unable to enumerate USB device on port 6
And lsusb:
[root@coyote ~]# lsusb
Bus 001 Device 011: ID 04b8:010f Seiko Epson Corp. Perfection 1250
Bus 001 Device 010: ID 046d:c510 Logitech, Inc.
Bus 001 Device 009: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
Bus 001 Device 008: ID 0409:0059 NEC Corp. HighSpeed Hub
Bus 001 Device 007: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
Bus 001 Device 006: ID 050d:0751 Belkin Components
Bus 001 Device 002: ID 0409:0059 NEC Corp. HighSpeed Hub
Bus 001 Device 001: ID 1d6b:0002
Bus 003 Device 002: ID 0451:2046 Texas Instruments, Inc. TUSB2046 Hub
Bus 003 Device 001: ID 1d6b:0001
Bus 002 Device 003: ID 06a3:8021 Saitek PLC Eclipse II Keyboard
Bus 002 Device 002: ID 04b8:0005 Seiko Epson Corp. Stylus Printer
Bus 002 Device 001: ID 1d6b:0001

Indicating 3 empty ports, which is not correct either, but everything
that is plugged in is accounted for.  However, if there is no device
there, is it supposed to tell us?  In which case it should do that 2-3
more times in dmesg.

I realize this is picking minor nits. :)

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Shick's Law:
	There is no problem a good miracle can't solve.
