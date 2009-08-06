Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZHFUnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZHFUnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZHFUnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:43:15 -0400
Received: from mailhost14.gawab.com ([66.220.20.14]:39113 "HELO
	info88.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756094AbZHFUnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:43:11 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Thu, 6 Aug 2009 23:18:05 +0300
User-Agent: KMail/1.5
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908062006.16263.a1426z@gawab.com> <20090806183653.GC28433@kroah.com>
In-Reply-To: <20090806183653.GC28433@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908062318.05478.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 06, 2009 at 08:06:16PM +0300, Al Boldi wrote:
> > Andi Kleen wrote:
> > > Greg KH <greg@kroah.com> writes:
> > > > It makes the userspace boot process much simpler and easier to
> > > > maintain, as well as providing a way to handle rescue disks and
> > > > images trivially, and it makes the kernel _less_ dependant on the
> > > > early userspace bootup scripts.
> > >
> > > As a initrd less kernel user I can really only agree: getting rid
> > > of the udev-in-initrd requirement would be a big step forward
> > > in usability. Typically I always have to pre populate
> > > a on disk /dev manually first to get my kernels to boot.
> >
> > Oh good, I thought I was the only one doing that.
> >
> > The reason I don't like udev is that it's just to slow; something like a
> > 5-10s delay on each boot.  No idea why it should be so slow, but it's
> > probably probing the kernel for all available devices at boot, when it
> > could be much quicker by probing for the device on access.
>
> Like Kay stated, this sounds like a misconfiguration of your distro's
> udev setup, as the ones I use (openSUSE and Gentoo) do not have this
> problem at all.

Maybe they are using the same trick as Ubuntu and Debian, as they run udev in 
the background to hide the slowness.  Both Fedora and Mandriva run udev in 
the foreground where the slowness is visible.

So really, if devtmpfs compares to udev speeds then this just looks like a 
devfs comeback.  Remember, devfs was really slow.


Thanks!

--
Al

