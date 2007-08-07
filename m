Return-Path: <linux-kernel-owner+w=401wt.eu-S936940AbXHGVnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936940AbXHGVnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937060AbXHGVTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:19:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48894 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937053AbXHGVTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:19:16 -0400
Date: Tue, 7 Aug 2007 14:18:47 -0700
From: Greg KH <greg@kroah.com>
To: Niels <zorglub_olsen@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with USB disk
Message-ID: <20070807211847.GA25391@kroah.com>
References: <f9akh8$ori$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9akh8$ori$1@sea.gmane.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 10:26:15PM +0200, Niels wrote:
> Hi,
> 
> I'm having problems with a new 500 GB USB disk. It works, but sometimes I
> get these in dmesg:
> 
> 
> usb 1-3: reset high speed USB device using ehci_hcd and address 2
> usb 5-1: USB disconnect, address 2
> drivers/usb/class/usblp.c: usblp0: removed
> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
> : ASC=0x4 ASCQ=0x2
> end_request: I/O error, dev sda, sector 254148215
> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
> : ASC=0x4 ASCQ=0x2
> end_request: I/O error, dev sda, sector 252434023
> EXT3-fs error (device sda1): ext3_find_entry: reading directory #15761836
> offset 0
> 
> 
> There's also a printer connected. This is on a pci/usb2 card. When the above
> happens, I get I/O errors. When I mount the drive next, there are errors
> and often missing files. Quite annoying!
> 
> Kernel is 2.6.21
> 
> What's going on?

You have a low voltage issue, or a bad cable.  The device is
electronically disconnecting itself.  Try using a externally-powered
hub, or a new cable.

thanks,

greg k-h
