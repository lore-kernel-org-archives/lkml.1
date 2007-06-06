Return-Path: <linux-kernel-owner+w=401wt.eu-S934401AbXFFFnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbXFFFnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933990AbXFFFnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:43:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56428 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbXFFFnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:43:31 -0400
Date: Tue, 5 Jun 2007 22:34:49 -0700
From: Greg KH <greg@kroah.com>
To: art@usfltd.com
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       michal.k.k.piotrowski@gmail.com
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
Message-ID: <20070606053449.GA20576@kroah.com>
References: <20070605192014.8fscb6wz1wckccg0@67.106.77.50>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605192014.8fscb6wz1wckccg0@67.106.77.50>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 07:20:14PM -0500, art@usfltd.com wrote:
>  sorry for not responding i was busy (i updated my sys to fc7)
>  on fc7-i386 and on fc-x86-64(2.6.22-rc4-cfq7 SMP PREEMPT x86_64 GNU/Linux) i 
>  can't see usb scanner
>  i test this with hp-6300 and aqfa snapscan-1212u
>  non of them triger creation /dev/scanner-xxxxx device
>  xsane cannot see this scanner without this i assume.

Is CONFIG_USB_DEVICE_CLASS enabled in this kernel?

Are _any_ files showing up in /dev/bus/usb/?

thanks,

greg k-h
