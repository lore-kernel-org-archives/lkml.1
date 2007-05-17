Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbXEQSRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbXEQSRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXEQSRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:17:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35412 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXEQSRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:17:10 -0400
Date: Thu, 17 May 2007 11:14:27 -0700
From: Greg KH <greg@kroah.com>
To: art@usfltd.com
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
Message-ID: <20070517181427.GB5735@kroah.com>
References: <20070517120544.d2hnzayns4o8scks@67.106.77.50>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517120544.d2hnzayns4o8scks@67.106.77.50>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 12:05:44PM -0500, art@usfltd.com wrote:
>  greg
> 
> >> You didn't answer my, "what distro are you using" question.  Also, what
>  package created the udev rule that creates the above symlink?
> 
>  distro fc6
>  Linux xxx.xxx 2.6.22-rc1-200705170855cfq6-g0479ea0e #134 SMP PREEMPT Thu May 
>  17 09:13:26 CDT 2007 x86_64 x86_64 x86_64 GNU/Linux

You answered the first question above, not the second :(

>  2.6.20
> 
>  $ udevtest /class/usb_device/usbdev2.10
>  main: looking at device '/class/usb_device/usbdev2.10' from subsystem 
>  'usb_device'
>  run_program: '/bin/sh -c 'K=usbdev2.10; K=${K#usbdev}; printf 
>  bus/usb/%03i/%03i ${K%%.*} ${K#*.}''
>  run_program: '/bin/sh' (stdout) 'bus/usb/002/010'
>  run_program: '/bin/sh' returned with status 0
>  udev_rules_get_name: rule applied, 'usbdev2.10' becomes 'bus/usb/002/010'
>  udev_rules_get_name: add symlink 'scanner-usbdev2.10'
>  udev_device_event: device '/class/usb_device/usbdev2.10' already in 
>  database, validate currently present symlinks
>  udev_node_add: creating device node '/dev/bus/usb/002/010', major = '189', 
>  minor = '137', mode = '0644', uid = '0', gid = '0'
>  udev_node_add: creating symlink '/dev/scanner-usbdev2.10' to 
>  'bus/usb/002/010'
>  main: run: 'socket:/org/kernel/udev/monitor'
>  main: run: '/lib/udev/udev_run_devd'
>  main: run: 'socket:/org/freedesktop/hal/udev_event'
>  main: run: '/sbin/pam_console_apply /dev/bus/usb/002/010 
>  /dev/scanner-usbdev2.10'

And if you run that 'udevtest' command on 2.6.21 what happens?

Again, you have not shown me the udev rule that adds that symlink, is it
something you added by hand, or something that Fedora added to the rules
file?

thanks,

greg k-h
