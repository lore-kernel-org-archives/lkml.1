Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYCKCh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYCKCh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYCKChS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:37:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1374 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750699AbYCKChP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:37:15 -0400
Date: Mon, 10 Mar 2008 22:37:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: 2.6.25-rc3 sometimes reboot with usb init(probe?) slowly
In-Reply-To: <20080311021314.GA3350@darkstar.te-china.tietoenator.com>
Message-ID: <Pine.LNX.4.44L0.0803102235110.30713-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Dave Young wrote:

> Hi,
> Sometimes (not every time) rebooting will be slow while initilize usb
> device
> 
> This is not limited to 2.6.25-rc3.
> 
> Please see the timing issue in following dmesg output:
> 
> ---
...
> [    9.167129] usbcore: registered new interface driver hiddev
> [    9.182630] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input0
> [   64.677054] usb 1-1: USB disconnect, address 2
> [   64.677054] usb 1-1.3: USB disconnect, address 5
> [   64.678008] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-2
> [   64.693697] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input1
> [   64.713662] input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.2-1
> [   64.713676] usbcore: registered new interface driver usbhid
> [   64.713676] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver

More information is needed.  You should turn on CONFIG_USB_DEBUG.

Alan Stern

