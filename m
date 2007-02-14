Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbXBNBGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbXBNBGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXBNBGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:06:51 -0500
Received: from iabervon.org ([66.92.72.58]:4065 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208AbXBNBGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:06:49 -0500
Date: Tue, 13 Feb 2007 20:06:48 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: Is this bug too obvious?
In-Reply-To: <45D25ABE.5080400@redhat.com>
Message-ID: <Pine.LNX.4.64.0702132000220.20138@iabervon.org>
References: <45D25ABE.5080400@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Chuck Ebbert wrote:

> drivers/usb/net/usbnet.c:
> 
> int
> usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
> {
>         struct usbnet                   *dev;
>         struct net_device               *net;
>         struct usb_host_interface       *interface;
>         struct driver_info              *info;
>         struct usb_device               *xdev;
>         int                             status;
> 
> 	...
> 
>         net = alloc_etherdev(sizeof(*dev));
>                                     ^^^^
> 	                            *net ???

No, alloc_etherdev takes the size of the private data, which, in this 
case, is *dev.

	-Daniel
*This .sig left intentionally blank*
