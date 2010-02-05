Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0BERX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:23:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933567Ab0BERWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:22:54 -0500
Date: Fri, 5 Feb 2010 09:16:59 -0800
From: Greg KH <gregkh@suse.de>
To: Chris Verges <chrisv@cyberswitching.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rob Owings <rowings@thermistor.com>
Subject: Re: [PATCH] linux-2.6.32-directemp
Message-ID: <20100205171659.GF14145@suse.de>
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:47:05PM -0800, Chris Verges wrote:
> Hi Linux gurus,
> 
> Attached is a patch for the QTI DirecTEMP USB thermometer &
> thermometer/hygrometer sensors.  This patch is based on linux-2.6.32.
> Functionality has been verified against both hardware variants listed in
> the driver (0x0002 and 0x0006), as both monolithic and modular.
> 
> When the QTI DirecTEMP sensor is connected to a system, the directemp
> driver adds appropriate sysfs entries for the sensor type(s) supported.
> Examples:
> 
>    # PID 0x0002 (temp only)
>    /sys/bus/usb/devices/.../temp
> 
>    # PID 0x0006 (temp + relative humidity)
>    /sys/bus/usb/devices/.../temp
>    /sys/bus/usb/devices/.../rh
> 
> Using a standard "cat" will display the value.
> 
> An additional "raw" sysfs entry has been added to aid in debugging.  If
> used, an "echo" will send the data specified in the string to the USB
> device, and print back the results.  It is not recommended for customer
> use except by expert users.

Is a kernel driver really needed for this device?  You could do this all
in userspace with libusb/usbfs and not need a driver, right?

That's what we do for other USB thermometers today.

thanks,

greg k-h
