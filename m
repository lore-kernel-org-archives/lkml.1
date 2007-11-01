Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXKAGOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXKAGOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 02:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXKAGOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 02:14:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44050 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbXKAGOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 02:14:43 -0400
Date: Wed, 31 Oct 2007 23:19:54 -0700
From: Greg KH <greg@kroah.com>
To: Steven King <sfking@fdwdc.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: ti_usb_3410_5052 breakage in 2.6.24-rc1
Message-ID: <20071101061954.GA11303@kroah.com>
References: <200710312225.44210.sfking@fdwdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710312225.44210.sfking@fdwdc.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 10:25:43PM -0700, Steven King wrote:
>   My TI eZ430 (MSP-FET430UIF JTAG Tool) usb dongle works fine with 2.6.23.1 
> and earlier, but doesn't work with 2.6.24-rc1; the ti_usb_3410_5052 module is 
> loaded but the device descriptor is bogus, reporting only a single 
> configuration, whereas in 2.6.23.1 it reports 2 configurations, allowing one 
> to select the second configuration to get a serial port.
> 
> git bisect fingered this commit:
> 
> 063a2da8f01806906f7d7b1a1424b9afddebc443 "USB: serial core should respect 
> driver requirements"

Can you send me a copy of /proc/bus/usb/devices with this device plugged
in?

thanks,

greg k-h
