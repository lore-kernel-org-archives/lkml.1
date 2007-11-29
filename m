Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbXK2GJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbXK2GJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXK2GIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:08:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59854 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbXK2GIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:08:53 -0500
Date: Wed, 28 Nov 2007 22:02:09 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129060209.GD26327@kroah.com>
References: <20071127230252.GB10038@kroah.com> <20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com> <1196252582.3242.28.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196252582.3242.28.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 01:23:02PM +0100, Kay Sievers wrote:
> On Wed, 2007-11-28 at 12:45 +0100, Cornelia Huck wrote:
> > On Tue, 27 Nov 2007 15:02:52 -0800, Greg KH <greg@kroah.com> wrote:
> 
> > > A kset serves these functions:
> > > 
> > >  - It serves as a bag containing a group of objects. A kset can be used by
> > >    the kernel to track "all block devices" or "all PCI device drivers."
> > > 
> > >  - A kset is also a subdirectory in sysfs, where the associated kobjects
> > >    with the kset can show up.  
> > 
> > Perhaps better wording:
> > 
> > A kset is also represented via a subdirectory in sysfs, under which the
> > kobjects associated with the kset can show up.
> 
> This draws a misleading picture. A member of a kset shows up where the
> "parent" pointer points to. Like /sys/block is a kset, the kset contains
> disks and partitions, but partitions do not live at the kset, and tons
> of other kset directories where this is the case.
> 
> "If the kobject belonging to a kset has no parent kobject set, it will
> be added to the kset's directory. Not all members of a kset do
> necessarily live in the kset directory. If an explicit parent kobject is
> assigned before the kobject is added, the kobject is registered with the
> kset, but added below the parent kobject."

Nice, thanks, I've added this :)

greg k-h
