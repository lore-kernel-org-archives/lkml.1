Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYK0Soj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYK0Soj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYK0So2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:44:28 -0500
Received: from mx1.suse.de ([195.135.220.2]:53800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYK0So1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:44:27 -0500
Date: Thu, 27 Nov 2008 10:41:09 -0800
From: Greg KH <gregkh@suse.de>
To: Keith Packard <keithp@keithp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/serial/cp2101: Add support for cp2103 GPIO pins
Message-ID: <20081127184109.GA20479@suse.de>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com> <1227774576-5503-2-git-send-email-keithp@keithp.com> <20081127105823.30786bf4@lxorguk.ukuu.org.uk> <1227810026.4277.48.camel@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227810026.4277.48.camel@aiko.keithp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 10:20:26AM -0800, Keith Packard wrote:
> On Thu, 2008-11-27 at 10:58 +0000, Alan Cox wrote:
> 
> > Only concern I have is that a custom ioctl means every time a new serial
> > chip grows GPIO pins we end up with more ioctls.
> 
> I'm not sure we'll find a lot of serial chips with GPIO pins attached...

Yes, there are a number of other ones already in use that have them.
What we have done in the past for them is just use a simple userspace
program/library that uses usbfs/libusb to access the device directly.

Can you do the same thing here as well?  Or do you also need to
send/recieve serial data through the device at the same time?

thanks,

greg k-h
