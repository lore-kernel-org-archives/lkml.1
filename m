Return-Path: <linux-kernel-owner+w=401wt.eu-S934595AbZIEDVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbZIEDVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 23:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934532AbZIEDVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 23:21:48 -0400
Received: from kroah.org ([198.145.64.141]:57374 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbZIEDVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 23:21:47 -0400
Date: Fri, 4 Sep 2009 17:29:26 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090905002926.GA18493@kroah.com>
References: <20090903041429.GA29875@kroah.com>
 <1251967786.3336.19.camel@johannes.local>
 <20090903161734.GA9722@infradead.org>
 <20090903175511.GA24943@kroah.com>
 <20090903184017.GA9784@infradead.org>
 <20090903185546.GB29945@kroah.com>
 <1252109760.27694.0.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252109760.27694.0.camel@violet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 02:16:00AM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> > > > > > And do they come with their own wireless stack too?
> > > > > 
> > > > > Please don't put in the vendor vt6656 driver, it will conflict with a
> > > > > proper mac80211 vt6656 driver a group mentored by me will submit late in
> > > > > the 2.6.32 cycle.
> > > > 
> > > > It's already in the linux-next tree, and is almost merged with the
> > > > vt6655 driver from what I can see.  When your driver goes in I will be
> > > > glad to disable the device ids that it covers, just let me know.
> > > 
> > > vt665_6_ has just one usb device id.  And please make sure to rename the
> > > crap driver to something else than vt6656.ko so that it does not get in
> > > way for the proper driver.
> > 
> > Ok, does vt6656_crap.ko sound good to you?  :)
> 
> can we suffix all of the staging drivers with _crap actually? At least
> for the wireless ones.

Heh, no, the "crap" name is internal only, we don't expose that to
users.

thanks,

greg k-h
