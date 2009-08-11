Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZHKMsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZHKMsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZHKMsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:48:11 -0400
Received: from mailhost13.gawab.com ([66.220.20.13]:42437 "HELO
	info15.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751837AbZHKMsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:48:10 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Tue, 11 Aug 2009 06:48:26 +0300
User-Agent: KMail/1.5
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908082155.24686.a1426z@gawab.com> <20090810154029.GC7652@kroah.com>
In-Reply-To: <20090810154029.GC7652@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908110648.26191.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Aug 08, 2009 at 09:55:24PM +0300, Al Boldi wrote:
> > Greg KH wrote:
> > > On Sat, Aug 08, 2009 at 12:14:39PM +0300, Al Boldi wrote:
> > > > Greg KH wrote:
> > > > > On Sat, Aug 08, 2009 at 12:17:31AM +0300, Al Boldi wrote:
> > > > > > For devtmpfs to be a realistic replacement for static /dev, it
> > > > > > has to be comparable to static /dev in both speed and size.
> > > > >
> > > > > Since when is this requirement necessary?  You want something for
> > > > > free in both speed and size?  Well, you got it in speed, but not
> > > > > size, it will take up memory that is swapable, and a tiny ammount
> > > > > of non-swapable kernel memory for the code.
> > > >
> > > > Not so tiny when you count in the hotplug dependency.
> > >
> > > devtmpfs does not rely on hotplug at all.
> >
> > Are you sure?
> >
> > This is from the patch of this thread:
> > > +config DEVTMPFS
> > > +       bool "Create a kernel maintained /dev tmpfs (EXPERIMENTAL)"
> > > +       depends on HOTPLUG && SHMEM && TMPFS
>
> Ah, you're right.
>
> Ok then, since you don't run CONFIG_HOTPLUG kernels, why are you worried
> about this code at all?
>
> confused,

Linux used to be lean and mean which made it fun to work with, and which made 
the switch from the competition easy.  Nowadays I see a lot of bloat going 
into the kernel which may indicate that Linux is starting to run out of 
steam.  devtmpfs seems bloaty due to the hotplug dependency.


Thanks!

--
Al

