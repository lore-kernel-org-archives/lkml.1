Return-Path: <linux-kernel-owner+w=401wt.eu-S936124AbYBAFJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936124AbYBAFJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765946AbYBAFJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:09:12 -0500
Received: from mail.suse.de ([195.135.220.2]:45644 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbYBAFJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:09:09 -0500
Date: Thu, 31 Jan 2008 21:02:29 -0800
From: Greg KH <gregkh@suse.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Nick Piggin <npiggin@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25 (USB driver api)
Message-ID: <20080201050229.GB23057@suse.de>
References: <1201829922.23523.68.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201829922.23523.68.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------------------------
> Ping?
> What:	USB driver API moves to EXPORT_SYMBOL_GPL
> When:	February 2008
> Files:	include/linux/usb.h, drivers/usb/core/driver.c
> Why:	The USB subsystem has changed a lot over time, and it has been
> 	possible to create userspace USB drivers using usbfs/libusb/gadgetfs
> 	that operate as fast as the USB bus allows.  Because of this, the USB
> 	subsystem will not be allowing closed source kernel drivers to
> 	register with it, after this grace period is over.  If anyone needs
> 	any help in converting their closed source drivers over to use the
> 	userspace filesystems, please contact the
> 	linux-usb-devel@lists.sourceforge.net mailing list, and the developers
> 	there will be glad to help you out.
> Who:	Greg Kroah-Hartman <gregkh@suse.de>

This is queued up in my tree to go to Linus, see my previous post on
lkml and the linux-usb mailing list about this topic.

thanks,

greg k-h
