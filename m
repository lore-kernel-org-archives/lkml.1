Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbXA0BwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbXA0BwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 20:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXA0BwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 20:52:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbXA0BwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 20:52:08 -0500
Date: Fri, 26 Jan 2007 17:51:04 -0800
From: Greg KH <greg@kroah.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Kernel 2.6.19.2: Belkin UPS on Serial vs. USB
Message-ID: <20070127015104.GA11553@kroah.com>
References: <Pine.LNX.4.64.0701261250470.12467@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701261250470.12467@p34.internal.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 12:54:02PM -0500, Justin Piszcz wrote:
> When I disconnect my UPS from the wall, I have to wait 15-30 seconds 
> before the USB drier 'polls' this information and tells me that the UPS is 
> on battery power (via knutclient or syslog via nut):
> 
> ups@p34 POWER ALERT on Fri Jan 26 12:49:29 EST 2007
> 
> With a serial connection, I would get the alerts IMMEDIATELY (0.5-1 
> seconds) after disconnecting the UPS.  My new machine does not have a 
> serial port built-in, only a serial header, and of course does not come 
> with an included cable, so I chose to use USB.
> 
> My question is, how do I change the polling time for the USB subsystem to 
> match that of the serial port, or would I not want to do that for other 
> reasons?
> 
> The reason I'd like to is I am not going to see any power alerts for 
> unless there is a power outage for longer than 15-30 seconds.

I think this is a userspace issue, as it's a userspace program that is
doing the polling, right?  Try asking the developers of it about this.

I think you will find it is a FAQ...

thanks,

greg k-h
