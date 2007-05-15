Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbXEOWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbXEOWxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbXEOWxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:53:07 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53650 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544AbXEOWxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:53:06 -0400
Date: Tue, 15 May 2007 15:51:18 -0700
From: Greg KH <greg@kroah.com>
To: art@usfltd.com
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
Message-ID: <20070515225118.GA15780@kroah.com>
References: <20070515124256.ijmnpcako4g8w8g0@67.106.77.50>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515124256.ijmnpcako4g8w8g0@67.106.77.50>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 12:42:56PM -0500, art@usfltd.com wrote:
>  Linux 2.6.22-rc1-gfaa8b6c3 #130 SMP PREEMPT Tue May 15 08:45:16 CDT 2007 
>  x86_64 x86_64 x86_64 GNU/Linux
> 
>  udev.x86_64  095
> 
>  usb hotplug/udev cannot correctly register usb/scanners, usb/cameras
>  udev doesn't create devices in /dev like /dev/scanner etc
>  but we can see devices in /proc/bus/usb/devices

Wait, we have not had a /dev/scanner since the 2.4 days.  For all of the
2.6 releases, usb scanners are controlled from userspace by xscane, not
the kernel.

>  ...
>  T:  Bus=02 Lev=02 Prnt=03 Port=01 Cnt=02 Dev#= 10 Spd=12  MxCh= 0
>  D:  Ver= 1.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
>  P:  Vendor=03f0 ProdID=0601 Rev= 1.00
>  S:  Manufacturer=Hewlett-Packard
>  S:  Product=HP ScanJet 6300C
>  S:  SerialNumber=xxxxxxxxxx
>  C:* #Ifs= 1 Cfg#= 1 Atr=60 MxPwr=  0mA
>  I:* If#= 0 Alt= 0 #EPs= 3 Cls=00(>ifc ) Sub=00 Prot=00 Driver=(none)
>  E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
>  E:  Ad=02(O) Atr=02(Bulk) MxPS=  16 Ivl=0ms
>  E:  Ad=83(I) Atr=03(Int.) MxPS=   1 Ivl=250ms
>  ...
> 
>  it works OK with kernel-2.6.20

What works ok?  Xscane?  Or some external kernel driver?

>  can update udev to version 111 help solve this problem ???

Do you have CONFIG_SYSFS_DEPRECATED enabled?  If not, please read the
help entry for it and enable it.  Please let me know if this solves your
problem or not.

Also, what distro release are you using?

thanks,

greg k-h
