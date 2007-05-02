Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbXEBEVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbXEBEVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbXEBEVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:21:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36806 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbXEBEU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:20:59 -0400
Date: Tue, 1 May 2007 20:59:43 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Dave Airlie <airlied@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Hellstr?m <thomas@tungstengraphics.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
Message-ID: <20070502035943.GD8877@kroah.com>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com> <20070427163951.GA12216@kroah.com> <21d7e9970704301610u5d5132uc282ac697c9df2be@mail.gmail.com> <200705020036.38322.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705020036.38322.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:36:36AM +0200, Ingo Oeser wrote:
> On Tuesday 01 May 2007, Dave Airlie wrote:
> > >   - what's with the /proc interface?  Don't add new proc code for
> > >     non-process related things.  This should all go into sysfs
> > >     somewhere.  And yes, I know /proc/dri/ is there today, but don't add
> > >     new stuff please.
> > 
> > Well we should move all that stuff to sysfs, but we have all the
> > infrastructure for publishing this stuff under /proc/dri and adding
> > new files doesn't take a major amount, as much as I appreciate sysfs,
> > it isn't suitable for this sort of information dump, the whole one
> > value per file is quite useless to provide this sort of information
> > which is uni-directional for users to send to us for debugging without
> > have to install some special tool to join all the values into one
> > place.. and I don't think drmfs is the answer either... or maybe it
> > is....
> 
> Ok, what about debugfs then? If it is just for debugging blobs -> debugfs,
> if it is crucial for operation -> sysfs and representation of one value 
> per file.

You beat me too it :)

Yes, this is _exactly_ what debugfs is for, in fact, it will probably
make your code a bit smaller to use it instead of /proc.

thanks,

greg k-h
