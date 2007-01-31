Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbXAaBFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbXAaBFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXAaBFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:05:00 -0500
Received: from ns.suse.de ([195.135.220.2]:52078 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbXAaBE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:04:59 -0500
Date: Tue, 30 Jan 2007 17:03:53 -0800
From: Greg KH <greg@kroah.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [linux-usb-devel] 2.6.20-rc6 SCSI error: I/O error - trouble with mass storage devices ?!
Message-ID: <20070131010353.GA30713@kroah.com>
References: <fa.PeThxrKzzfWoGYao97lEVEZgJlc@ifi.uio.no> <fa.SlST1aKbNgZSghdvI9esD81kVnI@ifi.uio.no> <45BFD0F6.9040201@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BFD0F6.9040201@shaw.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 05:12:54PM -0600, Robert Hancock wrote:
> Alan Stern wrote:
> 
> >The log revealed that the phone's firmware returns garbage values in the 
> >Residue field for some WRITEs.  This patch should take care of it.
> >
> >Alan Stern
> 
> Is it just me, or should some of these device quirk entries that keep 
> being added be made unconditional? Adding entries for every single 
> device that shows up with these problems seems like not a very scalable 
> approach. These devices obviously work in Windows, can't we just emulate 
> its behavior here?

If you can figure out a way to dynamically detect broken devices like
this, sure, that would be great.

thanks,

greg k-h
