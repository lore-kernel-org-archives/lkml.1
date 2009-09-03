Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZICR7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZICR7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZICR7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:59:45 -0400
Received: from kroah.org ([198.145.64.141]:34846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbZICR7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:59:44 -0400
Date: Thu, 3 Sep 2009 10:55:11 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090903175511.GA24943@kroah.com>
References: <20090903041429.GA29875@kroah.com>
 <1251967786.3336.19.camel@johannes.local>
 <20090903161734.GA9722@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903161734.GA9722@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 12:17:34PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 03, 2009 at 10:49:46AM +0200, Johannes Berg wrote:
> > > 	- vt66* wireless drivers.  These VIA drivers are being actively
> > > 	  worked on to get into a much better shape.  Nice job.
> > 
> > And do they come with their own wireless stack too?
> 
> Please don't put in the vendor vt6656 driver, it will conflict with a
> proper mac80211 vt6656 driver a group mentored by me will submit late in
> the 2.6.32 cycle.

It's already in the linux-next tree, and is almost merged with the
vt6655 driver from what I can see.  When your driver goes in I will be
glad to disable the device ids that it covers, just let me know.

thanks,

greg k-h
