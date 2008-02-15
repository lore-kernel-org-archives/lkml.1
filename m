Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbYBOI2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbYBOI2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYBOI2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:28:25 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3146 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYBOI2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:28:24 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: problem with starting 2.5.25-rc1 and latest git
Date: Fri, 15 Feb 2008 09:28:19 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200802132316.03155.m.kozlowski@tuxland.pl> <20080214234748.GA6061@suse.de>
In-Reply-To: <20080214234748.GA6061@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802150928.19530.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > 	I tried 2.6.25-rc1 and latest git on my laptop (x86 32bit) and have a problem.
> > Linux boots but with huge delay due to some issue with loading usb modules.
> > Udev complains:
> > 
> > 'Could not lock modprobe uhci_hcd'
> > 'Could not lock modprobe yenta_socket'
> > 'Unknown symbol usb_*'
> > 'Gave up waiting for init of module usbcore'
> > 
> > at the same time I can see these messages in syslog (look at timing - grep by usb):
> > 
> > Feb 13 21:34:22 laptop kernel: usbcore: registered new interface driver usbfs
> > Feb 13 21:34:22 laptop kernel: usbcore: registered new interface driver hub
> > Feb 13 21:34:22 laptop kernel: usbcore: registered new device driver usb
> > Feb 13 21:34:22 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> 
> I don't see how this is a usb issue, it looks to be a module loading
> issue, which is in the module core and module-init-tools.

Well ... that was just a guess.

> What version of module-init-tools do you have, and are you using an
> initramfs that loads these modules?  If so, what distro and version are
> you using?

I'm using gentoo. No initramfs. The same configuration under 2.6.24 boots without
delays.

module-init-tools: 3.4
udev: 115 (gentoo says 115-r1)

this is my grub.conf entry (on 2.6.24 I have identical boot parameters):

title  2.6.25-rc1
root (hd0,0)
kernel (hd0,0)/kernel-2.6.25-rc1 root=/dev/hda3 vga=0x318 video=vesafb:mtrr lapic pci=routeirq rootflags=data=writeback


Linux laptop 2.6.24 #2 PREEMPT Sat Jan 26 00:48:39 CET 2008 i686 Intel(R) Pentium(R) 4 CPU 2.40GHz GenuineIntel GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.18
util-linux             2.13
mount                  2.13
module-init-tools      3.4
e2fsprogs              1.40.4
pcmciautils            014
pcmcia-cs              3.2.8
PPP                    2.4.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9
udev                   115
wireless-tools         29
Modules Loaded         orinoco_cs orinoco hermes pcmcia firmware_class ehci_hcd psmouse parport_pc parport 8139too uhci_hcd usbcore yenta_socket rsrc_nonstatic rtc floppy

Regards,

	Mariusz
