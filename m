Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbXG1Lzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbXG1Lzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 07:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbXG1Lzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 07:55:47 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:57088 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbXG1Lzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 07:55:46 -0400
Date: Sat, 28 Jul 2007 07:55:34 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: zd1211b question.
To: lkml <linux-kernel@vger.kernel.org>
Message-id: <200707280755.34930.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

A net friend of mine has a Gateway m305CRV laptop, with this radio in it:
Bus 003 Device 003: ID 050d:705c Belkin Components

Its apparently sitting on the usb bus, and from my grepping of the kernel 
srcs, it looks as if the zd1211b driver might be the correct one:

drivers/net/wireless/zd1211rw/zd_usb.c: /* ZD1211B */
drivers/net/wireless/zd1211rw/zd_usb.c: { USB_DEVICE(0x0ace, 
0x1215), .driver_info = DEVICE_ZD1211B },
drivers/net/wireless/zd1211rw/zd_usb.c: { USB_DEVICE(0x157e, 
0x300d), .driver_info = DEVICE_ZD1211B },
drivers/net/wireless/zd1211rw/zd_usb.c: { USB_DEVICE(0x079b, 
0x0062), .driver_info = DEVICE_ZD1211B },
drivers/net/wireless/zd1211rw/zd_usb.c: { USB_DEVICE(0x1582, 
0x6003), .driver_info = DEVICE_ZD1211B },

drivers/net/wireless/zd1211rw/zd_usb.c: { USB_DEVICE(0x050d, 
0x705c), .driver_info = DEVICE_ZD1211B },

This last one is the right set of numbers.  However, I'll be dipped but I 
can't find anyplace in a make xconfig in the 2.6.22.1-rt9 tree, to turn on 
the building of that driver.

Am I blind, don't know how to run grep, or does the xconfig script need more 
tlc?

Can somebody toss me a bone of info here?

Thanks everybody.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Thus spake the master programmer:
	"When a program is being tested, it is too late to make design changes."
		-- Geoffrey James, "The Tao of Programming"
