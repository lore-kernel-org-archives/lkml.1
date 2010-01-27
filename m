Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868Ab0A0BBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0A0BBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447Ab0A0BBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:01:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201Ab0A0BBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:01:51 -0500
Date: Tue, 26 Jan 2010 17:01:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Kalo <neilkalo@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Steve Holland <sdh4@iastate.edu>, Oliver Neukum <oliver@neukum.org>
Subject: Re: usbmc seems broken
Message-Id: <20100126170125.d199e52c.akpm@linux-foundation.org>
In-Reply-To: <5c343a41001220840x6ce6bd29q3b69bbc978b1899f@mail.gmail.com>
References: <5c343a41001220840x6ce6bd29q3b69bbc978b1899f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Fri, 22 Jan 2010 16:40:06 +0000
Neil Kalo <neilkalo@gmail.com> wrote:

> I cannot get usbtmc to work with my device. I am using fedora 12:
> 2.6.31.12-174.2.3.fc12.i686.PAE
> 
> Jan 22 15:40:26 localhost kernel: usb 4-1: new full speed USB device
> using ohci_hcd and address 4
> Jan 22 15:40:26 localhost kernel: usb 4-1: New USB device found,
> idVendor=05e6, idProduct=2100
> Jan 22 15:40:26 localhost kernel: usb 4-1: New USB device strings:
> Mfr=2, Product=3, SerialNumber=1
> Jan 22 15:40:26 localhost kernel: usb 4-1: Product: 2100 Multimeter
> Jan 22 15:40:26 localhost kernel: usb 4-1: Manufacturer: KEITHLEY INSTRUMENTS
> Jan 22 15:40:26 localhost kernel: usb 4-1: SerialNumber: 1160791
> Jan 22 15:40:26 localhost kernel: usb 4-1: configuration #1 chosen from 1 choice
> Jan 22 15:40:26 localhost kernel: usbtmc 4-1:1.0: can't read capabilities
> 
> If I compile the original Agilent module from
> "http://www.home.agilent.com/upload/cmc_upload/All/usbtmc.html" It
> works fine:
> 
> Jan 22 15:37:45 localhost kernel: usb 4-1: new full speed USB device
> using ohci_hcd and address 3
> Jan 22 15:37:45 localhost kernel: usb 4-1: New USB device found,
> idVendor=05e6, idProduct=2100
> Jan 22 15:37:45 localhost kernel: usb 4-1: New USB device strings:
> Mfr=2, Product=3, SerialNumber=1
> Jan 22 15:37:45 localhost kernel: usb 4-1: Product: 2100 Multimeter
> Jan 22 15:37:45 localhost kernel: usb 4-1: Manufacturer: KEITHLEY INSTRUMENTS
> Jan 22 15:37:45 localhost kernel: usb 4-1: SerialNumber: 1160791
> Jan 22 15:37:45 localhost kernel: usb 4-1: configuration #1 chosen from 1 choice
> Jan 22 15:37:45 localhost kernel: USBTMC: MKDEV
> Jan 22 15:37:45 localhost kernel: USBTMC: CDEV_ADD f900000 1
> 
> Note that I do get one error line per module load, but this does not
> prevent the device from working in my application:
> Jan 22 15:38:21 localhost kernel: USBTMC: Unable to read data, error -110
> 
> This error also sometimes occurs with the standard kernel module, but
> I never get a functioning connection to my device:
> Jan 16 23:43:36 localhost kernel: usbtmc 1-4.1.1:1.0: can't read capabilities
> Jan 16 23:52:31 localhost kernel: usbtmc 1-4.1.1:1.0: Unable to read
> data, error -110
> 
> Where do I go from here?

