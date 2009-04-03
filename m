Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbZDCPEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbZDCPEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbZDCPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:04:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:46267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbZDCPE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:04:29 -0400
Date: Fri, 3 Apr 2009 08:03:01 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090403150301.GA25846@suse.de>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403135719.GD19774@srcf.ucam.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 02:57:19PM +0100, Matthew Garrett wrote:
> On Thu, Apr 02, 2009 at 07:56:54PM -0700, Greg KH wrote:
> 
> > But, I have heard reports of people dual-booting with other operating
> > systems and then successfully using the device under Linux with the
> > qcserial driver, so that is one solution for some users.
> 
> So it's a driver that's useless without a closed source firmware loader, 
> either in the form of a Linux userspace application that can't be 
> distributed or in the form of Windows?

Hm, I originally thought that as well, but I have a laptop here that
doesn't seem to need the firmware code at all (I deleted it and rebooted
from poweroff and everything worked fine.)

So it seems it depends on the hardware platform.

> I thought we'd decided that drivers weren't going to be merged in that
> case (poulsbow, the original 3945 driver)

We have lots of drivers that rely on firmware that is not in the kernel
to work properly, I see this as just the same thing.

And again, I have been assured that the code is going to be distributed
soon, and that others are already using the driver successfully.

I understand your frustration, sorry.

greg k-h
