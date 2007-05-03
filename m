Return-Path: <linux-kernel-owner+w=401wt.eu-S1161219AbXECJ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbXECJ6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161458AbXECJ6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:58:38 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48963 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161219AbXECJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:58:37 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 05:58:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: linux-usb-devel@lists.sourceforge.net
Subject: dead CONFIG_ variables:  drivers/usb/
Message-ID: <Pine.LNX.4.64.0705030554060.30212@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


$ ../dead_config.sh drivers/usb
========== MACH_OMAP_H4_OTG ==========
drivers/usb/gadget/omap_udc.c:2159:#ifndef CONFIG_MACH_OMAP_H4_OTG
========== USBD_SAFE_SERIAL_PRODUCT ==========
drivers/usb/serial/safe_serial.c:93:#if defined(CONFIG_USBD_SAFE_SERIAL_VENDOR) && !defined(CONFIG_USBD_SAFE_SERIAL_PRODUCT)
========== USBD_SAFE_SERIAL_VENDOR ==========
drivers/usb/serial/safe_serial.c:93:#if defined(CONFIG_USBD_SAFE_SERIAL_VENDOR) && !defined(CONFIG_USBD_SAFE_SERIAL_PRODUCT)
drivers/usb/serial/safe_serial.c:97:#if ! defined(CONFIG_USBD_SAFE_SERIAL_VENDOR)
========== USB_GADGETFS_PXA2XX ==========
drivers/usb/gadget/inode.c:1508:#ifndef CONFIG_USB_GADGETFS_PXA2XX
========== USB_GADGET_HUSB2DEV ==========
drivers/usb/gadget/gadget_chips.h:78:#ifdef CONFIG_USB_GADGET_HUSB2DEV
drivers/usb/gadget/ether.c:281:#ifdef CONFIG_USB_GADGET_HUSB2DEV
========== USB_GADGET_IMX ==========
drivers/usb/gadget/gadget_chips.h:96:#ifdef CONFIG_USB_GADGET_IMX
========== USB_GADGET_MPC8272 ==========
drivers/usb/gadget/gadget_chips.h:122:#ifdef CONFIG_USB_GADGET_MPC8272
========== USB_GADGET_MQ11XX ==========
drivers/usb/gadget/gadget_chips.h:54:#ifdef CONFIG_USB_GADGET_MQ11XX
drivers/usb/gadget/ether.c:249:#ifdef CONFIG_USB_GADGET_MQ11XX
========== USB_GADGET_MUSB_HDRC ==========
drivers/usb/gadget/gadget_chips.h:116:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/gadget/ether.c:277:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
========== USB_GADGET_MUSBHSFC ==========
drivers/usb/gadget/gadget_chips.h:109:#ifdef CONFIG_USB_GADGET_MUSBHSFC
drivers/usb/gadget/ether.c:273:#ifdef CONFIG_USB_GADGET_MUSBHSFC
========== USB_GADGET_N9604 ==========
drivers/usb/gadget/gadget_chips.h:66:#ifdef CONFIG_USB_GADGET_N9604
drivers/usb/gadget/ether.c:257:#ifdef CONFIG_USB_GADGET_N9604
========== USB_GADGET_PXA27X ==========
drivers/usb/gadget/gadget_chips.h:72:#ifdef CONFIG_USB_GADGET_PXA27X
drivers/usb/gadget/ether.c:261:#ifdef CONFIG_USB_GADGET_PXA27X
========== USB_GADGET_S3C2410 ==========
drivers/usb/gadget/gadget_chips.h:84:#ifdef CONFIG_USB_GADGET_S3C2410
drivers/usb/gadget/ether.c:265:#ifdef CONFIG_USB_GADGET_S3C2410
========== USB_GADGET_SA1100 ==========
drivers/usb/gadget/gadget_chips.h:42:#ifdef CONFIG_USB_GADGET_SA1100
drivers/usb/gadget/ether.c:300:#ifdef CONFIG_USB_GADGET_SA1100
========== USB_GADGET_SH ==========
drivers/usb/gadget/ether.c:296:#ifdef CONFIG_USB_GADGET_SH
========== USB_GADGET_SUPERH ==========
drivers/usb/gadget/gadget_chips.h:36:#ifdef CONFIG_USB_GADGET_SUPERH
========== USB_SAFE_PADDED ==========
drivers/usb/serial/safe_serial.c:77:#ifndef CONFIG_USB_SAFE_PADDED
drivers/usb/serial/safe_serial.c:78:#define CONFIG_USB_SAFE_PADDED 0
drivers/usb/serial/safe_serial.c:83:static int padded = CONFIG_USB_SAFE_PADDED;
========== USB_SAFE_SERIAL_VENDOR ==========
drivers/usb/serial/safe_serial.c:148:#if defined(CONFIG_USB_SAFE_SERIAL_VENDOR)
drivers/usb/serial/safe_serial.c:150:    (CONFIG_USB_SAFE_SERIAL_VENDOR, CONFIG_USB_SAFE_SERIAL_PRODUCT, CDC_DEVICE_CLASS,

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
