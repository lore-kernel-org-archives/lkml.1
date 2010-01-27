Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436Ab0A0CFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0A0CFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539Ab0A0CFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:05:11 -0500
Received: from kroah.org ([198.145.64.141]:36734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0A0CFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:05:10 -0500
Date: Tue, 26 Jan 2010 17:59:47 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Kalo <neilkalo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Steve Holland <sdh4@iastate.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: usbmc seems broken
Message-ID: <20100127015947.GA11685@kroah.com>
References: <5c343a41001220840x6ce6bd29q3b69bbc978b1899f@mail.gmail.com>
 <20100126170125.d199e52c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126170125.d199e52c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 05:01:25PM -0800, Andrew Morton wrote:
> (cc's added)
> 
> On Fri, 22 Jan 2010 16:40:06 +0000
> Neil Kalo <neilkalo@gmail.com> wrote:
> 
> > I cannot get usbtmc to work with my device. I am using fedora 12:
> > 2.6.31.12-174.2.3.fc12.i686.PAE
> > 
> > Jan 22 15:40:26 localhost kernel: usb 4-1: new full speed USB device
> > using ohci_hcd and address 4
> > Jan 22 15:40:26 localhost kernel: usb 4-1: New USB device found,
> > idVendor=05e6, idProduct=2100
> > Jan 22 15:40:26 localhost kernel: usb 4-1: New USB device strings:
> > Mfr=2, Product=3, SerialNumber=1
> > Jan 22 15:40:26 localhost kernel: usb 4-1: Product: 2100 Multimeter
> > Jan 22 15:40:26 localhost kernel: usb 4-1: Manufacturer: KEITHLEY INSTRUMENTS
> > Jan 22 15:40:26 localhost kernel: usb 4-1: SerialNumber: 1160791
> > Jan 22 15:40:26 localhost kernel: usb 4-1: configuration #1 chosen from 1 choice
> > Jan 22 15:40:26 localhost kernel: usbtmc 4-1:1.0: can't read capabilities

This was a bug in this version of the driver.

Please upgrade to 2.6.32, the problem is fixed.

If you are curious, commit id d0a38365d9585bf3fb71f7c57fd532441a14f3e8
solved the problem.

Hope this helps,

greg k-h
