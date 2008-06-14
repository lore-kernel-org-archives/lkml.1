Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYFNL6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYFNL6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 07:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYFNL63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 07:58:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:15870 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYFNL62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 07:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iBXHVkmZjE90oHTCGPJgfMUvEKQvsNVezNvAnDc3KKbHvgrGlhdtxacOMRS7J51HxL
         CVMYqUJ6Bw6vzmUMCVBXbSTqhgXLQSVOxLA5ILG9BZy7Va1Syrxs9aOOOBs0FS5AuCeA
         CHlITwfCOF5iEjFNs6l61vwtJsHnIZ5SMhdeg=
Message-ID: <5e50e1d60806140458r3c42a8cakf53c2a1a0da39123@mail.gmail.com>
Date: Sat, 14 Jun 2008 17:28:26 +0530
From: "umesh kernel" <umesh.linuxkernel@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: linux-2.6.25.6: Cannot "make" OPTION Module
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I just installed  Debian 4 "etch" on my Thinkpad R61i, wanted to add
changes in Option.c for my external USB GSM modem, just adding vendor
and product id. I have downloaded linux-2.6.25.6 and using it for
making the Kernel module. But "make" gives me error. Not sure what
exactly is wrong. Below is the Makefile and the errors which get when
i run make. Any ideas as how to rectify this? do i need to add any
specific packages for Debian?

================
obj-m := option.o
KDIR  := /lib/modules/$(shell uname -r)/build
PWD   := $(shell pwd)
default:
        $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
================

================
debian4-R61i:~# cd usr/src/linux-2.6.25.6/drivers
/usb/serial/
debian4-R61i:/usr/src/linux-2.6.25.6/drivers/usb/serial# make
make -C /lib/modules/2.6.18-6-486/build
SUBDIRS=/usr/src/linux-2.6.25.6/drivers/usb/serial modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.18-6-486'
  CC [M]  /usr/src/linux-2.6.25.6/drivers/usb/serial/option.o
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:63: warning:
'struct ktermios' declared inside parameter ist
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:63: warning: its
scope is only this definition or declaration, which is probably not
what you want
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:236: warning:
implicit declaration of function 'USB_DEVICE_AND_INTERFACE_INFO'
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:236: error:
initializer element is not constant
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:236: error: (near
initialization for 'option_ids[36].match_flags')
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:237: error:
initializer element is not constant
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:237: error: (near
initialization for 'option_ids[37].match_flags')
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:330: error:
unknown field 'usb_driver' specified in initializer
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:330: warning:
initialization from incompatible pointer type
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:344: warning:
initialization from incompatible pointer type
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:350: warning:
initialization from incompatible pointer type
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:433: warning:
'struct ktermios' declared inside parameter list
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:434: error:
conflicting types for 'option_set_termios'
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:63: error:
previous declaration of 'option_set_termios' was here
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c: In function
'option_set_termios':
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:437: warning:
implicit declaration of function 'tty_termios_copy_hw'
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c: In function 'option_close':
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:763: error:
'struct usb_serial' has no member named 'disc_mutex'
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:763: warning:
passing argument 1 of 'mutex_lock' from incompatible pointer type
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:764: error:
'struct usb_serial' has no member named 'disconnected'
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:766: error:
'struct usb_serial' has no member named 'disc_mutex'
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:766: warning:
passing argument 1 of 'mutex_unlock' from incompatible pointer type
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c: In function
'option_setup_urb':
/usr/src/linux-2.6.25.6/drivers/usb/serial/option.c:796: warning:
passing argument 6 of 'usb_fill_bulk_urb' from incompatible pointer
type
make[2]: *** [/usr/src/linux-2.6.25.6/drivers/usb/serial/option.o] Error 1
make[1]: *** [_module_/usr/src/linux-2.6.25.6/drivers/usb/serial] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.18-6-486'
make: *** [default] Error 2
debian4-R61i:/usr/src/linux-2.6.25.6/drivers/usb/serial#
================

Regards,
Umesh
