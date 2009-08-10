Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZHKUOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZHKUOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZHKUOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:14:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46670 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZHKUOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:14:43 -0400
Date: Mon, 10 Aug 2009 17:54:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
Message-ID: <20090810155431.GA1505@ucw.cz>
References: <20090805171513.GA10443@kroah.com> <20090809120902.GC1338@ucw.cz> <20090810163652.GB28091@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810163652.GB28091@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-08-10 09:36:52, Greg KH wrote:
> On Sun, Aug 09, 2009 at 02:09:02PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > --- /dev/null
> > > +++ b/drivers/base/devtmpfs.c
> > > @@ -0,0 +1,367 @@
> > > +/*
> > > + * devtmpfs - kernel-maintained tmpfs-based /dev
> > > + *
> > > + * Copyright (C) 2009, Kay Sievers <kay.sievers@vrfy.org>
> > > + *
> > 
> > I'd expect GPL notice here...
> 
> But it's not needed, the overall license of the kernel covers it.
> 

Maybe. Maybe not, just add the single line there...

> > > +#if defined CONFIG_DEVTMPFS_MOUNT
> > > +static int dev_mount = 1;
> > > +#else
> > > +static int dev_mount;
> > > +#endif
> > 
> > 
> > A bit too many config options?
> 
> It's only 1 option, is that 1 too many for you?

It is two, and this option duplicates  commandline
option. Maybe its better to use config_cmdline at that point?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
