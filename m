Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYGHSSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYGHSSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYGHSR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:17:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38583 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYGHSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:17:56 -0400
Date: Tue, 8 Jul 2008 11:16:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jkosina@suse.cz
Subject: Re: linux-next: Tree for July 8 (HID)
Message-Id: <20080708111649.e61b19bc.randy.dunlap@oracle.com>
In-Reply-To: <20080708192251.3275d283.sfr@canb.auug.org.au>
References: <20080708192251.3275d283.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/built-in.o: In function `usb_kbd_probe':
usbkbd.c:(.text+0x1457c9): undefined reference to `usbhid_lookup_quirk'
drivers/built-in.o: In function `usb_mouse_probe':
usbmouse.c:(.text+0x14603c): undefined reference to `usbhid_lookup_quirk'
make[1]: *** [.tmp_vmlinux1] Error 1


from (partial config):

CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_USB_HIDINPUT_POWERBOOK=y
CONFIG_HID_FF=y
# CONFIG_HID_PID is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
