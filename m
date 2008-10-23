Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYJWTkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYJWTkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYJWTkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:40:25 -0400
Received: from kroah.org ([198.145.64.141]:48156 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753585AbYJWTkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:40:24 -0400
Date: Thu, 23 Oct 2008 12:36:50 -0700
From: Greg KH <greg@kroah.com>
To: "Gu, Mingkun" <Mingkun.Gu@GTECH.COM>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help: undesired 10 seconds delay in creating USB devices
Message-ID: <20081023193650.GB10397@kroah.com>
References: <20081023161355.GA8171@kroah.com> <32C88E5279F5DD46B7237443CD61E67901E455BB@cspmail02.gtk.gtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32C88E5279F5DD46B7237443CD61E67901E455BB@cspmail02.gtk.gtech.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 04:30:34PM -0300, Gu, Mingkun wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, October 23, 2008 1:14 PM
> > To: Gu, Mingkun
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: Help: undesired 10 seconds delay in creating USB devices
> > 
> > On Thu, Oct 23, 2008 at 01:11:00PM -0300, Gu, Mingkun wrote:
> > 
> > Please stop sending email in HTML format, the mailing lists reject it.
> > 
> > > [MKGU>] My device driver name is "usbled". Our USB device has
> > > VendorID=11b4. After I unplugged the USB cable connecting to this
> device
> > > and kept the device driver "usbled" remaining loaded, I plugged in
> the
> > > USB cable back to the system again. I could see the device
> information
> > > retrieved from /proc/bus/usb/devices immediately but the device name
> > > /dev/usbled0 was seen after near 10 seconds.
> > 
> > That sounds like a udev script issue, not a kernel issue, correct?
> > 
> 
> [MKGU>] Yes. It seems related to udev.
> 
> > > > If you run 'udevadm monitor', does it show a 10 second delay?
> > >
> > > [MKGU>] I don't have the program 'udevadm' on my system.
> > 
> > Do you have the program 'udevmonitor'?  I suggest trying that.
> > 
> 
> [MKGU>] Yes, I ran "udevmonitor" and captured the following messages:
> UEVENT[1224775488.005799] remove   /class/usb/usbled0 (usb)
> UEVENT[1224775488.007901] remove   /class/usb (class)
> UEVENT[1224775488.011992] remove
> /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
> UEVENT[1224775488.019706] remove
> /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
> UEVENT[1224775496.176576] add
> /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
> UEVENT[1224775496.181732] add
> /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
> UEVENT[1224775496.186031] add      /class/usb/usbled0 (usb)

Then I suggest filing a bug with your distro to get this looked at, as
they are responsible for the udev scripts here, nothing wrong with your
kernel :)

good luck,

greg k-h
