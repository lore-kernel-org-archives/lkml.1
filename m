Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZDVKHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZDVKHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZDVKHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:07:04 -0400
Received: from langos.euedge.com ([209.190.22.130]:58273 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbZDVKHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:07:02 -0400
Message-ID: <49EEEC43.6030806@maroy.hu>
Date: Wed, 22 Apr 2009 12:06:59 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
References: <49EDC44D.90106@maroy.hu> <200904211526.34199.oliver@neukum.org>
In-Reply-To: <200904211526.34199.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

> Does it happen with 2.6.29?
> Could you get dmesg of 2.6.2(7/9) with CONFIG_USB_DEBUG and debug
> activated in drivers/usb/class/cdc-acm.c ?

interesting, the dmesg output is not that talkative:

Apr 22 11:50:37 tomodachi kernel: [  623.236068] usb 2-1: new full speed
USB device using uhci_hcd and address 2
Apr 22 11:50:37 tomodachi kernel: [  623.400102] usb 2-1: New USB device
found, idVendor=ffff, idProduct=0005
Apr 22 11:50:37 tomodachi kernel: [  623.400107] usb 2-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=3
Apr 22 11:50:37 tomodachi kernel: [  623.400111] usb 2-1: Product: USBSerial
Apr 22 11:50:37 tomodachi kernel: [  623.400114] usb 2-1: Manufacturer:
LPCUSB
Apr 22 11:50:37 tomodachi kernel: [  623.400117] usb 2-1: SerialNumber:
DEADC0DE
Apr 22 11:50:37 tomodachi kernel: [  623.400654] usb 2-1: configuration
#1 chosen from 1 choice
Apr 22 11:50:37 tomodachi kernel: [  623.453590] cdc_acm 2-1:1.0:
ttyACM0: USB ACM device
Apr 22 11:50:37 tomodachi kernel: [  623.457094] usbcore: registered new
interface driver cdc_acm
Apr 22 11:50:37 tomodachi kernel: [  623.457100] cdc_acm: v0.26:USB
Abstract Control Model driver for USB modems and ISDN adapters


even though:

$ zcat /proc/config.gz | grep CONFIG_USB_DEBUG
CONFIG_USB_DEBUG=y


maybe it did not recompile the cdc-acm module after I changed the
CONFIG_USB_DEBUG setting in .config? I'll do a clean recompile..


Akos

