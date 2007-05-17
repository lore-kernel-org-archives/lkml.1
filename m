Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbXEQMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbXEQMsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbXEQMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:48:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34440 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbXEQMsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:48:15 -0400
Date: Thu, 17 May 2007 05:45:25 -0700
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: ark3116_driver@auctionant.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] ark3116: receive returns negative
Message-ID: <20070517124525.GC20055@kroah.com>
References: <Pine.LNX.4.61.0705161743250.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705161743250.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 06:04:45PM +0200, Jan Engelhardt wrote:
> Hello,
> 
> 
> I seem to have problems with the ark3116 driver from 2.6.18.8. This is a 
> USB-RS232 cable. Just opening the /dev/ttyUSB0 device 
> gives (this is the 
> debug output enabled by `modprobe ark3116 debug=1`).
> 
> The lines that look suspicious are
> /serial/ark3116.c: 124 < 1 bytes [0xFFFFFFB0]
> and
> /serial/ark3116.c: ark3116_ioctl cmd 0x5401 not supported

Why is this suspicious?  We don't support all ioctls for all usb-serial
drivers, perhaps this one is just not really needed?

> I have also seen things like "id here < -62 [0x10]", which would 
> indicate that usb_control_msg() returned something very negative 
> (-ETIME!?).

But does the driver seem to work properly?

> Issuing a write() on an open fd to ttyUSB does not generate any further 
> debug output. Is the driver even complete/functional?

Do you get data through the device properly?

thanks,

greg k-h
