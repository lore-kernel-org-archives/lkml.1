Return-Path: <linux-kernel-owner+w=401wt.eu-S934277AbXK2Whp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277AbXK2Whp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932669AbXK2WhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:37:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41433 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbXK2WhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:37:02 -0500
Date: Thu, 29 Nov 2007 14:24:21 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: kobject_init rewrite
Message-ID: <20071129222421.GA15840@kroah.com>
References: <20071129215304.GA5043@kroah.com> <Pine.LNX.4.44L0.0711291713330.6294-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711291713330.6294-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 05:16:28PM -0500, Alan Stern wrote:
> On Thu, 29 Nov 2007, Greg KH wrote:
> 
> > Ok, how about this function.  If it errors out, it is free to just call
> > kfree() on the kobject.  Seems simple enough to me, any objections?  If
> > not, I'll go through and fix up the whole tree...
> 
> Looks good, _provided_ you also get rid of kobject_register().  Which 
> you pretty much would have to do anyway, since it doesn't accept the 
> ktype or the name as an argument.

Yes, I would do that at the same time.

Well, not at the _exact_ same time, it might take a few patches to get
there :)

thanks for the review,

greg k-h
