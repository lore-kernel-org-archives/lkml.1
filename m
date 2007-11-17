Return-Path: <linux-kernel-owner+w=401wt.eu-S935180AbXKQB0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935180AbXKQB0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 20:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXKQB0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 20:26:07 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:9193 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbXKQB0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 20:26:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=K5ufnLPJdsS2QkVj/Gv5Y2LfLjATHBxXP0hr47+2ZzfEV3QXQ5MQF73BrtsmY0mDMu1i4ugsz+06yc3bk27GA3rDcNRuKUUKhcuxFBEJNimmqg+LWd1ltKRlmwjg7NK1UBwbKwC9HrvZ8efzSIe2uFwmx6f/s3mqFnmQZtU0Fus=
Message-ID: <43e72e890711161726m11682a2fwcaba31c2d093310f@mail.gmail.com>
Date: Fri, 16 Nov 2007 20:26:04 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: libertas ub8xxx - bcdDevice 30.06 - firmware issues?
Cc: "Stefano Brivio" <stefano.brivio@polimi.it>,
       "linux kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a USB libertas 1286:2001 with bcdDevice 30.06 (from lsusb -v).
I tried downloading the firmware from marvell:

https://www.marvell.com/drivers/driverDisplay.do?dId=160&pId=38

renaming and to usb8388.bin and putting it in firmware dir. Is this
the right firmware??

Upon load this is what I get:

17:58 < mcgrof> usb8xxx: URB in failure status: -71
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
and address 3
17:58 < mcgrof> usb8xxx: probe of 4-1:1.0 failed with error -12
17:58 < mcgrof> usbcore: registered new interface driver usb8xxx

I'm using the compatibility package from:

http://linuxwireless.org/en/users/Download

on 2.6.22. So this driver reflects what's on
wireless2.6.git#everything. I tried looking on the wiki but well can't
find much information. Can we please start adding some info about this
driver to:

http://linuxwireless.org/en/users/Drivers/libertas

  Luis
