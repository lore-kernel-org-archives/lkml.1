Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0BXDhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:37:07 -0500
Received: from kroah.org ([198.145.64.141]:47114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0BXDhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:37:01 -0500
Date: Tue, 23 Feb 2010 18:18:56 -0800
From: Greg KH <greg@kroah.com>
To: Neil Kalo <neilkalo@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Steve Holland <sdh4@iastate.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: usbmc seems broken
Message-ID: <20100224021856.GA14173@kroah.com>
References: <5c343a41001220840x6ce6bd29q3b69bbc978b1899f@mail.gmail.com> <20100126170125.d199e52c.akpm@linux-foundation.org> <20100127015947.GA11685@kroah.com> <5c343a41002040032w54bb9953nd6bfe60a06553625@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c343a41002040032w54bb9953nd6bfe60a06553625@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:32:21AM +0000, Neil Kalo wrote:
> Upgraded to: 2.6.32.7-37.fc12.i686.PAE
> 
> Still no joy. Plugging in the meter gives:
> 
> Feb  4 08:27:04 localhost kernel: usb 4-1: new full speed USB device
> using ohci_hcd and address 2
> Feb  4 08:27:04 localhost kernel: usb 4-1: New USB device found,
> idVendor=05e6, idProduct=2100
> Feb  4 08:27:04 localhost kernel: usb 4-1: New USB device strings:
> Mfr=2, Product=3, SerialNumber=1
> Feb  4 08:27:04 localhost kernel: usb 4-1: Product: 2100 Multimeter
> Feb  4 08:27:04 localhost kernel: usb 4-1: Manufacturer: KEITHLEY INSTRUMENTS
> Feb  4 08:27:04 localhost kernel: usb 4-1: SerialNumber: 1160791
> Feb  4 08:27:04 localhost kernel: usb 4-1: configuration #1 chosen from 1 choice
> Feb  4 08:27:04 localhost kernel: usbcore: registered new interface
> driver usbtmc
> 
> But "cat /dev/usbtmc0" gives:
> cat: /dev/usbtmc0: Connection timed out
> 
> And in the logs:
> Feb  4 08:27:35 localhost kernel: usbtmc 4-1:1.0: Unable to read data,
> error -110
> 
> The very old driver still works:
> 
> Feb  4 08:31:02 localhost kernel: USBTMC: MKDEV
> Feb  4 08:31:02 localhost kernel: USBTMC: CDEV_ADD f900000 1
> Feb  4 08:31:02 localhost kernel: usbcore: registered new interface
> driver USBTMC
> 
> [root@mc22 usbtmc-module]# cat /dev/usbtmc0
> Minor Number    Manufacturer    Product Serial Number
> 001     KEITHLEY INSTRUMENTS    2100 Multimeter 1160791

Care to try to figure out what is going wrong here and send a patch?

thanks,

greg k-h
