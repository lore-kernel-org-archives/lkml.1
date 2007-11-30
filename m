Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXK3GnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXK3GnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 01:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbXK3GnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 01:43:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57055 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbXK3GnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 01:43:11 -0500
Date: Thu, 29 Nov 2007 22:41:13 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] Sample kset/ktype/kobject implementation
Message-ID: <20071130064113.GB14596@kroah.com>
References: <20071129203900.GA27877@kroah.com> <Pine.LNX.4.44L0.0711291708080.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711291708080.5666-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 05:11:35PM -0500, Alan Stern wrote:
> On Thu, 29 Nov 2007, Greg KH wrote:
> 
> > > > > kobject_put(foo) is needed since it gets you through kobject_cleanup()
> > > > > where the name can be freed.
> > > > 
> > > > No, kobject_register() should have handled that for us, right?
> > > 
> > > kobject_register() doesn't do a kobject_put() if kobject_add() failed.
> > 
> > Crap.  If I can't get this code right in an example, the API is messed
> > up.  Time to take Kay seriously and start to revamp the basic kobject
> > api :)
> 
> The rule is simple enough.  After calling kobject_register() you should 
> always use kobject_put() -- even if kobject_register() failed.

Yes.

> In fact, after calling kobject_init() you should use kobject_put().  
> The first rule follows from this one, since kobject_register() calls 
> kobject_init() internally.

Yes, that makes sense, time to write it all down :)

thanks,

greg k-h
