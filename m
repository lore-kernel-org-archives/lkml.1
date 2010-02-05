Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0BEPpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:45:35 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49230 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751009Ab0BEPpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:45:34 -0500
Date: Fri, 5 Feb 2010 10:45:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Chris Verges <chrisv@cyberswitching.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Rob Owings <rowings@thermistor.com>
Subject: Re: [PATCH] linux-2.6.32-directemp
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
Message-ID: <Pine.LNX.4.44L0.1002051042410.24090-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Chris Verges wrote:

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

This isn't a big deal... but it's more common for drivers to provide
regular device files for I/O than to rely on sysfs attributes.  You end 
up with more control and flexibility.

Alan Stern

