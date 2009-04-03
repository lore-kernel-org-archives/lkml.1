Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbZDCPMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbZDCPMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZDCPMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:12:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42029 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759984AbZDCPMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:12:36 -0400
Date: Fri, 3 Apr 2009 16:12:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090403151232.GA21657@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403150301.GA25846@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 08:03:01AM -0700, Greg KH wrote:
> On Fri, Apr 03, 2009 at 02:57:19PM +0100, Matthew Garrett wrote:
> > So it's a driver that's useless without a closed source firmware loader, 
> > either in the form of a Linux userspace application that can't be 
> > distributed or in the form of Windows?
> 
> Hm, I originally thought that as well, but I have a laptop here that
> doesn't seem to need the firmware code at all (I deleted it and rebooted
> from poweroff and everything worked fine.)
> 
> So it seems it depends on the hardware platform.

Hmm. What's the USB ID of that one?

> > I thought we'd decided that drivers weren't going to be merged in that
> > case (poulsbow, the original 3945 driver)
> 
> We have lots of drivers that rely on firmware that is not in the kernel
> to work properly, I see this as just the same thing.

It's not that it relies on firmware - I can get my hands on the firmware 
easily enough. The issue is that I have no way of loading it without 
using non-free code, which I think puts it in the same category as 
Poulsbo and ipw3945 rather than, say, b43.

> And again, I have been assured that the code is going to be distributed
> soon, and that others are already using the driver successfully.

Everything I've been able to find suggests that the only people using it 
are booting Windows first, so your one seems to be the oddity. On the 
other hand, I'm kind of surprised that we're merging drivers on the 
promise that code to use them will be available "soon". It seems to end 
up giving the vendor credit that they don't deserve as yet.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
