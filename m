Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYHIEjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYHIEjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 00:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbYHIEjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 00:39:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:52810 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYHIEjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 00:39:40 -0400
Date: Fri, 8 Aug 2008 21:38:25 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Policy re. cellular USB modem mode switch
Message-ID: <20080809043825.GA27176@kroah.com>
References: <20080809044530.193a077a@ors.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809044530.193a077a@ors.home>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 04:45:30AM +0200, Oliver Martin wrote:
> Hello,
> 
> trying to get my ZTE MF628 HSDPA modem to work left me wondering if
> there is an established policy whether or not to include the "mode
> switch" code most cellular USB modems need in the kernel or not.

Questions like this have been hashed out numerous times already on the
linux-usb mailing list.

> Currently, the MF628 requires a userspace helper called usb_modeswitch
> to be called [1] to change from mass storage mode to serial mode.
> After, that it can be used with the usbserial driver or preferably,
> after one adds the right vendor and product id, with the option driver.

Never use the usbserial generic driver with a device you actually want
to go fast :)

The option driver is better.

For switching modes, use the userspace program, it's not going to be
done within the kernel.  See the linux-usb archives for details.

thanks,

greg k-h
