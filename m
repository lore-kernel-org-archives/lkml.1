Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYLCHi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYLCHi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYLCHiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:38:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:52217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYLCHiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:38:17 -0500
Date: Tue, 2 Dec 2008 23:12:25 -0800
From: Greg KH <gregkh@suse.de>
To: Keith Packard <keithp@keithp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/serial/cp2101: Add support for cp2103 GPIO pins
Message-ID: <20081203071225.GC12582@suse.de>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com> <1227774576-5503-2-git-send-email-keithp@keithp.com> <20081127105823.30786bf4@lxorguk.ukuu.org.uk> <1227810026.4277.48.camel@aiko.keithp.com> <20081127184109.GA20479@suse.de> <1227835903.4277.69.camel@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227835903.4277.69.camel@aiko.keithp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 05:31:43PM -0800, Keith Packard wrote:
> On Thu, 2008-11-27 at 10:41 -0800, Greg KH wrote:
> 
> > Can you do the same thing here as well?  Or do you also need to
> > send/recieve serial data through the device at the same time?
> 
> I was hoping to use both at the same time; the target device has a
> serial port that I'll need to get working eventually.

Ick.  Ok, care to come up with some kind of hook into the gpio subsystem
of the kernel so we don't create a new user/kernel interface for
something that we already support?

> Besides, libusb scares me, but if that's the officially supported
> mechanism, I can manage; I don't need it to go fast for this
> application.

libusb can be very fast.  The new version handles multiple urbs in
flight, and threaded applications very easily.  You might want to take a
look at it again if it has been a while.

thanks,

greg k-h
