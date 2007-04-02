Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXDBHmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXDBHmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXDBHmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:42:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:36663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbXDBHmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:42:10 -0400
Date: Mon, 2 Apr 2007 00:42:10 -0700
From: Greg KH <greg@kroah.com>
To: Li Yu <raise.sail@gmail.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Jiri Kosina <jkosina@suse.cz>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Message-ID: <20070402074210.GA25320@kroah.com>
References: <200703051532096508636@gmail.com> <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz> <4610609C.9030101@gmail.com> <200704020015.44167.dtor@insightbb.com> <4610ABB1.3080606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4610ABB1.3080606@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 03:07:29PM +0800, Li Yu wrote:
> Dmitry Torokhov wrote:
> >
> > No, please don't do that. As soon as there is a special driver written
> > for a device that device's VID/PID should be added to generic HID
> > blacklist. This way udev will load the proper driver right away and
> > there will not be any flip-flopping of input devices. 
> >   
> Hi, I do not think that using blacklist in base driver for this purpose
> is good idea. If so, we need modify source when each new HID device
> driver come, that's so ugly. I think the blacklist only should be used
> for those really broken/buggy hardware, not for these normal hardware
> with extended feature.
> 
> Er, I also want to know what are drawbacks of "flip-flopping" ?

You have to create some kind of userspace program to disconnect the
device from the hid driver, and bind it to the new driver, for every new
device/driver that comes along.

Yes, you can do this, but the blacklist is simpler and easier.

thanks,

greg k-h
