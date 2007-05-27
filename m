Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbXE0OkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbXE0OkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 10:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXE0OkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 10:40:10 -0400
Received: from outpost.ds9a.nl ([213.244.168.210]:35853 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbXE0OkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 10:40:09 -0400
Date: Sun, 27 May 2007 16:40:07 +0200
From: bert hubert <bert.hubert@netherlabs.nl>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: udev regression? lsusb silent (no output) since 2.6.22-rc2 at    least
Message-ID: <20070527144007.GB24564@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
	gregkh@suse.de
References: <20070526201854.GA20758@outpost.ds9a.nl> <1180233755.3131.4.camel@lov.localdomain> <20070527092546.GA10912@outpost.ds9a.nl> <1180275001.3131.28.camel@lov.localdomain> <20070527142017.GA24564@outpost.ds9a.nl> <1180276477.3131.43.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180276477.3131.43.camel@lov.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 04:34:37PM +0200, Kay Sievers wrote:
> older kernels. That's all, and correctly configured kernels don't break
> anything.
> 
> > So instead of papering this breakage over with cleverly worded help texts
> > that suggest a solution, how about we set USB_DEVICE_CLASS to 'y' by default
> > for a few more releases?
> 
> Makes sense, yes.

Good to hear - I also want my kernel to be configured correctly, of course,
but I'm also happy if 'make oldconfig' keeps my correctly configured kernel,
configured correctly.

So USB_DEVICE_CLASS='y' for a few more cycles is like music to my ears. 

> > "Some distributions need this feature for lsusb to work, unless the udev rule
> >  above is configured".
> 
> It's libusb access in general and not specific to lsusb.

"Some distributions need this feature for libusb-based applications (like
 lsusb) to work, unless the udev rule above is configured"

The reason I stress lsusb so much is because for many operators, it is the
first thing they do in case of USB problems 'is my device even there?'.

So it would be what people notice breaking - even though the underlying
issue is with libusb.

Thanks!

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
