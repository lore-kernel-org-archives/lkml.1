Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbXJAISq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbXJAISq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbXJAISj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:18:39 -0400
Received: from tidos.tid.es ([193.145.240.2]:63328 "EHLO correo.tid.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXJAISj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:18:39 -0400
Date: Mon, 01 Oct 2007 10:18:12 +0200
From: Miguel <mc354@tid.es>
Subject: Re: software unplug and plug USB
In-reply-to: <4700A44C.2010700@wpkg.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <1191226692.6014.16.camel@McM>
MIME-version: 1.0
X-Mailer: Evolution 2.10.1
Content-type: text/plain
Content-transfer-encoding: 7BIT
References: <46FCF0F5.9030004@wpkg.org> <1191224165.6014.12.camel@McM>
 <4700A44C.2010700@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I also have a mobile phone connected, a gps and a keyboard, i do the
following:


ecar@ecar:~$ lsmod | grep usb
usbserial              29928  1 pl2303
usbtouchscreen          8708  0 
usbcore               130304  7
libusual,pl2303,usbserial,usbtouchscreen,ehci_hcd,uhci_hcd
ecar@ecar:~$ rmmod pl2303
ERROR: Removing 'pl2303': Operation not permitted
ecar@ecar:~$ sudo rmmod pl2303
ecar@ecar:~$ sudo rmmod usbserial
ecar@ecar:~$ modprobe usbserial
FATAL: Error inserting usbserial
(/lib/modules/2.6.17-11-386/kernel/drivers/usb/serial/usbserial.ko):
Operation not permitted
(reverse-i-search)`mod': cd backup_modules/
(reverse-i-search)`modpro': sudo modprobe  ehci_hcd
ecar@ecar:~$ sudo modprobe usbserial vendor=0x12d1 product=0x1003
ecar@ecar:~$ lsmod | grep usb
usbserial              29928  0 
usbtouchscreen          8708  0 
usbcore               130304  6
usbserial,libusual,usbtouchscreen,ehci_hcd,uhci_hcd


but only when I unplug and plug manually, the modem starts up ...
Because of that i wanted to unplug/plug via scripting (software way)

On Mon, 2007-10-01 at 09:39 +0200, Tomasz Chmielewski wrote:
> Miguel schrieb:
> > actually, I have a USB keyboard, could that be the problem? why?
> 
> Because when you remove USB modules, USB devices, including USB 
> keyboards, won't work...
> 
> 
> > removing and adding modules doesn't solve my problem... The USB has
> > several functions: modem and usb mass storage and only the storage one
> > is recognized 
> > :(
> 
> What modules exactly do you unload/load again, in what order, using 
> which commands?
> 
> 

