Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbZCGTwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbZCGTwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 14:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbZCGTwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 14:52:36 -0500
Received: from kroah.org ([198.145.64.141]:60991 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752461AbZCGTwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 14:52:35 -0500
Date: Sat, 7 Mar 2009 11:52:25 -0800
From: Greg KH <greg@kroah.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
	printer to fail
Message-ID: <20090307195225.GA2585@kroah.com>
References: <1236453644.6077.68.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236453644.6077.68.camel@maxim-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 09:20:44PM +0200, Maxim Levitsky wrote:
> Hi,
> 
> Short summary:
> 
> I have HP1018 printer, and it works well in windows.
> When I use in in linux, I often see messages like:
> 
> usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110
> 
> This is using hp backend that talks to printer using usbfs.
> I also tried usblp, but it just doesn't say anything in kernel log. I
> think it silently ignores similar errors, because the end result is the
> same, the printer sometimes works, but sometimes doesn't.
> (printer needs firmware to be uploaded to it, and I do upload it).
> 
> On the other hand, IF I remove _ether_ ehci-hcd or uhci-hcd from kernel,
> then everything works fine, I already rebooted the printer many times,
> used it to print, upload firmware, and everything just work, but as soon
> as I load the second driver it fails in same way again.
> 
> USB issues with this class of printers are nothing but new, for example
> see:
> 
> http://foo2zjs.rkkda.com/forum/read.php?9,374
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/54419

What kernel version are you using?

> I compiled without CONFIG_USB_EHCI_ROOT_HUB_TT
> and it did help (didn't that much testing, but at least firmware loads
> ok, and no error messages)

Can you provide the full kernel log messages from when you plug in your
printer?  Are there any other messages saying that you need to be sure
to load one driver before the other?

thanks,

greg k-h
