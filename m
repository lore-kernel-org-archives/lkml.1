Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYHYEIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYHYEIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 00:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbYHYEH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 00:07:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYHYEHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 00:07:55 -0400
Date: Sun, 24 Aug 2008 21:07:13 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] PCI: create function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080825040713.GE3128@kroah.com>
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080822182317.GW8318@parisc-linux.org> <20080822195358.GC20820@ldl.fc.hp.com> <20080823154450.GA27985@kroah.com> <20080823200446.GA24936@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080823200446.GA24936@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 02:04:46PM -0600, Alex Chiang wrote:
> * Greg KH <greg@kroah.com>:
> > On Fri, Aug 22, 2008 at 01:53:58PM -0600, Alex Chiang wrote:
> > > 
> > > Does anyone have numbers for how much it costs to create a new
> > > symlink? I could try and figure this out but it will take a few
> > > days (busy with other stuff).
> > 
> > Almost nothing.
> > 
> > sysfs creates these things on the fly as they are accessed, and if
> > memory pressure on the machine happens, they are freed up properly and
> > then created again if a user asks to see them in the tree.
> > 
> > So don't worry about memory issues when adding new files or symlinks in
> > sysfs, it just isn't a problem (we handle 20000 disks easily on low
> > memory 31bit s390 systems.)
> 
> Great, thanks for the explanation.  I've heard the "memory
> overhead" argument before for not wanting to create other sysfs
> files/links, so this will be good to debunk that bogeyman if it
> pops up again in the future.

Yes, please do.

> Did you get a chance to take a look at the documentation I wrote
> for these new symlinks? [I also went and documented the existing
> slots/ directory as well...]
> 
> Was it what you had in mind?

Yes, it looked very good.

And thanks for the other documentation as well, if you want, you could
split that out as a different patch and odds are Jesse could get that
into the tree before 2.6.27 comes out :)

thanks,

greg k-h
