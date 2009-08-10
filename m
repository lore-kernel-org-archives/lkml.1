Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZHJPpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZHJPpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZHJPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:45:15 -0400
Received: from kroah.org ([198.145.64.141]:55444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbZHJPpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:45:14 -0400
Date: Mon, 10 Aug 2009 08:40:29 -0700
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090810154029.GC7652@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <200908081214.39456.a1426z@gawab.com>
 <20090808171124.GA357@kroah.com>
 <200908082155.24686.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908082155.24686.a1426z@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 09:55:24PM +0300, Al Boldi wrote:
> Greg KH wrote:
> > On Sat, Aug 08, 2009 at 12:14:39PM +0300, Al Boldi wrote:
> > > Greg KH wrote:
> > > > On Sat, Aug 08, 2009 at 12:17:31AM +0300, Al Boldi wrote:
> > > > > For devtmpfs to be a realistic replacement for static /dev, it has to
> > > > > be comparable to static /dev in both speed and size.
> > > >
> > > > Since when is this requirement necessary?  You want something for free
> > > > in both speed and size?  Well, you got it in speed, but not size, it
> > > > will take up memory that is swapable, and a tiny ammount of
> > > > non-swapable kernel memory for the code.
> > >
> > > Not so tiny when you count in the hotplug dependency.
> >
> > devtmpfs does not rely on hotplug at all.
> 
> Are you sure?
> 
> This is from the patch of this thread:
> > +config DEVTMPFS
> > +       bool "Create a kernel maintained /dev tmpfs (EXPERIMENTAL)"
> > +       depends on HOTPLUG && SHMEM && TMPFS

Ah, you're right.

Ok then, since you don't run CONFIG_HOTPLUG kernels, why are you worried
about this code at all?

confused,

greg k-h
