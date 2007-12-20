Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbXLTWVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbXLTWVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765474AbXLTWVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:21:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32823 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765209AbXLTWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:21:13 -0500
Date: Thu, 20 Dec 2007 14:12:52 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
Message-ID: <20071220221252.GA16431@kroah.com>
References: <20071220003031.GA15129@kroah.com> <20071219223206.ada18362.randy.dunlap@oracle.com> <20071220212700.GB5808@kroah.com> <20071220140659.71f6cce6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220140659.71f6cce6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 02:06:59PM -0800, Randy Dunlap wrote:
> On Thu, 20 Dec 2007 13:27:00 -0800 Greg KH wrote:
> > On Wed, Dec 19, 2007 at 10:32:06PM -0800, Randy Dunlap wrote:
> > > On Wed, 19 Dec 2007 16:30:31 -0800 Greg KH wrote:
> > > >     int kobject_uevent(struct kobject *kobj, enum kobject_action action);
> > > > 
> > > > Use the KOBJ_ADD action for when the kobject is first added to the kernel.
> > > > This should be done only after any attributes or children of the kobject
> > > > have been initialized properly, as userspace will instantly start to look
> > > 
> > > 		s/will/may/
> > 
> > No, it's usually a "will", as udev is damm fast these days :)
> 
> But that's the point.  It assumes that udev is being used.  :(

Yes, kernel developers need to be aware that udev _will_ be used, you
can not do things that will assume it is not running.

> Who is your spell checker?

vim :)

thanks,

greg k-h
