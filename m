Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbZABJ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbZABJ4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbZABJ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:56:38 -0500
Received: from eazy.amigager.de ([213.239.192.238]:51856 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbZABJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:56:37 -0500
Date: Fri, 2 Jan 2009 10:56:43 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linux-usb@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be unplugged safely
Message-ID: <20090102095643.GB17103@x61>
Mail-Followup-To: linux-kernel@vger.kernel.org, gregkh@suse.de,
	linux-usb@vger.kernel.org
References: <20090101160343.GA4278@thyme.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090101160343.GA4278@thyme.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 00:03:43 +0800, Yan Li wrote:
> Hello List,
> 
> By default CONFIG_USB_SUSPEND is not enabled and today I got bite by
> this when I got a new WDC My Book hard drive. I have no way to unplug
> it safely, according to it's manual, with a kernel that doesn't have
> CONFIG_USB_SUSPEND=y.
> 
> On it's manual read "you should unplug and remove the device only when
> the light is off." On Linux unmounting it won't turn it's light off
> and I can feel it's motor is still running.  The only way to unplug it
> properly on a Linux system, as to my knowledge, is to echo `suspend'
> to `/sys/bus/usb/devices/$DEV/power/level'. And one has to have
> CONFIG_USB_SUSPEND=y to do this.

With a WD My Passport drive (2,5"), I need to use sg_start --stop --pc=3
to stop the disk before unplugging it. Maybe this works with your
drive, too.  This is also required by some Firewire hard disks.  Maybe
the eject command should be extended to use this method, as it is used
also by HAL to eject hotplug devices.

Regards,
Tino
