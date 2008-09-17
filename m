Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYIQQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYIQQrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYIQQrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:47:07 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:22965 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYIQQrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TnA8yIq+6c1+j6g5Z/JOl2lrbUoC6l7jM3KdzDBL7wvAMUv2Idf9L2DHDWNMHUNrqI
         G+EgxxKImX62VkewzUSR9fpjoMvQkPMT/0+Ahicsclh2jUxH/USEsI4gtbdrdOycLcNu
         piIvLqyoOvltzsrFr1AR8YIszzCb3JisFTkw0=
Message-ID: <48D1346C.1020203@gmail.com>
Date: Wed, 17 Sep 2008 18:46:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>
Subject: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
References: <48CE6A90.1070309@gmail.com> <48CFC601.9050608@embeddedalley.com> <48D0C69D.4090105@gmail.com>
In-Reply-To: <48D0C69D.4090105@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found suspend on my desktop defunct in mmotm 2008-09-13-03-09 (opposing to
2008-09-10-19-39).

Dmesg says:

uhci_hcd 0000:00:1d.1: PCI INT B disabled
pci_legacy_suspend(): usb_hcd_pci_suspend+0x0/0x3e0 returns -16
pm_op(): pci_pm_suspend+0x0/0xd0 returns -16
PM: Device 0000:00:1d.0 failed to suspend: error -16
PM: Some devices failed to suspend

$ ls -l /sys/bus/pci/devices/0000:00:1d.1/usb7/
-rw-r--r-- 1 root root  4096 17. zář 18.43 authorized
-rw-r--r-- 1 root root  4096 17. zář 18.43 authorized_default
-r--r--r-- 1 root root  4096 17. zář 10.51 bcdDevice
-rw-r--r-- 1 root root  4096 17. zář 10.51 bConfigurationValue
-r--r--r-- 1 root root  4096 17. zář 10.51 bDeviceClass
-r--r--r-- 1 root root  4096 17. zář 10.51 bDeviceProtocol
-r--r--r-- 1 root root  4096 17. zář 10.51 bDeviceSubClass
-r--r--r-- 1 root root  4096 17. zář 10.51 bmAttributes
-r--r--r-- 1 root root  4096 17. zář 18.43 bMaxPacketSize0
-r--r--r-- 1 root root  4096 17. zář 10.51 bMaxPower
-r--r--r-- 1 root root  4096 17. zář 10.51 bNumConfigurations
-r--r--r-- 1 root root  4096 17. zář 10.51 bNumInterfaces
-r--r--r-- 1 root root  4096 17. zář 18.43 busnum
-r--r--r-- 1 root root  4096 17. zář 10.51 configuration
-r--r--r-- 1 root root 65553 17. zář 18.43 descriptors
-r--r--r-- 1 root root  4096 17. zář 18.43 dev
-r--r--r-- 1 root root  4096 17. zář 10.51 devnum
lrwxrwxrwx 1 root root     0 17. zář 10.51 driver -> ../../../../bus/usb/drivers/usb
lrwxrwxrwx 1 root root     0 17. zář 18.43 ep_00 -> usb_endpoint/usbdev7.1_ep00
-r--r--r-- 1 root root  4096 17. zář 10.51 idProduct
-r--r--r-- 1 root root  4096 17. zář 10.51 idVendor
-r--r--r-- 1 root root  4096 17. zář 18.43 manufacturer
-r--r--r-- 1 root root  4096 17. zář 10.51 maxchild
drwxr-xr-x 2 root root     0 17. zář 18.43 power
-r--r--r-- 1 root root  4096 17. zář 18.43 product
-r--r--r-- 1 root root  4096 17. zář 18.43 quirks
-r--r--r-- 1 root root  4096 17. zář 10.51 serial
-r--r--r-- 1 root root  4096 17. zář 10.51 speed
lrwxrwxrwx 1 root root     0 17. zář 10.51 subsystem -> ../../../../bus/usb
-rw-r--r-- 1 root root  4096 17. zář 10.51 uevent
-r--r--r-- 1 root root  4096 17. zář 18.43 urbnum
drwxr-xr-x 3 root root     0 17. zář 10.51 usb_endpoint
-r--r--r-- 1 root root  4096 17. zář 10.51 version
drwxr-xr-x 4 root root     0 17. zář 10.51 7-0:1.0

$ lsusb -s 7:1
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

