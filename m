Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZLDPVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZLDPVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbZLDPU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:20:59 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54822 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751099AbZLDPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:20:58 -0500
Date: Fri, 4 Dec 2009 10:21:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ed Tomlinson <edt@aei.ca>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [BUG] 2.6.32 - Sddr-09 SM reader resets endlessly
In-Reply-To: <200912031800.11780.edt@aei.ca>
Message-ID: <Pine.LNX.4.44L0.0912041019410.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Ed Tomlinson wrote:

> Hi,
> 
> Just booted in 2.6.32 and shortly after the boot finished my console was spammed with:
> 
> [   72.221620] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
> [   72.375589] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
> [   72.529568] usb 7-4.1: reset full speed USB device using ehci_hcd and address 5                                                           
...

> I noticed the leds on the devince blinking and unplugged it.  The messages stopped.
> 
> Plugging it in to another port gave:
> 
> [  120.096590] usb 7-4.2: new full speed USB device using ehci_hcd and address 7                                                             
> [  120.188421] usb 7-4.2: New USB device found, idVendor=0781, idProduct=0200                                                                
> [  120.196857] usb 7-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0                                                           
> [  120.205801] usb 7-4.2: Product: USB SSFDC                                                                                                 
> [  120.205803] usb 7-4.2: Manufacturer: SanDisk                                                                                              
> [  120.206023] usb 7-4.2: configuration #1 chosen from 1 choice                                                                              
> [  120.210375] scsi10 : SCSI emulation for USB Mass Storage devices                                                                          
> [  120.210625] usb-storage: device found at 7                                                                                                
> [  120.210627] usb-storage: waiting for device to settle before scanning                                                                     
> [  125.210356] scsi 10:0:0:0: Direct-Access     Sandisk0 ImageMate SDDR-0 0208 PQ: 0 ANSI: 0                                                 
> [  125.221014] sd 10:0:0:0: Attached scsi generic sg8 type 0                                                                                 
> [  125.538583] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
> [  125.693592] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
> [  125.846595] usb 7-4.2: reset full speed USB device using ehci_hcd and address 7
...

> just in case it happened to be an interaction with the hub used I tried another:
...

> with the same results.
> 
> Ideas? 

More information is needed.  Collect a usbmon trace showing what 
happens when the device is plugged in.  Instructions are in the kernel 
source file Documentation/usb/usbmon.txt.

Alan Stern

