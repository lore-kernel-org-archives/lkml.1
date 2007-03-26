Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbXCZXfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbXCZXfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 19:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbXCZXfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 19:35:16 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37205 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755AbXCZXfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 19:35:15 -0400
X-Originating-Ip: 74.109.98.130
Date: Mon, 26 Mar 2007 19:32:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG variables in kernel Makefiles
Message-ID: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  the output from a short script i wrote, locating all CONFIG_
variables in makefiles that don't appear to exist in any Kconfig file
anywhere in the source tree.

  first, from the drivers/ directory:

===== DRM_FFB =====
./drivers/char/drm/Makefile:obj-$(CONFIG_DRM_FFB)   += ffb.o
===== INPUT_POWER =====
./drivers/input/Makefile:obj-$(CONFIG_INPUT_POWER)      += power.o
===== IPATH_CORE =====
./drivers/Makefile:obj-$(CONFIG_IPATH_CORE)     += infiniband/
===== L7200_KEYB =====
./drivers/acorn/char/Makefile:obj-$(CONFIG_L7200_KEYB)  += defkeymap-l7200.o keyb_l7200.o
===== RADIO_MIROPCM20 =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
===== RADIO_MIROPCM20_RDS =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) += miropcm20-rds.o
===== SCSI_FD_8xx =====
./drivers/scsi/Makefile:obj-$(CONFIG_SCSI_FD_8xx)       += seagate.o
===== USB_EGALAX =====
./drivers/usb/input/Makefile:obj-$(CONFIG_USB_EGALAX)   += touchkitusb.o
===== USB_ITMTOUCH =====
./drivers/usb/input/Makefile:obj-$(CONFIG_USB_ITMTOUCH) += itmtouch.o
===== USB_MTOUCH =====
./drivers/usb/Makefile:obj-$(CONFIG_USB_MTOUCH) += input/
./drivers/usb/input/Makefile:obj-$(CONFIG_USB_MTOUCH)   += mtouchusb.o
===== USB_OHCI_AT91 =====
./drivers/usb/Makefile:obj-$(CONFIG_USB_OHCI_AT91)      += host/
===== ZS =====
./drivers/tc/Makefile:obj-$(CONFIG_ZS) += zs.o

  and from the fs/ directory:

===== NLS_ABC =====
./fs/nls/Makefile:obj-$(CONFIG_NLS_ABC)         += nls_abc.o
===== NLS_ISO8859_10 =====
./fs/nls/Makefile:obj-$(CONFIG_NLS_ISO8859_10)  += nls_iso8859-10.o

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
