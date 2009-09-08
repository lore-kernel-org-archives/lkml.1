Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZIHBXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZIHBXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 21:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZIHBXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 21:23:10 -0400
Received: from kroah.org ([198.145.64.141]:57232 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZIHBXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 21:23:10 -0400
Date: Mon, 7 Sep 2009 18:14:58 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090908011458.GA29317@kroah.com>
References: <20090903041429.GA29875@kroah.com>
 <20090907202134.4feebe6f@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907202134.4feebe6f@caramujo.chehab.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 08:21:34PM -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 2 Sep 2009 21:14:30 -0700
> 
> > 	- go7007.  Ugh.  Unless someone steps up now to take this over,
> > 	  it's going to be removed in .33.  There is no hardware made
> > 	  with this anymore, and no specs around that I know of, and the
> > 	  code isn't the nicest in the world.
> 
> I think nobody will cry if you remove this one. This is an old hardware, and not
> manufactured anymore. The chipset of the compression hardware is
> obsolete and orphaned, as the audio/video unit were sold to another company.

I agree.  I do have a device around here, but it was only for testing,
the company who produced it said they could not release the specs due to
ownership issues.

> > 	- udlfb.  Video over USB, it doesn't get anymore whacked than
> > 	  that.  This is still being developed but the developer doesn't
> > 	  like to do incremental updates for some odd reason.  Hopefully
> > 	  he pops up again with an update.  But for now, it is quite
> > 	  workable for a number of developers.
> 
> Is this a video streaming driver (like other V4L2 drivers) or a video adapter
> driver?

Video adapter driver, it's a frame buffer driver, sorry for any
confusion.

thanks,

greg k-h
