Return-Path: <linux-kernel-owner+w=401wt.eu-S934822AbXHORwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822AbXHORwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbXHORw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:52:26 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:1247 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbXHORwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:52:25 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 13:52:25 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Aug 2007 17:22:21.0970 (UTC) FILETIME=[D6F6C720:01C7DF60]
Content-class: urn:content-classes:message
Subject: USB Keyboard
Date: Wed, 15 Aug 2007 13:22:21 -0400
Message-ID: <Pine.LNX.4.61.0708151320380.8581@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: USB Keyboard
Thread-Index: AcffYNb+ef9oY1MmR5y50naUBxdOKg==
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello all,

I have been using linux-2.6.16.24 for development.
However, when I boot a sustem that uses a Dell USB
keyboard with a hub built into a Dell monitor, there
are continuous keyboard disconnect messages until
I exercise ^S/^Q. Then, everything is fine. I
thought maybe there was a bug that had been fixed
in later versions so I built and installed Linux-2.6.22.1.
The required usbhid.ko doesn't build, even though it
is enabled in ".config."

CONFIG_USB_DABUSB=m
# USB devices
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
# CONFIG_SND_USB_CAIAQ is not set
# USB Input Devices
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
CONFIG_USB_HIDDEV=y
# USB HID Boot Protocol drivers
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
# USB support
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# Miscellaneous USB options
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
# USB Host Controller Drivers
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
# USB Device Class drivers
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

Also, the following errors occur when building the kernel:

   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   CALL    scripts/checksyscalls.sh
   CHK     include/linux/compile.h
   MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0xfca1): Section mismatch: reference to .init.data:trampoline_end (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.text+0xfca9): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.text+0xfcb3): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.exit.text+0x26): Section mismatch: reference to .init.text: (between 'cache_remove_dev' and 'ffh_cstate_exit')
WARNING: arch/i386/kernel/built-in.o(.data+0xe20): Section mismatch: reference to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mtrr_mutex')
WARNING: kernel/built-in.o(.text+0x1b582): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
Kernel: arch/i386/boot/bzImage is ready  (#1)
   Building modules, stage 2.
   MODPOST 1258 modules
WARNING: drivers/net/sis900.o(.text+0x4b8): Section mismatch: reference to .init.text:sis900_mii_probe (between 'sis900_probe' and 'sis900_default_phy')
WARNING: drivers/net/sunhme.o(.text+0x2f49): Section mismatch: reference to .init.text: (between 'happy_meal_pci_probe' and 'happy_meal_pci_remove')

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
