Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbXBNAyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbXBNAyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbXBNAyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:54:00 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:48066 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbXBNAx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:53:59 -0500
Date: Tue, 13 Feb 2007 16:49:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>,
       lud <linux-usb-devel@lists.sourceforge.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: Is this bug too obvious?
Message-Id: <20070213164946.f70d1c8e.randy.dunlap@oracle.com>
In-Reply-To: <45D25ABE.5080400@redhat.com>
References: <45D25ABE.5080400@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 19:41:34 -0500 Chuck Ebbert wrote:

[adding linux-usb-devel]


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
> 
> -


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
