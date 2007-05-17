Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbXEQRHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbXEQRHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbXEQRGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:06:54 -0400
Received: from mail4.webhostingstar.com ([67.106.77.50]:47251 "HELO
	mail4.webhostingstar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755571AbXEQRGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:06:54 -0400
Message-ID: <20070517120544.d2hnzayns4o8scks@67.106.77.50>
Date: Thu, 17 May 2007 12:05:44 -0500
From: art@usfltd.com
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org, greg@kroah.com
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

greg

>> You didn't answer my, "what distro are you using" question.  Also, what
package created the udev rule that creates the above symlink?

distro fc6
Linux xxx.xxx 2.6.22-rc1-200705170855cfq6-g0479ea0e #134 SMP PREEMPT  
Thu May 17 09:13:26 CDT 2007 x86_64 x86_64 x86_64 GNU/Linux


2.6.20

$ udevtest /class/usb_device/usbdev2.10
main: looking at device '/class/usb_device/usbdev2.10' from subsystem  
'usb_device'
run_program: '/bin/sh -c 'K=usbdev2.10; K=${K#usbdev}; printf  
bus/usb/%03i/%03i ${K%%.*} ${K#*.}''
run_program: '/bin/sh' (stdout) 'bus/usb/002/010'
run_program: '/bin/sh' returned with status 0
udev_rules_get_name: rule applied, 'usbdev2.10' becomes 'bus/usb/002/010'
udev_rules_get_name: add symlink 'scanner-usbdev2.10'
udev_device_event: device '/class/usb_device/usbdev2.10' already in  
database, validate currently present symlinks
udev_node_add: creating device node '/dev/bus/usb/002/010', major =  
'189', minor = '137', mode = '0644', uid = '0', gid = '0'
udev_node_add: creating symlink '/dev/scanner-usbdev2.10' to 'bus/usb/002/010'
main: run: 'socket:/org/kernel/udev/monitor'
main: run: '/lib/udev/udev_run_devd'
main: run: 'socket:/org/freedesktop/hal/udev_event'
main: run: '/sbin/pam_console_apply /dev/bus/usb/002/010  
/dev/scanner-usbdev2.10'



xboom
