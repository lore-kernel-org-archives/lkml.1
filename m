Return-Path: <linux-kernel-owner+w=401wt.eu-S1763163AbXHVTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763163AbXHVTLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXHVTLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:11:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58309 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXHVTLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:11:39 -0400
Date: Wed, 22 Aug 2007 11:55:44 -0700
From: Greg KH <greg@kroah.com>
To: Nate <stoddarn@msoe.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Restricting CDC-ACM devices
Message-ID: <20070822185544.GA6002@kroah.com>
References: <1187716018.731090.165620@j4g2000prf.googlegroups.com> <20070821171018.C964B5F778@attila.bofh.it> <39877.198.169.188.225.1187733834.squirrel@myweb.msoe.edu> <20070822054615.GA23336@kroah.com> <45719.198.169.188.225.1187793693.squirrel@myweb.msoe.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45719.198.169.188.225.1187793693.squirrel@myweb.msoe.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 09:41:33AM -0500, Nate wrote:
> 
> > Why do you not want to modify the driver?
> 
> Modifying the cdc-acm driver is an alternative; however, I would like to
> avoid that when I'm adding my vendor specific restrictions.  My hope is
> that when patches are made to that file, I don't need to worry about
> someone merging them over the my previous ones.  Is this a bad goal?

Well, just messing with the device ids is not that tough of a patch to
keep up to date over time, so you might just try that if necessary.

> > You can disconnect the device from the driver from userspace for any
> > device you just don't want to have connected by using the sysfs
> > bind/unbind files.  That doesn't require any kernel changes at all.
> 
> I don't fully follow you here.  Are you saying that I can disconnect the
> CDC-ACM driver from my USB device and allow my driver to get a call probe?

Yes.  You can manually bind and unbind all PCI and USB devices from
their drivers from userspace.  So you do have full control over this
already, no kernel changes needed.

thanks,

greg k-h
