Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbXB0W4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbXB0W4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 17:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXB0W4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 17:56:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:43707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbXB0W4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 17:56:38 -0500
Date: Tue, 27 Feb 2007 14:55:25 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org
Subject: Re: 2.6.20-almost-rc1: usb oops during resume
Message-ID: <20070227225525.GB26071@kroah.com>
References: <20070224115137.GA8658@elf.ucw.cz> <20070225053746.GA25058@kroah.com> <20070227215846.GD4519@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227215846.GD4519@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 10:58:46PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > ...is it "use after free"?
> > > 
> > > Greg, could we reduce verbosity of driver model? "PM: Adding info for
> > > No Bus:vcs*" is not very useful.
> > 
> > Maybe for you it isn't, but then again, you did enable
> > CONFIG_DEBUG_DRIVER to see that, so you will get a lot of stuff in your
> > logs :)
> 
> I went on to disable that config option, but...
> 
> CONFIG_FW_LOADER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> 
> ...it was disabled.
> 
> Feb 27 22:54:23 amd kernel: PM: Adding info for No Bus:usbdev2.17_ep01
> Feb 27 22:54:23 amd kernel: PM: Adding info for No Bus:usbdev2.17_ep82
> Feb 27 22:54:23 amd kernel: PM: Adding info for No Bus:usbdev2.17_ep83
> Feb 27 22:54:23 amd kernel: PM: Adding info for No Bus:usbdev2.17
> 
> What is going on?

CONFIG_PM_DEBUG  ?

thanks,

greg k-h
