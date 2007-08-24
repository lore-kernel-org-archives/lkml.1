Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbXHXSig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbXHXSig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762965AbXHXSiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:38:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60564 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762682AbXHXSiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:38:13 -0400
Date: Fri, 24 Aug 2007 11:36:53 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matt Colyer <matt@colyer.name>,
       linux-kernel@vger.kernel.org, jeffm@suse.de,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [RFC] USB: driver for iphone charging
Message-ID: <20070824183653.GB14879@kroah.com>
References: <Pine.LNX.4.44L0.0708241006440.3862-100000@iolanthe.rowland.org> <200708241623.13887.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708241623.13887.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 04:23:13PM +0200, Oliver Neukum wrote:
> Am Freitag 24 August 2007 schrieb Alan Stern:
> > On Fri, 24 Aug 2007, Oliver Neukum wrote:
> > 
> > > This schedules the change via a workqueue, so you'll be reprobed. If you
> > > fire of the first vendor command you are doing so before the configuration
> > > is changed. How is this supposed to work?
> > 
> > I would do it like this:
> 
> That makes sense. However, Greg's version might work by putting
> out a magic init sequence and then changing the configuration.
> Then it would just be coded in an obscure way.

Without any docs, this is all obscure :)

> However, does this really belong into kernel space? We have been
> knowing that user space infrastructure for configuration selection
> is necessary and this seems like a fine starting point.

The berry_charge driver is also one that might be done in userspace, but
it turns out that people update their kernel much more than they do
userspace packages...

thanks,

greg k-h
